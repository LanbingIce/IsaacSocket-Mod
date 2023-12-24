# WinAPI

这个模块提供了一些windows的api，仅原汁原味的提供，如果你不知道自己在做什么，请不要使用这个模块

- [WinAPI](#winapi)
  - [模块函数](#模块函数)
    - [AllocConsole()](#allocconsole)
    - [FreeConsole()](#freeconsole)

## 模块函数

### AllocConsole()

AllocConsole ()

- 功能：如果游戏没有已关联的系统控制台，则新建一个系统控制台并与其关联，游戏的所有log输出也会同时出现在关联的系统控制台中

### FreeConsole()

FreeConsole()

- 功能：如果游戏有已关联的系统控制台，则取消关联，取消关联的控制台不会自动关闭，请手动关闭
