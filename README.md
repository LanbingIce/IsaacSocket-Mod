# IsaacSocket-Mod

这是一个 **《以撒的结合》** 的Mod，可以为其他Mod提供连接 **WebSocket**，读写剪贴板，发送 **HTTP 请求** 的功能接口

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
    - [IsaacSocket.IsaacAPI](#isaacsocketisaacapi)
  - [衍生对象介绍](#衍生对象介绍)
    - [WebSocketClient](#websocketclient)
    - [Task](#task)
    - [Response](#response)
  - [自定义回调](#自定义回调)
    - ["ISAAC\_SOCKET\_CONNECTED"](#isaac_socket_connected)
    - ["ISAAC\_SOCKET\_DISCONNECTED"](#isaac_socket_disconnected)
    - ["ISAAC\_SOCKET\_CLIPBOARD\_UPDATED"](#isaac_socket_clipboard_updated)
  - [常见问题](#常见问题)
  - [注意事项](#注意事项)

## 如何安装和使用

  1. 从 [创意工坊](https://steamcommunity.com/sharedfiles/filedetails/?id=3033763718) 订阅 Mod：**IsaacSocket**  

  2. 下载 [IsaacSocket 连接工具](https://github.com/LanbingIce/IsaacSocket-Utility/releases/latest) 并将其启动  

  3. 进入游戏，当看到游戏画面的左上角出现绿色的 **IsaacSocket 连接成功!** 的字样，说明 **IsaacSocket-Mod** 已经正常工作

  4. 如果

     - 您是普通用户：您现在已经做完了所有步骤，现在可以关闭这个页面，启动需要 **IsaacSocket-Mod** 作为前置的其他Mod，尽情游玩
     - 您是Mod开发者：您现在已经可以调用 **IsaacSocket-Mod** 的接口，开发您自己的Mod

  5. 如果遇到问题，请看[常见问题](#常见问题)，如果仍然没有解决，请联系作者[B站账号](https://space.bilibili.com/15109387)

## 快速开始

1. 确定 **IsaacSocket-Mod** 已经正常工作

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
   local mod = RegisterMod("MyFirstMod", 1)
   local timestamp = 0
   
   local function OnConnected()
       local url = "https://api.bilibili.com/x/report/click/now"
       IsaacSocket.HttpClient.GetAsync(url).Then(function(task)
           if task.IsCompletedSuccessfully() then
               local response = task.GetResult()
               local json = require("json").decode(response.body)
               timestamp = json.data.now
           else
               timestamp = task.GetResult()
           end
       end)
   end
   
   local function OnDisconnected()
       timestamp = 0
   end
   
   local function OnRender()
       if timestamp == 0 then
           Isaac.RenderText("IsaacSocket not installed or not connected successfully.", 80, 100, 1, 1, 1, 255)
       else
           Isaac.RenderText("Timestamp: " .. timestamp, 80, 100, 1, 1, 1, 255)
       end
   end
   
   mod:AddCallback("ISAAC_SOCKET_CONNECTED", OnConnected)
   mod:AddCallback("ISAAC_SOCKET_DISCONNECTED", OnDisconnected)
   mod:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)
   ````

5. 你现在已经做出了一个mod，效果是：当 **IsaacSocket-Mod** 连接成功时，调用了 **IsaacSocket-Mod** 的 **HttpClient模块** 的接口，访问B站的api并获得当前时间戳，然后显示在游戏画面上

## 接口介绍

### IsaacSocket

`IsaacSocket`是一个全局变量，每当你需要使用 **IsaacSocket-Mod** 提供的接口时，你都需要使用它

如果用户没有安装 **IsaacSocket-Mod** 或者没有在游戏中开启，`IsaacSocket`的值将会是`nil`，因此，请在确保`IsaacSocket`的值不是`nil`的情况下再使用它

如果用户已经安装并开启了 **IsaacSocket-Mod** ，但是没有处于已连接状态，那么所有接口都不会生效，因此，请在确保已连接的情况下使用`IsaacSocket`

使用 [自定义回调](#自定义回调) 可以方便的判断 **IsaacSocket-Mod** 是否已经安装、开启、并且已连接

`IsaacSocket`有如下方法：

- `IsConnected()`

  - 提示：不推荐使用此方法来判断 **IsaacSocket-Mod** 是否已连接，因为你在任何调用接口的地方都需要先判断`IsaacSocket`是否为`nil`，然后再判断是否已连接，非常繁琐，更好的方法是使用 [自定义回调](#自定义回调)

  - 功能：判断 **IsaacSocket-Mod** 是否已连接

  - 返回值：**boolean** ，已连接返回`true`，未连接返回`false`

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

`IsaacSocket.WebSocketClient`是 **WebSocketClient模块** 的接口变量

它有如下方法：

- `New(address, callbackOnOpen, callbackOnMessage, callbackOnClosed, callbackOnError)`

  - 功能：建立一个 **WebSocket** 连接，并连接到指定服务器

  - 返回值：[WebSocketClient](#websocketclient) 对象

  - 参数：

    - `address`：要连接到的服务器地址，请提供一个字符串，支持 **ws** 协议和 **wss** 协议

    - `callbackOnOpen`：**WebSocket**成功连接的回调，请传入一个函数，可以留空，函数示例：

    ````lua
    local function CallbackOnOpen()
        print("Open")
    end
    ````

    - `callbackOnMessage`：**WebSocket** 收到消息的回调，请传入一个函数，可以留空

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

    - `callbackOnClosed`：**WebSocket** 连接关闭的回调，请传入一个函数，可以留空

    回调函数的第一个参数是 **WebSocket 关闭状态码** ，详见[WebSocket 关闭状态码](https://developer.mozilla.org/zh-CN/docs/Web/API/CloseEvent#%E5%B1%9E%E6%80%A7)，第二个参数是 **关闭描述字符串** ，函数示例：

    ````lua
    local function CallbackOnClose(closeStatus, statusDescription)
        print("Close: ", closeStatus, statusDescription)
    end
    ````

    - `callbackOnError`：**WebSocket** 连接出现错误的回调，请传入一个函数，可以留空

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
    
    ws = IsaacSocket.WebSocketClient.New("ws://localhost:80", CallbackOnOpen, CallbackOnMessage, CallbackOnClose, CallbackOnError)
    ````

### IsaacSocket.ClipBoard

`IsaacSocket.ClipBoard`是 **ClipBoard模块** 的接口变量

它有如下方法：

- `GetClipboard()`

  - 提示：由于 **IsaacSocket 连接工具** 和 **IsaacSocket-Mod** 建立连接之后握手需要时间，因此在 **IsaacSocket-Mod** 刚进入“已连接”状态时，有一小段时间，调用此方法会返回空文本，另外如果你需要持续关心剪贴板内容的变化，你可能需要每帧都调用此方法。因此，推荐使用更高效更可靠的方式：通过自定义回调 ["ISAAC\_SOCKET\_CLIPBOARD\_UPDATED"](#isaac_socket_clipboard_updated) 来被动获得剪贴板文本

  - 功能：获取剪贴板文本

  - 返回值：当前剪贴板文本

  - 使用示例：
  
      ```lua
      local text = IsaacSocket.Clipboard.GetClipboard()
      print(text)
      ```
  
- `SetClipboard(text)`

  - 功能：设置剪贴板文本

  - 参数：

    - `text`：要设置的文本，传入空字符串将清空剪贴板，可以留空，留空默认为空字符串

  - 使用示例：
  
      ````lua
      local text = "example text"
      IsaacSocket.Clipboard.SetClipboard(text)
      ````

### IsaacSocket.HttpClient

`IsaacSocket.HttpClient`是 **HttpClient模块** 的接口变量

它有如下方法：

- `GetAysnc(url, headers)`  

  - 功能：发送 **HTTP GET请求**，这是一个异步函数
  - 返回值：执行结果为[Response](#response)的[Task](#task)对象
  - 参数：
    - `url`：要请求的**url**，支持 **http** 和 **https** 协议
    - `headers`：**HTTP 请求标头**，请传入一个lua表，键为标头名称，值为标头值，可以留空，留空默认为空表，详见[HTTP 请求标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Request_header)
  
  - 使用示例（调用B站api，获取当前的时间戳，调用这个api，User-Agent并不是必须的，此处只是为了演示`headers`的用法）：
  
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
  
- `PostAsync(url, headers, body)`  

  - 功能：发送 **HTTP POST请求**，这是一个异步函数
  - 返回值：执行结果为[Response](#response)的[Task](#task)对象
  - 参数：
    - `url`：要请求的**url**，支持 **http** 和 **https** 协议
    - `headers`：**HTTP 请求标头** 和 **HTTP 表示标头**，请传入一个lua表，键为标头名称，值为标头值，可以留空，留空默认为空表，详见[HTTP 请求标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Request_header)和[HTTP 表示标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Representation_header)，对于 **HTTP POST请求** 来说，一般必须有 **Content-Type** 表示标头，它表示请求主体的数据类型
    - `body`：**HTTP 请求主体** ，请传入一个字符串，把要发送的数据放在里面

  - 使用示例（调用B站api，在作者的直播间发送弹幕"hello"，请将`cookie`和`csrf`换成你自己的）
  
  ```lua
      local cookie = "your_cookie"
      local csrf = "your_csrf"
      local msg = "hello"
      local url = "https://api.live.bilibili.com/msg/send"
      local headers = {
          ["Cookie"] = cookie,
          ["Content-Type"] = "application/x-www-form-urlencoded"
      }
      local body = "bubble=0&msg=" .. msg .. "&color=16777215&mode=1&fontsize=25&rnd=1637323682&roomid=3092145&csrf=" .. csrf
      IsaacSocket.HttpClient.PostAsync(url, headers, body).Then(function(task)
          local result = task.GetResult()
          if task.IsCompletedSuccessfully() then
              local json = require("json").decode(result.body)
              if json.code == 0 then
                  print("Sending a danmaku successfully.")
              else
                  print("Sending a danmaku failed due to:" .. json.message)
              end
          else
              print("faulted:" .. tostring(result))
          end
      end)
  ```
  
### IsaacSocket.IsaacAPI

`IsaacSocket.IsaacAPI`是 **IsaacAPI模块** 的接口变量

它有如下方法：

- `ReloadLua()`  

  - 注意：由于在游戏内调用会出现一些已知问题，因此如果需要调用此方法，请在小退的回调中调用，这样会在菜单界面重置，与游戏本体的重置方式一致，不会出现问题
  - 功能：重置游戏的**Lua环境**，所有mod都会被重新加载，与在mod菜单界面开关mod之后触发的重新加载的效果完全一致
  - 已知问题：
    - 在游戏内调用大概率会导致：
      - 在当前房间击杀怪物时，有时会导致游戏崩溃/卡住/出现意外的特效
      - 苍蝇的音效永远不会结束，即使回到主菜单
      - 角色的影子尺寸不正常，消失或者变得很大，小退恢复正常
      - 角色的质量不正常，表现为角色不能推动任何实体，小退恢复正常
      - 如果你开启了某些mod（比如EID或者东方之类的大型mod），调用此方法会导致游戏崩溃

  - 使用示例（在小退回调时调用）：

  ```lua
  local function OnGameExit(_, shouldSave)
      if shouldSave then
          IsaacSocket.IsaacAPI.ReloadLua()
      end
  end
  
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, OnGameExit)
  ```

- `GetDebugFlag()`

  - 功能：获取当前的 **debug标志**
  - 返回值：按位存储了 **debug标志** 的整数，最低位为**debug 1**，请用位与 `&` 运算符取出所需的标志位
  - 使用示例：

  ``````lua
  local debugFlag = IsaacSocket.IsaacAPI.GetDebugFlag()
  for i = 1, 14 do
      if debugFlag & 2 ^ (i - 1) ~= 0 then
          print("Debug " .. i .. " is Enabled")
      end
  end

- `SetDebugFlag(debugFlag)` **未提供**

  - 提示：此方法可以通过`GetDebugFlag()`和官方api简单的实现，因此不提供，实现方法：

  ``````lua
  local function SetDebugFlag(debugFlag)
      local currentDebugFlag = IsaacSocket.IsaacAPI.GetDebugFlag()
      for i = 1, 14 do
          local mask = 2 ^ (i - 1)
          if currentDebugFlag & mask ~= debugFlag & mask then
              Isaac.ExecuteCommand("debug " .. i);
          end
      end
  end
  ``````

- `GetCanShoot(playerId)` **未提供**

  - 提示：此方法官方api已经存在，因此不提供： 官方api中的此方法：`Isaac.GetPlayer(playerId).CanShoot()`

- `SetCanShoot(playerId, canShoot)`

  - 功能：设置角色是否能射击
  - 参数：
    - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
    - `canShoot`：能否射击，请传入一个**boolean**，`true`为能射击，`false`为不能射击，如果不合法或为空，默认为`true`

- `GetActiveVarData(playerId, activeSlot)`

  - 功能：得到主动的附加数据（例如后悔药的次数，里蓝人副主动里装了什么屎）
  - 参数：
    - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
    - `activeSlot`：主动槽，详见 [ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html)

  - 返回值：整数，主动的附加数据

- `SetActiveVarData(playerId, activeSlot, activeVarData)`

- 功能：设置主动的附加数据（例如后悔药的次数，里蓝人副主动里装了什么屎）
- 参数：
  - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
  - `activeSlot`：主动槽，详见 [ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html)
  - `activeVarData`：整数，主动的附加数据，如果不合法或为空，默认为0
- `GetActivePartialCharge(playerId, activeSlot)`
  - 功能：得到4.5伏特当前的充能进度
  - 参数：
    - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
    - `activeSlot`：主动槽，详见 [ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html)
  - 返回值：小数，范围从0到1
- `SetActivePartialCharge(playerId, activeSlot, partialCharge)`

- 功能：设置4.5伏特当前的充能进度
- 参数：
  - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
  - `activeSlot`：主动槽，详见 [ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html)
  - `partialCharge`：小数，范围从0到1，如果不合法或为空，默认为0

- `GetActiveSubCharge(playerId, activeSlot)`
  - 功能：得到9伏特当前的充能进度（仅在主动是1充能主动时有效）
  - 参数：
    - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
    - `activeSlot`：主动槽，详见 [ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html)
  - 返回值：整数，范围从0到449
- `SetActiveSubCharge(playerId, activeSlot, subCharge)`

- 功能：设置9伏特当前的充能进度（仅在主动是1充能主动时有效）
- 参数：
  - `playerId`：玩家id，请传入一个整数，范围在0到当前角色数-1之间，如果不合法或为空，默认为0
  - `activeSlot`：主动槽，详见 [ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html)
  - `subCharge`：整数，范围从0到449，如果不合法或为空，默认为0

## 衍生对象介绍

有些接口的使用过程中，会产生一些衍生对象

单独使用衍生对象时，不需要特意判断 `IsaacSocket` 是否存在和已连接

### WebSocketClient

- 获取方式：调用`IsaacSocket.WebSocketClient.New()`方法

- 功能：是你建立 **WebSocket** 连接的凭证，用来操作 **WebSocket** 连接和查询 **WebSocket** 连接的状态

- 成员方法：

  - `IsOpen()`  
    - 功能：判断 **WebSocket**是否已经连接
    - 返回值：**boolean**，`true`表示成功连接，`false`表示未成功连接
  - `IsClosed()`  
    - 功能：判断 **WebSocket** 连接是否已经关闭
    - 返回值：**boolean**，`true`表示已经关闭连接，`false`表示未关闭连接
  - `Send(message, isBinary)`  
    - 功能：发送一条 **WebSocket** 消息
    - 参数：`message`是要发送的消息，`isBinary`表示是否为二进制数据，如果为false则为文本消息，如果留空默认为文本消息
  - `Close(closeStatus, statusDescription)`  
    - 功能：关闭连接，**WebSocket** 连接将进入“正在关闭”状态，此时`IsOpen()`和`IsClosed()`都会返回`false`，直到成功关闭
    - 参数：
      - `closeStatus`： **WebSocket 关闭状态码** ，详见[WebSocket 关闭状态码](https://developer.mozilla.org/zh-CN/docs/Web/API/CloseEvent#%E5%B1%9E%E6%80%A7)，可以留空，默认为`1000`，
      - `statusDescription`： **关闭描述字符串**，可以留空，默认为空字符串

- 使用示例（检查 **WebSocket** 是否已经连接，如果已经连接，则发送一条文本消息"hello"）：

  ```lua
  if ws.IsOpen() then
      ws.Send("hello", false)
  end
  ```

### Task

- 获取方式：调用任意异步方法，异步方法的特征是后缀是 **Async**，例如`IsaacSocket.HttpClient.GetAsync()`

- 功能：是你创建异步任务的凭证，可以用来检查异步任务的状态和获取执行结果

- 成员方法：

  - `GetResult()`

    - 功能：如果任务成功完成，可以获取异步任务的执行结果，如果任务失败，则可以获取失败原因字符串
    - 返回值：如果任务成功完成，返回执行结果对象，如果任务失败，返回失败原因字符串，如果任务仍在执行，返回`nil`

  - `IsCompletedSuccessfully()`

    - 功能：判断任务是否已经成功完成
    - 返回值：**boolean**，`true`表示已经成功完成，`false`表示仍在执行或者已经失败

  - `IsFaulted()`

    - 功能：判断任务是否已经失败
    - 返回值：**boolean**，`true`表示已经失败，`false`表示仍在执行或者已经成功完成

  - `IsCompleted()`

    - 功能：判断任务是否已经结束
    - 返回值：**boolean**，`true`表示已经结束（包括成功完成和已经失败），`false`表示仍在执行

  - `Then(continuation)`

    - 功能：为任务增加一个后续步骤函数，可以理解为是任务结束时的回调函数，如果任务已经结束，则直接将其触发

    - 参数：

      - `continuation`：要增加的后续步骤函数，请传入一个函数

      函数的第一个参数是[Task](#task)对象自身，函数示例：

      ```lua
      local function Continuation(task)
          if (task.IsCompletedSuccessfully()) then
              print("The task has been successfully completed.")
          end
      end
      ```

### Response

- 获取方式：调用`IsaacSocket.HttpClient.GetAsync()`或者`IsaacSocket.HttpClient.PostAsync()`得到[Task对象](#task)，在任务成功完成之后，对[Task对象](#task)使用`GetResult()`
- 功能：是你 **HTTP请求** 的响应对象
- 成员：

  - `statusCode` **HTTP 响应状态码**，详见[HTTP 响应状态码](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status)
  - `reasonPhrase` **HTTP 响应状态文本**
  - `headers` **HTTP 响应标头**，是一个具有多个键值对的lua表，键为标头名称，值为标头值，详见[HTTP 响应标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Response_header)
  - `body` **HTTP 响应主体**

## 自定义回调

当你需要在游戏中的某个时机挂载回调函数时，你会用到`mod:AddCallback()`，参数中回调时机都是官方API给定的，但是实际上Mod也可以通过API注册自定义的回调时机

为了方便使用，**IsaacSocket-Mod** 在游戏中注册了一些自定义回调

这样做的优点是：即使 **IsaacSocket-Mod** 没有安装，回调也可以正常的工作，而不会造成任何的报错，因此，在大多数情况下，你不再需要进行繁琐的判断来确保 **IsaacSocket-Mod** 已安装，开启，并连接成功。

需要注意的一点是：以撒所有的回调，在第一个参数中都传入了你的 **Mod对象**，这个参数很少会用的到，有的Mod作者还会通过冒号语法糖的方式，回避掉这个参数，因此，在习惯上，我们在讨论回调函数的参数时，一般会忽略掉这个参数，然后把第二个参数叫做第一个参数，下文都是如此

### "ISAAC_SOCKET_CONNECTED"

- 时机：**IsaacSocket-Mod** 连接成功时

- 使用示例：见 ["ISAAC\_SOCKET\_DISCONNECTED"](#isaac_socket_disconnected)

### "ISAAC_SOCKET_DISCONNECTED"

- 时机：**IsaacSocket-Mod** 断开连接时

- 使用示例：  

   ```lua
   local isConnected = false
   
   local function OnConnected()
       isConnected = true
       -- Do something
   end
   
   local function OnDisconnected()
       isConnected = false
       -- Do something
   end
   
   mod:AddCallback("ISAAC_SOCKET_CONNECTED", OnConnected)
   mod:AddCallback("ISAAC_SOCKET_DISCONNECTED", OnDisconnected)
   ```
  
  大多数情况下，你可以在 `"ISAAC_SOCKET_CONNECTED"` 回调中安全的调用接口，而不需要额外判断是否已连接
  
  如果你确实需要判断是否已连接，你可以通过上文代码的这种方式，用 `isConnected` 来方便的判断

### "ISAAC_SOCKET_CLIPBOARD_UPDATED"

- 时机：**ClipBoard模块** 剪贴板内容更新时 / **IsaacSocket-Mod** 断开连接时

- 回调函数参数：

  - `text`：**ClipBoard模块** 剪贴板内容更新时：新的剪贴板文本 / **IsaacSocket-Mod** 断开连接时： `nil`

- 使用示例：

  ``````lua
  local function OnClipboardUpdated(_, text)
      if text ~= nil then
          print("Clipboard: " .. text)
      end
  end
  
  mod:AddCallback("ISAAC_SOCKET_CLIPBOARD_UPDATED", OnClipboardUpdated)
  ``````

## 常见问题

**Q:** 已经按照安装使用步骤做了每一步，为什么 **IsaacSocket 连接工具** 没有任何反应？

**A:** 有可能是因为你的以撒是以管理员模式启动的，请尝试用管理员模式启动 **IsaacSocket 连接工具**

**Q:** 已经按照安装使用步骤做了每一步，为什么 **IsaacSocket 连接工具** 中一直反复出现连接断开的字样？

**A:** 有可能是因为 **IsaacSocket 连接工具** 的内存操作被你的杀毒软件拦截了，请尝试关闭杀毒软件

如果您的问题仍然没有解决，请联系作者[B站账号](https://space.bilibili.com/15109387)

## 注意事项

- 除了使用自定义回调和直接使用衍生对象之外，任何时候使用接口都必须确定 `IsaacSocket` 不是`nil`且已连接，详见 [IsaacSocket](#isaacsocket)
  
- **IsaacSocket-Mod** 的所有代码都运行在游戏的 **Render** 回调中，因此在各种回调函数中只能执行诸如打印文字，渲染图片之类的操作，而不能执行对游戏逻辑有实质影响的操作，例如生成道具，改变实体状态等，如果需要进行这些操作，可以先保存在表里，然后在 **Update** 回调中再执行，如果不这样做，可能会引发不可预测的游戏渲染问题或者让游戏崩溃
