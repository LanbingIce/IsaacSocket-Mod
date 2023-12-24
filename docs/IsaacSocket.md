# 开发文档

这里是IsaacSocket的开发文档

- [开发文档](#开发文档)
  - [如何安装和使用](#如何安装和使用)
  - [快速开始](#快速开始)
  - [接口文档](#接口文档)
    - [IsaacSocket](#isaacsocket)
      - [IsaacAPI](#isaacapi)
      - [System](#system)
      - [WinAPI](#winapi)
      - [Memory](#memory)
      - [WebSocketClient](#websocketclient)
      - [HttpClient](#httpclient)
    - [其他](#其他)
      - [衍生对象](#衍生对象)
      - [自定义回调](#自定义回调)
  - [注意事项](#注意事项)

## 如何安装和使用

请参考 [如何安装和使用](../ReadMe.md#如何安装和使用)

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
   local myMod = RegisterMod("MyMod", 1)
   
   local function OnRender()
       if IsaacSocket then
           Isaac.RenderText(IsaacSocket.System.GetClipboard(),100,50,1,1,1,1)
       else
           Isaac.RenderText("IsaacSocket not installed or not connected successfully.",100,50,1,1,1,1)
       end
   end
   
   myMod:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)
   ````

5. 你现在已经做出了一个mod并成功调用 **IsaacSocket** 的 **System** 模块获取到了剪贴板中的文本，可以进入游戏查看效果：当你复制文本时，文本会显示在游戏画面上

## 接口文档

### IsaacSocket

`IsaacSocket`是一个全局变量，每当你需要使用 **IsaacSocket-Mod** 提供的接口时，你都需要使用它

如果用户没有安装 **IsaacSocket-Mod** 或者没有在游戏中开启或者没有开启连接工具，`IsaacSocket`的值将会是`nil`，因此，请先检查`IsaacSocket`的值不是`nil`，再使用它，使用回调和衍生对象时不需要检查

使用指定模块的函数的方式是`IsaacSocket.模块名.函数名()`

示例（调用WinAPI模块的AllocConsole()函数打开系统控制台，然后调用System模块的ConsoleOutput()方法输出"hello world"）：

```lua
if IsaacSocket then
    IsaacSocket.WinAPI.AllocConsole()
    IsaacSocket.System.ConsoleOutput("hello world")
end
```

以下为各个模块的文档：

#### IsaacAPI

以撒接口模块，文档：[IsaacAPI](IsaacAPI.md)

#### System

系统功能模块，文档：[System](System.md)

#### WinAPI

WindowsAPI模块，文档：[WinAPI](WinAPI.md)

#### Memory

内存操作模块，文档：[Memory](Memory.md)

#### WebSocketClient

WebSocket模块，文档：[WebSocketClient](WebSocketClient.md)

#### HttpClient

Http模块，文档：[HttpClient](HttpClient.md)

### 其他

#### 衍生对象

一些接口会产生的衍生对象，文档：[衍生对象](Classes.md)

#### 自定义回调

为方便使用，定义的一些自定义回调，文档：[自定义回调](Callbacks.md)

## 注意事项

- 除了使用自定义回调和直接使用衍生对象之外，任何时候使用接口都必须确定 `IsaacSocket` 不是`nil`
  
- **IsaacSocket-Mod** 的所有代码都运行在游戏的 **Render** 回调中，因此在各种回调函数中只能执行诸如打印文字，渲染图片之类的操作，而不能执行对游戏逻辑有实质影响的操作，例如生成道具，改变实体状态等，如果需要进行这些操作，可以先保存在表里，然后在 **Update** 回调中再执行，如果不这样做，可能会引发不可预测的游戏渲染问题或者让游戏崩溃
