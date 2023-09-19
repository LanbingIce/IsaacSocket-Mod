-- 注册Mod，暴露接口
local isaacSocketMod = RegisterMod("IsaacSocket", 1)
-- 接口的具体定义在最底部
IsaacSocket = {}

----------------------------------------------------------------
-- 常量定义
-- 头部长度：6字节
-- 1字节page,1字节replyPage，4字节replySize

local DATA_HEAD_SIZE = 1 + 1 + 4
----------------------------------------------------------------
-- 枚举类型定义
-- 内存连接状态：未连接/已连接
local ConnectionState = {
    DISCONNECTED = 0,
    CONNECTING = 1,
    CONNECTED = 2,
    UNLOADING = 3,
    UNLOADED = 4
}
-- 回调类型与消息通道枚举，从common模块中引入
local CallbackType = require("common").ModuleCallbackType
local Channel = require("common").Channel
----------------------------------------------------------------
-- 变量定义
-- 模块列表
local modules
-- 交换区的内存大小和最大数据体长度
local dataSpaceSize
local dataBodySize
-- 用于发送/接收数据的变量，整个Mod最关键的变量，命名风格不同是为了体现出其需要被外部程序读写的特点
local ext_send
local ext_receive
-- 用于生成发送数据和用于解析接收数据的表，分别对应ext_send和ext_receive
local sendTable
local receiveTable
-- 心跳包计时器，每帧+1，到达300会发送心跳包，到达360会超时
local heartbeatTimer
-- 连接状态，取枚举型ConnectionState的值
local connectionState
-- debug模式
local debugMode = false
----------------------------------------------------------------
-- 类定义
-- 接收表
local function NewReceiveTable()
    local page
    local replyPage
    local size
    local replySize
    local messages
    local buffer

    local object = {}

    function object.GetPage()
        return page
    end
    function object.GetSize()
        return size
    end
    function object.GetReplyPage()
        return replyPage
    end
    function object.GetReplySize()
        return replySize
    end
    function object.GetMessage()
        return table.remove(messages, 1)
    end

    function object.Initialize()
        page = 0
        size = 0
        replyPage = 0
        replySize = 0
        messages = {}
        buffer = {}
    end

    function object.Update(receiveData)
        if #receiveData < DATA_HEAD_SIZE then
            return false
        end
        local oldPage = page
        local oldReplyPage = replyPage
        local oldReplySize = replySize
        local oldSize = size
        local offset
        page, replyPage, replySize, offset = string.unpack("<I1I1I4", receiveData)

        -- 如果上次收到的和这次收到的是同一页数据，更新 offset，忽略已接收的数据
        if oldPage == page then

            offset = offset + oldSize

        end
        -- 检查剩余空间，如果足够，可能存在新消息，执行循环

        while #receiveData - (offset - 1) >= 5 do
            -- 取出下一条消息的尺寸
            local messageSize = string.unpack("<I4", receiveData, offset)
            -- 如果尺寸为 0，表示没有新消息，跳出循环
            if messageSize == 0 then
                break
            end
            offset = offset + 4

            -- 根据消息尺寸，取出数据放入缓冲区，并判断是否完整接收到一条消息
            local data = string.sub(receiveData, offset, offset + messageSize - 1)
            table.insert(buffer, data)
            if #data == messageSize then
                table.insert(messages, table.concat(buffer))
                buffer = {}
            end
            offset = offset + #data
        end
        size = offset - 1 - DATA_HEAD_SIZE
        -- 比较更新前后的数据，若有不同则更新并返回 true，否则返回 false

        return replyPage ~= oldReplyPage or replySize ~= oldReplySize or page ~= oldPage or size ~= oldSize
    end
    object.Initialize()
    return object
end
-- 发送表
local function NewSendTable()
    local replySize
    local page
    local replyPage
    local size
    local buffer
    local messages

    local object = {}

    function object.Initialize()
        size = 0
        replySize = 0
        page = 0
        replyPage = 0
        buffer = {}
        messages = {}
    end

    function object.AddNewMessage(newMessage)
        if connectionState == ConnectionState.CONNECTED then
        table.insert(messages, newMessage)
            return true
        end
        return false
    end

    function object.Update()

        -- 备份更新前的数据
        local oldPage = page
        local oldSize = size
        local oldReplyPage = replyPage
        local oldReplySize = replySize
        replyPage = receiveTable.GetPage()
        replySize = receiveTable.GetSize()

        if oldSize > 0 and receiveTable.GetReplyPage() == oldPage and receiveTable.GetReplySize() == oldSize then
            page = page % 255 + 1
            buffer = {}
            size = 0
        end

        while dataBodySize - size >= 5 and #messages > 0 do
            local firstMessage = table.remove(messages, 1)
            table.insert(buffer, string.pack("<I4", #firstMessage))
            size = size + 4
            local spaceLeft = dataBodySize - size
            if spaceLeft < #firstMessage then
                table.insert(messages, 1, string.sub(firstMessage, spaceLeft + 1))
                firstMessage = string.sub(firstMessage, 1, spaceLeft)
            end
            table.insert(buffer, firstMessage)
            size = size + #firstMessage
        end
        return page ~= oldPage or size ~= oldSize or replySize ~= oldReplySize or replyPage ~= oldReplyPage
    end
    -- 将发送表序列化为二进制数据，方法是生成头部，然后和数据相连
    function object.Serialize()
        return string.pack("<I1I1I4", page, replyPage, replySize) .. table.concat(buffer)
    end

    object.Initialize()
    return object
end

-- 心跳包计时器
local function NewHeartBeatTimer(callback)
    local timer
    local CallbackSend

    local HEARTBEAT_INTERVAL = 2 * 60
    local HEARTBEAT_TIMEOUT = 1 * 60

    local object = {}

    function object.Update(received)
        timer = timer + 1
        if received then
            timer = 0
        elseif timer > HEARTBEAT_INTERVAL + HEARTBEAT_TIMEOUT then
            return false
        elseif timer == HEARTBEAT_INTERVAL then
            CallbackSend(Channel.HEARTBEAT, "")
        end
        return true
    end
    CallbackSend = callback
    timer = 0

    return object
end

----------------------------------------------------------------
-- 普通函数定义
-- 

local function cw(text)
    if debugMode then
        return print("*IsaacSocket: " .. text)
    end
end

local function Send(channel, data)
    return sendTable.AddNewMessage(string.pack("<I1", channel) .. data)
end

-- 更新内存连接状态，同时进行收发数据，需要每帧运行60次
local function Update()
    if connectionState == ConnectionState.CONNECTED then
        -- 正常连接状态
        -- 解析接收变量，如果成功更新，说明有新消息，将心跳包计时器置为 0
        if heartbeatTimer.Update(receiveTable.Update(ext_receive)) then
            local newMessage = receiveTable.GetMessage()
            while newMessage do
                local messageChannel, messageOffset = string.unpack("<I1", newMessage)
                -- 虽然这边不可能收到心跳包，但还是判断一下
                if messageChannel ~= Channel.HEARTBEAT then
                    local messageBody = string.sub(newMessage, messageOffset)
                    modules[messageChannel].ReceiveMemoryMessage(messageBody)
                end
                newMessage = receiveTable.GetMessage()
            end

            -- 更新发送表，如果有新消息，对发送表进行序列化并赋值给发送变量
            if sendTable.Update() then
                ext_send = sendTable.Serialize(receiveTable)
            end
        else
            connectionState = ConnectionState.DISCONNECTED
            cw("Timeout")
            -- 触发所有模块的断开连接事件
            for _, module in pairs(modules) do
                module.DisConnected()
            end
        end
    elseif connectionState == ConnectionState.CONNECTING then
        -- 未连接状态下，接收和发送变量的值都为约定好的特殊值，如果它们的值变化，说明它们的地址已被外部程序找到
        -- 发送变量的值会被设为1，接收变量的值会被设为消息空间尺寸，尺寸的范围是64B到4MB，如果不在范围内，会将模块初始化
        -- 然后，将它们初始化为字符串，将状态置为已连接，然后可以正常通讯
        -- 发送变量的初始字符串由函数生成，接收变量的初始字符串为全部填充0x00
        if ext_send == 2128394904 and ext_receive == 1842063751 then
            return
        elseif ext_send == 1 and ext_receive >= 64 and ext_receive <= 4 * 1024 * 1024 then
            dataSpaceSize = ext_receive
            dataBodySize = dataSpaceSize - DATA_HEAD_SIZE
            heartbeatTimer.Update(true)
            sendTable.Initialize()
            receiveTable.Initialize()

            ext_receive = string.rep("\0", dataSpaceSize)
            ext_send = sendTable.Serialize()
            connectionState = ConnectionState.CONNECTED
            cw("Connected[" .. dataSpaceSize .. "]")
            -- 触发所有模块的已连接事件
            for _, module in pairs(modules) do
                module.Connected()
            end

        else
            connectionState = ConnectionState.DISCONNECTED
            cw("Connect Error")
        end
    elseif connectionState == ConnectionState.UNLOADED then
        connectionState = ConnectionState.DISCONNECTED
        cw("Loaded")
    elseif connectionState == ConnectionState.UNLOADING then
        connectionState = ConnectionState.UNLOADED
        cw("Unloaded")
        ext_send = nil
        ext_receive = nil
    elseif connectionState == ConnectionState.DISCONNECTED then
        connectionState = ConnectionState.CONNECTING
        cw("Connecting...")
        ext_send = 2128394904
        ext_receive = 1842063751
    end
end
----------------------------------------------------------------
-- 回调函数定义

-- 模块回调
local function ModuleCallback(callbackType, channel, message)
    if callbackType == CallbackType.MEMORY_MESSAGE_GENERATED and connectionState == ConnectionState.CONNECTED then
        return Send(channel, message)
    elseif callbackType == CallbackType.PRINT then
        cw("Channel " .. channel .. ":" .. message)
    end
end

-- 画面渲染
local function OnRender()
    Update()
end

-- Mod被卸载时（包括重新加载）

local function OnUnload(_, mod)
    if connectionState == ConnectionState.UNLOADED then
        return
    end

    if connectionState == ConnectionState.CONNECTED then
        connectionState = ConnectionState.DISCONNECTED
        for _, module in pairs(modules) do
            module.DisConnected()
        end
    end

    connectionState = ConnectionState.UNLOADING
    Update()

end

----------------------------------------------------------------
-- 此处代码在Mod被加载时运行
connectionState = ConnectionState.UNLOADED
Update()

heartbeatTimer = NewHeartBeatTimer(Send)
receiveTable = NewReceiveTable()
sendTable = NewSendTable()

modules = {}

for _, channel in pairs(Channel) do
    modules[channel] = require("modules").NewModule(channel, ModuleCallback)
end

Update()

isaacSocketMod:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)
isaacSocketMod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, OnUnload)
----------------------------------------------------------------
-- 接口定义
IsaacSocket.WebSocketClient = {}
IsaacSocket.Clipboard = {}

-- 获取连接状态,如果返回false，说明IsaacSocket尚未连接，暂时不可用
function IsaacSocket.IsConnected()
    return connectionState == ConnectionState.CONNECTED
end

IsaacSocket.WebSocketClient.State = modules[Channel.WEB_SOCKET_CLIENT].WebSocketState
IsaacSocket.WebSocketClient.CloseStatus = modules[Channel.WEB_SOCKET_CLIENT].WebSocketCloseStatus

-- 创建一个WebsocketClient对象，第一个参数是地址，例如"ws://localhost:80" ,后面四个参数是回调，请提供函数
function IsaacSocket.WebSocketClient.New(address, callbackOnOpen, callbackOnMessage, callbackOnClosed,
    callbackOnError)
    return modules[Channel.WEB_SOCKET_CLIENT].New(address, callbackOnOpen, callbackOnMessage, callbackOnClosed,
        callbackOnError)

end
-- 获取剪贴板文本
function IsaacSocket.Clipboard.GetClipboard()
    return modules[Channel.CLIPBOARD].GetClipboard()
end

-- 设置剪贴板文本
function IsaacSocket.Clipboard.SetClipboard(text)
    return modules[Channel.CLIPBOARD].SetClipboard(text)
end
