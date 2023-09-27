# IsaacSocket-Mod

这是一个《以撒的结合》的Mod，可以为其他Mod提供连接WebSocket，剪贴板读写，发送HTTP请求等接口

## 目录

- [IsaacSocket-Mod](#isaacsocket-mod)
  - [目录](#目录)
  - [如何安装和使用](#如何安装和使用)
  - [快速开始](#快速开始)
  - [接口介绍](#接口介绍)
    - [IsaacSocket](#isaacsocket)
    - [IsaacSocket.WebSocketClient](#isaacsocketwebsocketclient)
    - [IsaacSocket.ClipBoard](#isaacsocketclipboard)
    - [IsaacSocket.HttpClient](#isaacsockethttpclient)
  - [衍生对象介绍](#衍生对象介绍)
    - [WebSocketClient](#websocketclient)
    - [Task](#task)
    - [Response](#response)
  - [常见问题](#常见问题)
  - [注意事项](#注意事项)

## 如何安装和使用

  1. 从 [创意工坊](https://steamcommunity.com/sharedfiles/filedetails/?id=3033763718) 订阅 Mod：IsaacSocket  

  2. 下载 [IsaacSocket 连接工具](https://github.com/LanbingIce/IsaacSocket-Utility/releases/latest) 并将其启动  

  3. 进入游戏，当看到 IsaacSocket 连接工具 的窗口中出现类似如下的提示时，说明Mod已经正常工作

     - 09:49:02 以撒进程已找到！
     - 09:49:14 正在等待Mod回应...
     - 09:49:16 已连接！交换区大小：1024字节

  4. 启动需要 IsaacSocket 作为前置的其他Mod，或者调用 IsaacSocket 的接口，开发您自己的Mod

  5. 如果遇到问题，请看[常见问题](#常见问题)，如果仍然没有解决，请联系作者[B站账号](https://space.bilibili.com/15109387)

## 快速开始

1. 确定 IsaacSocket 已经正常工作

2. 找到以撒根目录下的`mods`文件夹，进入，在里面建立一个文件夹，命名为`my_first_mod`

3. 进入`my_first_mod`文件夹，建立文件 `metadata.xml` ，用文本编辑器打开，修改其内容如下：

   ````xml
   <metadata>
    <name>my first mod</name>
    <directory>my_first_mod</directory>
    <description/>
    <version>1.0</version>
    <visibility/>
   </metadata>
   ````

4. 建立文件`main.lua`，用文本编辑器打开，修改其内容如下并保存：

   ````lua
   local myMod = RegisterMod("MyMod", 1)
   local font = Font()
   font:Load("font/terminus.fnt")
   
   local function OnRender()
       if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
           local text = IsaacSocket.Clipboard.GetClipboard()
           font:DrawStringScaled(text, 100, 50, 0.5, 0.5, KColor(1, 1, 1, 1), 0, true)
       else
           font:DrawStringScaled("IsaacSocket not installed or not connected successfully.", 100, 50, 0.5, 0.5,
               KColor(1, 1, 1, 1), 0, true)
       end
   end
   
   myMod:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)
   ````

5. 你现在已经做出了一个mod并成功调用 IsaacSocket 的 ClipBoard 模块获取到了剪贴板中的文本，可以进入游戏查看效果，当你复制文本时，文本会显示在游戏画面上

## 接口介绍

### IsaacSocket

`IsaacSocket`是一个全局变量，每当你需要使用IsaacSocket提供的接口时，你都需要使用它

`IsaacSocket`有如下方法：

- `IsConnected()`

  - 功能：判断 IsaacSocket 是否已连接

  - 返回值：bool ，已连接返回`true`，未连接返回`false`

  - 使用示例：

    ````lua
    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        -- Do something
    else
        print("IsaacSocket not installed or not connected successfully.")
    end
    ````

`IsaacSocket`有如下成员：

- [WebSocketClient](#isaacsocketwebsocketclient)
- [ClipBoard](#isaacsocketclipboard)
- [HttpClient](#isaacsockethttpclient)

### IsaacSocket.WebSocketClient

`IsaacSocket.WebSocketClient`是WebSocketClient模块的接口变量

它有如下方法：

- `New(address, callbackOnOpen, callbackOnMessage, callbackOnClosed, callbackOnError)`

  - 功能：建立一个WebSocket连接，并连接到指定服务器

  - 返回值：[WebSocketClient](#websocketclient) 对象

  - 参数：

    1. `address`：要连接到的服务器地址，请提供一个字符串，支持ws协议和wss协议

    2. `callbackOnOpen`：WebSocket成功连接的回调，请传入一个函数，可以留空，函数示例：

       ````lua
       local function CallbackOnOpen()
           print("Open")
       end
       ````

    3. `callbackOnMessage`：WebSocket收到消息的回调，请传入一个函数，可以留空

       回调函数的第一个参数是收到的消息内容，第二个参数是“是否是二进制消息”，函数示例：

       ````lua
       local function CallbackOnMessage(message, isBinary)
           if isBinary then
               print("Binary Message,length: " .. #message)
           else
               print("Text Message: ", message)
           end
       end
       ````

    4. `callbackOnClosed`：WebSocket连接关闭的回调，请传入一个函数，可以留空

       回调函数的第一个参数是关闭状态码，详见[WebSocket 关闭状态码](https://developer.mozilla.org/zh-CN/docs/Web/API/CloseEvent#%E5%B1%9E%E6%80%A7)，第二个参数是关闭描述字符串，函数示例：

       ````lua
       local function CallbackOnClose(closeStatus, statusDescription)
           print("Close: ", closeStatus, statusDescription)
       end
       ````

    5. `callbackOnError`：WebSocket连接出现错误的回调，请传入一个函数，可以留空

       回调函数的第一个参数是错误原因字符串

       ````lua
       local function CallbackOnError(message)
           print("Error: ", message)
       end
       ````

  - 使用示例：

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
    
    if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
        ws = IsaacSocket.WebSocketClient.New("ws://localhost:80", CallbackOnOpen, CallbackOnMessage, CallbackOnClose, CallbackOnError)
    end
    ````

### IsaacSocket.ClipBoard

`IsaacSocket.ClipBoard`是ClipBoard模块的接口变量

它有如下方法：

- `GetClipboard()`

  - 功能：获取剪贴板文本

  - 返回值：当前剪贴板文本

  - 使用示例：

      ```lua
      if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
          local text = IsaacSocket.Clipboard.GetClipboard()
          print(text)
      end
      ```

- `SetClipboard(text)`

  - 功能：设置剪贴板文本

  - 参数：`text`是要设置的文本

  - 使用示例：

      ````lua
      local text = "example text"
      if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
          IsaacSocket.Clipboard.SetClipboard(text)
      end
      ````

### IsaacSocket.HttpClient

`IsaacSocket.HttpClient`是HttpClient模块的接口变量

它有如下方法：

- `GetAysnc(url, headers)`  

  - 功能：发送GET请求
  - 返回值：执行结果为[Response](#response)的[Task](#task)对象
  - 参数：`url`是要请求的url，`headers`是请求标头，请传入一个table，键为标头名称，值为标头值，可以留空，留空默认为空表
  - 使用示例（调用B站api，获取当前的时间戳，调用这个api，User-Agent并不是必须的，此处只是为了演示headers的用法）：

  ```lua
  local url = "https://api.bilibili.com/x/report/click/now"
  local headers = {
      ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
  }
  IsaacSocket.HttpClient.GetAsync(url, headers).Then(function(task)
      if task.IsCompletedSuccessfully() then
          local response = task.GetResult()
          local json = require("json").decode(response.body)
          print("current timestamp: " .. json.data.now)
      else
          print(task.GetResult())
      end
  end)
  ```

## 衍生对象介绍

有些接口的使用过程中，会产生一些衍生对象

单独使用衍生对象时，不需要特意判断IsaacSocket是否存在和已连接

### WebSocketClient

- 获取方式：调用`IsaacSocket.WebSocketClient.New()`方法

- 功能：是你建立WebSocket连接的凭证，用来操作WebSocket连接和查询WebSocket连接的状态

- 成员方法：

  - GetState()  （已过时，不要使用，将在下个版本删除）
    - 功能：得到WebSocket连接的状态
    - 返回值：`IsaacSocket.WebSocketClient.State`枚举
  - IsConnected()  
    - 功能：判断WebSocket是否已经连接
    - 返回值：bool，`true`表示成功连接，`false`表示未成功连接
  - IsClosed()  
    - 功能：判断WebSocket连接是否已经关闭
    - 返回值：bool，`true`表示已经关闭连接，`false`表示未关闭连接
  - Send(message, isBinary)  
    - 功能：发送一条WebSocket消息
    - 参数：`message`是要发送的消息，`isBinary`表示是否为二进制数据，如果为false则为文本消息，如果留空默认为文本消息
  - Close(closeStatus, statusDescription)  
    - 功能：关闭连接，WebSocket对象将进入“正在关闭”状态，此时`IsConnected()`和`IsClosed()`都会返回`false`，直到成功关闭
    - 参数：`closeStatus`是关闭状态码，详见[WebSocket 关闭状态码](https://developer.mozilla.org/zh-CN/docs/Web/API/CloseEvent#%E5%B1%9E%E6%80%A7)，可以留空，默认为1000，`statusDescription`是关闭描述字符串，可以留空，默认为空字符串

- 使用示例（检查WebSocket是否已经连接，如果已经连接，则发送一条文本消息"hello"）：

  ```lua
  if ws.IsConnected() then
      ws.Send("hello", false)
  end
  ```

### Task

- 获取方式：调用任意异步方法，异步方法的特征是后缀是Async，例如`IsaacSocket.HttpClient.GetAsync()`

- 功能：是你创建异步任务的凭证，可以用来检查异步任务的状态和获取执行结果

- 成员方法：

  - `GetResult()`

    - 功能：如果任务成功完成，可以获取异步任务的执行结果，如果任务失败，则可以获取失败原因字符串
    - 返回值：如果任务成功完成，返回执行结果对象，如果任务失败，返回失败原因字符串，如果任务仍在执行，返回nil

  - `IsCompletedSuccessfully()`

    - 功能：判断任务是否已经成功完成
    - 返回值：bool，`true`表示已经成功完成，`false`表示仍在执行或者已经失败

  - `IsFaulted()`

    - 功能：判断任务是否已经失败
    - 返回值：bool，`true`表示已经失败，`false`表示仍在执行或者已经成功完成

  - `IsCompleted()`

    - 功能：判断任务是否已经结束
    - 返回值：bool，`true`表示已经结束（包括成功完成和已经失败），`false`表示仍在执行

  - `Then(continuation)`

    - 功能：为任务增加一个后续步骤函数，可以理解为是任务结束时的回调函数，如果任务已经结束，则直接触发回调

    - 参数：`continuation`是要增加的后续步骤函数，请传入一个函数

      函数的第一个参数是此task对象，函数示例：

      ```lua
      local function Continuation(task)
          if (task.IsCompletedSuccessfully()) then
              print("The task has been successfully completed.")
          end
      end
      ```

### Response

- 获取方式：调用`IsaacSocket.HttpClient.GetAsync()`得到[Task对象](#task)，在任务成功完成之后，对[Task对象](#task)使用`GetResult()`
- 功能：是你HTTP请求的响应对象
- 成员：

  - `statusCode` HTTP 响应状态码，详见[HTTP 响应状态码](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status)
  - `reasonPhrase` HTTP 响应状态文本
  - `headers` HTTP 响应标头，是一个table，键为标头名称，值为标头值
  - `body` HTTP 响应正文

## 常见问题

**Q:** IsaacSocket Mod已经订阅并在游戏中打开，IsaacSocket 连接工具也已经下载并运行，为什么没有显示连接成功？

**A:** 有可能是因为你的以撒是以管理员模式启动的，请尝试用管理员模式启动 IsaacSocket 连接工具

如果您的问题仍然没有解决，请联系作者[B站账号](https://space.bilibili.com/15109387)

## 注意事项

- 除了直接使用衍生对象之外，任何时候使用接口，都必须检查 IsaacSocket 是否存在且已连接，如果未成功连接的话接口是无效的  
  具体代码像是这样：

  ```lua
  if IsaacSocket ~= nil and IsaacSocket.IsConnected() then
      -- Do something
  else
      -- The user doesn't have IsaacSocket installed or hasn't connected successfully
  end
  ```

- IsaacSocket 的所有代码都运行在游戏的Render回调中，因此各种回调中只能执行诸如打印文字，渲染图片之类的操作，而不能执行对游戏逻辑有实质影响的操作，例如生成道具，改变实体状态等，如果需要进行这些操作，可以先保存在表里，然后在Update回调中再执行，如果不这样做，可能会引发不可预测的游戏渲染问题或者让游戏崩溃
