# HttpClient

这是一个用于发送 **HTTP 请求** 的模块，支持 **GET** 和 **POST** 请求，支持 **http**，**https** 协议

- [HttpClient](#httpclient)
  - [模块函数](#模块函数)
    - [GetAsync()](#getasync)
    - [PostAsync()](#postasync)

## 模块函数

### GetAsync()

[Task](Classes.md#Task<Type>)\<[Response](Classes.md#Response)\> GetAsync(string url, table headers)

- 功能：发送 **HTTP GET请求**

- 参数：

  - `url`：网址
  - `headers`：**HTTP 请求标头**，请传入一个lua表，键为标头名称，值为标头值，可以留空，留空默认为空表，详见[HTTP 请求标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Request_header)

- 使用示例（调用B站api，获取当前的时间戳，调用这个api，User-Agent并不是必须的，此处只是为了演示`headers`的用法）：

    ````lua
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
    ````

### PostAsync()

[Task](Classes.md#Task<Type>)\<[Response](Classes.md#Response)\> PostAsync(string url, table headers,string body)

- 功能：发送 **HTTP POST请求**，支持 **http**，**https** 协议

- 参数：

  - `url`：网址
  - `headers`：**HTTP 请求标头** 和 **HTTP 表示标头**，键为标头名称，值为标头值，可以留空，留空默认为空表，详见[HTTP 请求标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Request_header)和[HTTP 表示标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Representation_header)，对于 **HTTP POST请求** 来说，一般必须有 **Content-Type** 表示标头，它表示请求主体的数据类型
  - `body`：**HTTP 请求主体**

- 使用示例（调用B站api，在作者的直播间发送弹幕"hello"，请将`cookie`和`csrf`换成你自己的）：

    ````lua
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
    ````
