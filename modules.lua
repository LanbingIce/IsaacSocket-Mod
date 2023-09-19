-- 引入一些通用枚举
local common = require("common")
local Channel = common.Channel
local CallbackType = common.ModuleCallbackType
-- 一个空函数，用于默认回调
local _f = function()
end


-- 生成WebSocketClient模块，被主模块调用
local function NewWebSocketClientModule(channel, callback)

    -- 用于调试的输出方法，debug模式开启时可用
    local function cw(text)
        callback(CallbackType.PRINT, channel, text)
    end
    -- WebSocket的操作对象的集合
    local webSockets
    -- 操作消息类型，用于内存消息
    local ActionType = {
        -- 连接
        CONNECT = 0,
        -- 关闭
        CLOSE = 1,
        -- 连接成功
        ON_OPEN = 2,
        -- 消息
        ON_MESSAGE = 3,
        -- 已关闭
        ON_CLOSED = 4,
        -- 出现错误
        ON_ERROR = 5
    }
    -- WebSocket状态枚举
    local WebSocketState = {
        CONNECTING = 0,
        OPEN = 1,
        CLOSING = 2,
        CLOSED = 3
    }

    -- 消息类型枚举
    local WebSocketMessageType = {
        TEXT = 0,
        BINARY = 1
    }

    -- 关闭状态码枚举
    local WebSocketCloseStatus = {
        NORMAL = 1000,
        AWAY = 1001,
        PROTOCOL_ERROR = 1002,
        UNSUPPORTED_DATA = 1003,
        UNDEFINED = 1004,
        NO_STATUS = 1005,
        ABNORMAL = 1006,
        INVALID_DATA = 1007,
        POLICY_VIOLATION = 1008,
        TOO_BIG = 1009,
        MANDATORY_EXTENSION = 1010,
        SERVER_ERROR = 1011,
        TLS_HANDSHAKE_FAILURE = 1015
    }

    -- 模块对象
    local object = {}

    -- 消息类别枚举
    object.WebSocketMessageType = WebSocketMessageType

    -- 关闭状态码枚举
    object.WebSocketCloseStatus = WebSocketCloseStatus

    -- 连接状态枚举
    object.WebSocketState = WebSocketState


    -- 主模块建立连接时调用此函数
    function object.Connected()
        -- 没什么要做的
    end
    -- 主模块断开连接时调用此函数
    function object.DisConnected()
        -- 调用所有不处于CLOSE状态的websocket的OnError回调,然后清空websocket
        for _, webSocket in pairs(webSockets) do
            if webSocket.SetState(WebSocketState.CLOSED) then
                webSocket.callbackOnError("IsaacSocket Disconnected")
            end
        end
        webSockets = {}
    end
    -- 主模块收到此模块的频道消息时将消息传进来
    function object.ReceiveMemoryMessage(message)
        local actionType, id, offset = string.unpack("<I1I1", message)
        if type(webSockets[id]) ~= "table" then
            return false
        end
        local body = string.sub(message, offset)
        if (actionType == ActionType.ON_MESSAGE) then
            if webSockets[id].GetState() == WebSocketState.OPEN then
                local messageType = string.unpack("<I1", body)
                webSockets[id].callbackOnMessage(string.sub(body, 2), messageType == WebSocketMessageType.BINARY)
            end
        elseif (actionType == ActionType.ON_CLOSED) then
            local closeStatus = string.unpack("<I2", body)
            local closeMessage = string.sub(body, 3)
            if webSockets[id].SetState(WebSocketState.CLOSED) then
                webSockets[id].callbackOnClosed(closeStatus, closeMessage)
            end
        elseif (actionType == ActionType.ON_OPEN) then
            if webSockets[id].SetState(WebSocketState.OPEN) then
                webSockets[id].callbackOnOpen()
            end
        elseif (actionType == ActionType.ON_ERROR) then
            if webSockets[id].SetState(WebSocketState.CLOSED) then
                webSockets[id].callbackOnError(body)
            end
        end
        return true
    end

    -- 创建一个WebsocketClient对象，被主模块调用
    function object.New(address, callbackOnOpen, callbackOnMessage, callbackOnClosed,
        callbackOnError)

        -- 连接id
        local id
        -- 连接状态
        local state
        -- websocket操作对象，用于模块内部操作websocket，权限比较高
        local webSocketOperation = {}
        -- websocket接口对象，其他mod调用接口得到的对象就是这个,权限比较低
        local webSocketInterface = {}

        -- websocket操作对象方法:发送消息给主模块
        function webSocketOperation.Send(actionType, data)
            if state == WebSocketState.CLOSED then
                return false
            end

            if type(data) ~= "string" then
                data = ""
            end

            return callback(CallbackType.MEMORY_MESSAGE_GENERATED, channel, string.pack("<I1I1", actionType, id) .. data)
        end

        -- websocket操作对象方法:设置websocket状态
        function webSocketOperation.SetState(newState)
            if newState > state then
                state = newState
                return true
            end
            return false
        end

        -- websocket操作对象方法:获取websocket状态
        function webSocketOperation.GetState()
            return state
        end


        -- websocket接口对象方法:发送消息
        function webSocketInterface.Send(message, isBinary)
            local message = tostring(message)
            local messageType = WebSocketMessageType.TEXT
            if isBinary then
                messageType = WebSocketMessageType.BINARY
            end
            return webSocketOperation.Send(ActionType.ON_MESSAGE, string.pack("<I1", messageType) .. message)
        end

        -- websocket接口对象方法:关闭websocket连接
        function webSocketInterface.Close(closeStatus, statusDescription)
            -- 判断关闭状态码是否合法
            if type(closeStatus) ~= "number" or math.type(closeStatus) ~= "integer" or closeStatus < 0 or closeStatus >
                65535 then
                closeStatus = WebSocketCloseStatus.NORMAL
            end

            -- 判断关闭字符串是否合法
            if type(statusDescription) ~= "string" then
                statusDescription = ""
            end

            if webSocketOperation.SetState(WebSocketState.CLOSING) then
                return webSocketOperation.Send(ActionType.CLOSE, string.pack("<I2", closeStatus) .. statusDescription)
            end
            return false
        end

        -- websocket接口对象方法:获取websocket状态
        function webSocketInterface.GetState()
            return state
        end

        -- 初始化
        id = 0

        -- 找一个可用的id
        for i = 1, 255, 1 do
            if type(webSockets[i]) ~= "table" or webSockets[i].GetState() == WebSocketState.CLOSED then
                id = i
                break
            end
        end

        if type(callbackOnOpen) ~= "function" then
            callbackOnOpen = _f
        end
        if type(callbackOnMessage) ~= "function" then
            callbackOnMessage = _f
        end
        if type(callbackOnClosed) ~= "function" then
            callbackOnClosed = _f
        end
        if type(callbackOnError) ~= "function" then
            callbackOnError = _f
        end

        -- 将回调赋给接口对象
        webSocketOperation.callbackOnOpen = callbackOnOpen
        webSocketOperation.callbackOnMessage = callbackOnMessage
        webSocketOperation.callbackOnClosed = callbackOnClosed
        webSocketOperation.callbackOnError = callbackOnError

        state = WebSocketState.CONNECTING

        if id == 0 then
            webSocketOperation.SetState(WebSocketState.CLOSED)
            webSocketOperation.callbackOnError("Too many connections")
        elseif webSocketOperation.Send(ActionType.CONNECT, tostring(address)) then
        webSockets[id] = webSocketOperation
        else
            webSocketOperation.SetState(WebSocketState.CLOSED)
            webSocketOperation.callbackOnError("IsaacSocket Disconnected")
        end

        return webSocketInterface
    end

    -- WebSocket模块初始化
    webSockets = {}

    return object
end

local function NewClipboardModule(channel, callback)

    local clipboard
    local Callback
    local MessageType = {
        CLIPBOARD_UPDATE = 0,
        SET_CLIPBOARD = 1
    }

    local object = {}

    function object.GetClipboard()
        return clipboard
    end
    function object.SetClipboard(text)
        if type(text) ~= "string" then
            text = ""
        end
        Callback(CallbackType.MEMORY_MESSAGE_GENERATED, channel, string.pack("<I1", MessageType.SET_CLIPBOARD) .. text)
    end
    function object.ReceiveMemoryMessage(message)
        local messageType, offset = string.unpack("<I1", message)

        if messageType == MessageType.CLIPBOARD_UPDATE then
            clipboard = string.sub(message, offset)
        end

    end
    function object.Connected()
        -- 没什么要做的
    end
    function object.DisConnected()
        clipboard = ""
    end
    clipboard = ""
    Callback = callback
    return object
end

local module = {}

function module.NewModule(channel, callback)
    if channel == Channel.WEB_SOCKET_CLIENT then
        return NewWebSocketClientModule(channel, callback)
    elseif channel == Channel.CLIPBOARD then
        return NewClipboardModule(channel, callback)
    else
        return nil
    end

end

return module
