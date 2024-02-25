# 自定义回调

这里是自定义回调的介绍

- [自定义回调](#自定义回调)
  - [关于自定义回调](#关于自定义回调)
  - [回调类型](#回调类型)
    - [ISMC\_POST\_OPEN](#ismc_post_open)
    - [ISMC\_PRE\_CLOSE](#ismc_pre_close)
    - [ISMC\_PRE\_KEY\_DOWN](#ismc_pre_key_down)
    - [ISMC\_PRE\_CHAR\_INPUT](#ismc_pre_char_input)
    - [ISMC\_PRE\_EXECUTE\_CMD](#ismc_pre_execute_cmd)
    - [ISMC\_PRE\_CONSOLE\_OUTPUT](#ismc_pre_console_output)

## 关于自定义回调

为了方便使用，**IsaacSocket-Mod** 在游戏中使用了一些自定义回调

这样做的优点是：即使 **IsaacSocket-Mod** 没有安装或连接成功，你也可以添加回调，并不会造成任何的错误，非常的方便

添加回调的方式与官方回调一致，不同的是自定义回调的回调类型参数为字符串，以[ISMC_PRE_CHAR_INPUT](#ismc_pre_char_input)回调为例：

```lua
local function OnCharInput(_, char)
    print(char)
end
mod:AddCallback("ISMC_PRE_CHAR_INPUT", OnCharInput)
```

需要注意的一点是：以撒所有的回调，在第一个参数中都传入了你的 **Mod对象**，下文中不对此参数做介绍，关于此对象的信息，请查看官方API文档[Class "Mod Reference"](https://moddingofisaac.com/docs/rep/ModReference.html)

## 回调类型

### ISMC_POST_OPEN

MyFuntion([ModReference](https://moddingofisaac.com/docs/rep/ModReference.html) mod)

- 时机：IsaacSocket连接成功之后，此时所有模块可用，因此在此回调中调用接口是安全的，即使不检查`IsaacSocket`是否为`nil`

---

### ISMC_PRE_CLOSE

MyFuntion([ModReference](https://moddingofisaac.com/docs/rep/ModReference.html) mod)

- 时机：由于用户关闭了连接程序或者开关了任何mod导致**IsaacSocket**断开连接，断开之前的最后一刻会触发此回调，此时除了**WebsocketClient**和**HttpClient**之外，其他模块都尚未失效，如果你之前调用接口改变了某些状态，可以在此回调中将其恢复

---

### ISMC_PRE_KEY_DOWN

MyFuntion([ModReference](https://moddingofisaac.com/docs/rep/ModReference.html) mod, integer keyCode)

- 时机：用户按下一个键时
- 参数：
  - `keyCode`：用户按下的键代码
- 返回值：
  - `nil`或无返回值：无影响
  - 其他任何值：将此次按键拦截

---

### ISMC_PRE_CHAR_INPUT

MyFuntion([ModReference](https://moddingofisaac.com/docs/rep/ModReference.html) mod, string char)

- 时机：用户输入一个字符时（支持中文）
- 参数：
  - `char`：用户输入的字符
- 返回值：
  - `nil`或无返回值：无影响
  - 其他任何值：拦截此次输入

---

### ISMC_PRE_EXECUTE_CMD

MyFuntion([ModReference](https://moddingofisaac.com/docs/rep/ModReference.html) mod, string cmd)

- 时机：执行控制台指令前
- 参数：
  - `cmd`：即将执行的控制台指令
- 返回值：
  - `nil`或无返回值：无影响
  - `string`：修改控制台指令
  - 其他任何值：拦截此次指令

---

### ISMC_PRE_CONSOLE_OUTPUT

MyFuntion([ModReference](https://moddingofisaac.com/docs/rep/ModReference.html) mod, string text, integer color)

- 时机：控制台即将输出时
- 参数：
  - `text`：即将输出的文本
  - `color`：文本的颜色
- 返回值：
  - `nil`或无返回值：无影响
  - `string`：修改输出的字符串
  - 其他任何值：拦截此次输出
