# System

这是一个用于提供某些系统功能的模块，

[TOC]

## 模块函数

### ConsoleOutput()

ConsoleOutput(string text="")

- 功能：在系统控制台中输出文本，支持中文，不会自动添加换行符，需要调用[WinAPI.AllocConsole](WinAPI.md#AllocConsole)打开控制台后才能使用
- 参数：

  - `text`：要输出的文本信息

### GetClipboard()

string/nil GetClipboard()

- 功能：获取系统剪贴板内的文本内容
- 返回值：剪贴板中是文本内容时，返回其，否则返回nil

### SetClipboard()

SetClipboard(string text="")

- 功能：将系统剪贴板设置为指定的文本内容
- 参数：

  - `text`：要设置的文本
