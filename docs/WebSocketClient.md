# WebSocketClient

这是一个用于建立连接WebSocket连接的模块，支持 **ws** 协议和 **wss** 协议

[TOC]

## 模块函数

### New()

WebSocketClient New(string address,function callbackOnOpen,function callbackOnMessage,function callbackOnClosed,function callbackOnError)

- 功能：建立一个 **WebSocket** 连接，并连接到指定服务器

- 参数：

  - `address`：要连接到的服务器地址

  - `callbackOnOpen`：成功连接的回调，函数原型：**[CallbackOnOpen](#callbackonopen)()**

  - `callbackOnMessage`：收到消息的回调，函数原型：**[CallbackOnMessage](#callbackonmessage)()**

  - `callbackOnClosed`：连接关闭的回调，函数原型：**[CallbackOnClosed](#callbackonclosed)()**

  - `callbackOnError`：连接出现错误的回调，函数原型：**[CallbackOnError](#callbackonerror)()**

- 使用示例(连接到[WebSocket在线测试](http://www.websocket-test.com/)提供的测试服务器，感谢网站作者)：

    ````lua
    local ws
    
    local function CallbackOnOpen()
        print("Open")
    end
    
    local function CallbackOnMessage(message, isBinary)
        if isBinary then
            print("Binary Message,length: " .. #message)
        else
            print("Text Message: ", message)
        end
    end
    
    local function CallbackOnClose(closeStatus, statusDescription)
        print("Close: ", closeStatus, statusDescription)
    end
    
    local function CallbackOnError(message)
        print("Error: ", message)
    end
    
    ws = IsaacSocket.WebSocketClient.New("ws://124.222.224.186:8800", CallbackOnOpen, CallbackOnMessage, CallbackOnClose, CallbackOnError)
    ````

## 回调函数

### CallbackOnOpen()

CallbackOnOpen()

- 示例：

````lua
local function CallbackOnOpen()
    print("Open")
end
````

### CallbackOnMessage()

CallbackOnOpen(string message,boolean isBinary)

- 参数：
  - `message`：收到的消息内容
  - `isBinary`：是否为二进制消息

- 示例：

````lua
local function CallbackOnMessage(message, isBinary)
    if isBinary then
        print("Binary Message,length: " .. #message)
    else
        print("Text Message: ", message)
    end
end
````

### CallbackOnClosed()

CallbackOnClose(integer closeStatus,string statusDescription)

- 参数：

  - `closeStatus`： **WebSocket 关闭状态码** ，详见[WebSocket 关闭状态码](https://developer.mozilla.org/zh-CN/docs/Web/API/CloseEvent#%E5%B1%9E%E6%80%A7)
  - `statusDescription`：**关闭描述字符串**

- 示例：

```lua
local function CallbackOnClose(closeStatus, statusDescription)
    print("Close: ", closeStatus, statusDescription)
end
```

### CallbackOnError()

CallbackOnError(string message)

- 参数：
  - `message`：**错误原因**字符串
- 示例：

```lua
local function CallbackOnError(message)
    print("Error: ", message)
end
```
