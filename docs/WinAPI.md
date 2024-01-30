# WinAPI

这个模块提供了一些windows的api，仅原汁原味的提供，如果你不知道自己在做什么，请不要使用这个模块

- [WinAPI](#winapi)
  - [模块函数](#模块函数)
    - [AllocConsole()](#allocconsole)
    - [FreeConsole()](#freeconsole)
    - [GetAsyncKeyState()](#getasynckeystate)
    - [GetKeyState()](#getkeystate)
    - [MessageBox()](#messagebox)

## 模块函数

### AllocConsole()

AllocConsole ()

- 功能：为调用进程分配一个新的控制台。

- 文档：[AllocConsole 函数](https://learn.microsoft.com/zh-cn/windows/console/allocconsole)

---

### FreeConsole()

FreeConsole()

- 功能：从其控制台分离调用进程。

- 文档：[FreeConsole 函数](https://learn.microsoft.com/zh-cn/windows/console/freeconsole)

---

### GetAsyncKeyState()

integer GetAsyncKeyState(integer vKey)

- 功能：确定调用函数时键是向上还是向下，以及上次调用 GetAsyncKeyState 后是否按下了该键。
- 文档：[GetAsyncKeyState 函数](https://learn.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-getasynckeystate)

---

### GetKeyState()

integer GetKeyState(integer nVirtKey)

- 功能：检索指定虚拟键的状态。 状态指定键是向上、向下还是切换， (打开、关闭—每次按下键时交替) 。

- 文档：[GetKeyState 函数](https://learn.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-getkeystate)

---

### MessageBox()

integer MessageBox(integer hWnd, string lpText, string lpCaption, integer uType)

- 功能：显示一个模式对话框，其中包含一个系统图标、一组按钮和一条简短的应用程序特定消息，例如状态或错误信息。 消息框返回一个整数值，指示用户单击的按钮。
  
- 文档：[MessageBox 函数](https://learn.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-messagebox)
