# IsaacSocket-Mod
这是一个《以撒的结合》的Mod，可以为《以撒的结合》提供连接WebSocket，剪贴板读写等接口
## 如何安装和使用
- 从 [创意工坊](https://steamcommunity.com/sharedfiles/filedetails/?id=3033763718) 订阅 Mod：IsaacSocket  
- 下载 [IsaacSocket 连接工具](https://github.com/LanbingIce/IsaacSocket-Utility/releases) 并将其启动  
- 进入游戏，当看到 IsaacSocket 连接工具 的窗口中出现“已连接！XXXX”的提示时，说明Mod已经正常工作
- 启动需要 IsaacSocket 作为前置的其他Mod，或者调用 IsaacSocket 的接口，开发您的Mod
## 如何在您的Mod中调用 IsaacSocket 的接口
要调用 IsaacSocket 的接口，需要使用 IsaacSocket 这个全局变量  
- 调用函数： IsaacSocket.模块名称.函数名称(参数1,参数2,...)  
- 得到枚举成员： IsaacSocket.模块名称.枚举名称.枚举成员名称  
- 检查是否已成功连接： IsaacSocket.IsConnected()  

切记：不要将 IsaacSocket 或者IsaacSocket的任何模块保存在变量里使用，不然在开关任意一个Mod之后会引发错误  
记得任何时候使用 IsaacSocket 的任何内容，都必须检查它是否存在且已连接  
具体代码像是这样：
```
if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
    -- Do something
else
    -- The user doesn't have IsaacSocket installed or hasn't connected successfully
end
```
## Clipboard 模块
Clipboard 模块有如下函数：
- GetClipboard()  
    功能：获取剪贴板文本  
    示例：
    ```
    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        local text = IsaacSocket.Clipboard.GetClipboard()
        print(text)
    end
    ```
- SetClipboard(text)  
    功能：设置剪贴板文本  
    示例：
    ```
    local text = "example text"
    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        IsaacSocket.Clipboard.SetClipboard(text)
    end
    ```
## WebSocketClient 模块
WebSocketClient 模块只有一个函数
- New(address, callbackOnOpen, callbackOnMessage, callbackOnClosed, callbackOnError)  
    这个函数将返回一个 WebSocket 对象  
    参数1是要连接到的服务器url，请提供一个字符串，例如："ws://localhost:80"  
    参数2、3、4、5是四个回调方法，请分别提供一个函数，当websocket发生已连接、收到消息、关闭、错误四个事件时，将调用相应函数  

    使用示例：  
    ```
    local ws

    local function CallbackOnOpen()
        print("Open")
    end

    local function CallbackOnMessage(message, isBinary)
        if isBinary then
            print("Binary Message,lenth: "..#message)
        else
            print("Text Message: ", message)
        end
    end

    local function CallbackOnClose(closeStatus, message)
        print("Close: ", closeStatus, message)
    end

    local function CallbackOnError(message)
        print("Error: ", message)
    end

    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        ws = IsaacSocket.WebSocketClient.New("ws://localhost:80",CallbackOnOpen,CallbackOnMessage,CallbackOnClose,CallbackOnError)
    end
    ```
    返回的 Websocket 对象有如下方法：
    -  GetState()  
        返回 WebSocket 对象当前的连接状态，详见下文IsaacSocket.WebSocketClient.State枚举
    -  Send(message, isBinary)  
        发送一条消息，参数2表示是否是二进制消息，如果为false则为文本消息，如果留空默认为文本消息          
    -  Close(closeStatus, closeMessage)  
       关闭连接，WebSocket对象将进入 CLOSING 状态，直到成功关闭，参数1是关闭状态码，详见下文IsaacSocket.WebSocketClient.CloseStatus枚举，留空默认为 NORMAL ；参数2是关闭描述，请传入字符串，可以为空字符串或留空  

    使用示例：  
    ```
    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        if ws.GetState() == IsaacSocket.WebSocketClient.State.OPEN then
            ws.Send("hello",false)
        end
    end
    ```
    ```
    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        ws.Close(IsaacSocket.WebSocketClient.CloseStatus.NORMAL, "Normal Closure")
    end
    ```

WebSocketClient 模块拥有如下枚举：
- State  
    表示WebSocket的当前状态，有如下值：
  - CONNECTING = 0
  - OPEN = 1
  - CLOSING = 2
  - CLOSED = 3

- CloseStatus  
    表示WebSocket的关闭状态码，有如下值：
  - NORMAL = 1000
  - AWAY = 1001
  - PROTOCOL_ERROR = 1002
  - UNSUPPORTED_DATA = 1003
  - UNDEFINED = 1004
  - NO_STATUS = 1005
  - ABNORMAL = 1006
  - INVALID_DATA = 1007
  - POLICY_VIOLATION = 1008
  - TOO_BIG = 1009
  - MANDATORY_EXTENSION = 1010
  - SERVER_ERROR = 1011
  - TLS_HANDSHAKE_FAILURE = 1015