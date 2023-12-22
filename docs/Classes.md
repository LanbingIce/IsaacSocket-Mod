# 衍生对象说明

[TOC]

## 衍生类

### WebSocketClient

这是WebSocket连接的连接对象

#### IsOpen()

boolean IsOpen()

- 功能：判断 **WebSocket**是否已经成功连接
- 返回值：`true`表示已成功连接，`false`表示正在连接/正在关闭/已经关闭

#### IsClosed()

boolean IsClosed()

- 功能：判断 **WebSocket** 连接是否已经关闭
- 返回值：`true`表示已关闭连接，`false`表示已经连接/正在连接/正在关闭

#### Send()

Send(string message="", boolean isBinary=false)

- 功能：发送一条 **WebSocket** 消息
- 参数：
  - `message`：要发送的消息
  - `isBinary`：是否是二进制数据

#### Close()

Close(integer closeStatus=1000, string statusDescription="")

- 功能：关闭连接，**WebSocket** 连接将进入“正在关闭”状态，直到成功关闭
- 参数：
  - `closeStatus`： **WebSocket 关闭状态码** ，详见[WebSocket 关闭状态码](https://developer.mozilla.org/zh-CN/docs/Web/API/CloseEvent#%E5%B1%9E%E6%80%A7)
  - `statusDescription`： **关闭描述字符串**，可以留空，默认为空字符串

### Task\<Type\>

当你调用异步函数时，会直接返回一个Task对象，此时你可以调用其[Then](#then)()方法添加一个后续操作（回调函数），当异步操作结束之后，后续操作会被依次调用，此时你可以调用其方法判断是否执行成功，以及获取返回值等

#### IsCompletedSuccessfully()

boolean IsCompletedSuccessfully()

- 功能：判断任务是否已经成功完成
- 返回值：`true`表示已经成功完成，`false`表示仍在执行或者已经失败

#### IsCompleted()

boolean IsCompleted()

- 功能：判断任务是否已经结束（无论成功还是失败）
- 返回值：`true`表示已经完成（包括成功完成和已经失败），`false`表示仍在执行

#### IsFaulted()

boolean IsFaulted()

- 功能：判断任务是否已经失败
- 返回值：`true`表示已经失败，`false`表示仍在执行或者已经成功完成

#### Then()

Then(function continuation)

- 功能：为异步任务增加一个后续操作，当任务结束之后，后续操作将被依次调用并传入**Task\<Type\>**对象，可以多次调用添加多个操作，如果在任务结束之后调用此方法，后续操作将直接被执行

  - 参数：

    - `continuation`：要添加的异步操作，函数原型：**[Continuation](#continuation)()**

#### GetResult()

Type/string/nil GetResult()

- 功能：获取异步操作的返回值
- 返回值：成功完成时，返回 **Type** 对应类型的返回值，失败时，返回错误信息文本，正在执行时，返回`nil`

### Response

这是 **HTTP请求** 的响应对象

当调用HttpClient模块的相关方法发送请求，可以通过[Task](#tasktype)\<Response\>对象获取Response返回值

#### statusCode

integer statusCode

- 说明：**HTTP 响应状态码**，详见[HTTP 响应状态码](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status)

#### reasonPhrase

string reasonPhrase

- 说明：**HTTP 响应状态文本**

#### headers

table headers

- 说明：**HTTP 响应标头**，是一个具有多个键值对的lua表，键为标头名称，值为标头值，详见[HTTP 响应标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Response_header)

#### body

string body

- 说明：**HTTP 响应主体**

## 回调函数

### Continuation()

Continuation([Task](#tasktype)\<Type\> task)

- 参数：
  - `task`：此异步操作对应的[Task](#tasktype)对象

- 示例：

````lua
local function Continuation(task)
    if (task.IsCompletedSuccessfully()) then
        print("The task has been successfully completed.")
    end
end
````
