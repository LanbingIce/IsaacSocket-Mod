# IsaacSocket-Mod

这是一个 **《以撒的结合》** 的Mod，可以为其他Mod提供连接 **WebSocket**，发送 **HTTP 请求** 的功能接口，甚至提供了大量以撒官方未开放的API以及部分系统API

[TOC]

## 如何安装和使用

1. 从 [创意工坊](https://steamcommunity.com/sharedfiles/filedetails/?id=3033763718) 订阅 Mod：**IsaacSocket**  ，启动游戏并确保已经在Mod管理器中将其开启
2. 下载 [IsaacSocket 连接工具](https://github.com/LanbingIce/IsaacSocket-Utility/releases/latest) 并将其启动  
3. 进入一局游戏，当看到游戏画面的左上角出现绿色的 **IsaacSocket 连接成功!** 的字样，说明 **IsaacSocket** 已经正常工作

4. 如果遇到问题，请看[常见问题](#常见问题)，如果仍然没有解决，请联系作者[B站账号](https://space.bilibili.com/15109387)

## 我是Mod开发者，想要查看开发文档

请移步[开发文档](docs/IsaacSocket.md)

## 常见问题

**Q:** 打开 **IsaacSocket 连接工具** 之后，游戏直接闪退了  
**A:** 这是因为创意工坊没有帮你自动更新mod，你的mod版本太旧了，请按照以下步骤手动更新：

1. 进入创意工坊，将 **IsaacSocket** 取消订阅
2. 退出 **IsaacSocket 连接工具** ，进入游戏，打开mod列表，确认没有 **IsaacSocket**；如果还有，重进一次游戏
3. 进入创意工坊，订阅 **IsaacSocket**
4. 进入游戏，打开mod列表，确认 **IsaacSocket** 已经开启

**Q:** 已经按照安装使用步骤做了每一步，为什么游戏上方出现一行白字提示连接失败  
**A:** 有以下几种可能，请逐一排查：

- 你的以撒是以管理员模式启动的，请尝试用管理员模式启动 **IsaacSocket 连接工具**
- **IsaacSocket 连接工具** 的内存操作被你的杀毒软件拦截了，请尝试关闭杀毒软件
- 你的**IsaacSocket**或者**IsaacSocket 连接工具** 的版本太旧了，请将它们都升级到最新版然后重启游戏再试
- 你在游戏中安装并开启了多个**IsaacSocket**，请将多余的关闭或删除  

**Q:** 既没有看到绿色的连接成功，也没有看到白色的连接失败  
**A:** 请确保你已经订阅并在游戏的Mod管理器中启用了**IsaacSocket**  

**Q:** 游戏上方确实出现了绿色或白色的提示字，但是糊作一团完全看不出是什么字  
**A:** 因为你在游戏设置中开启了“滤镜”选项，请将其关闭，以撒的滤镜效果是让画面变得圆滑，但是算法很垃圾，完全是在降低画面清晰度，建议不要开启  

**Q:** 盗版游戏可以使用吗？  
**A:** 可以，但是请确保自己的游戏版本是最新的，与steam上的版本相同，并且你需要自己手动安装Mod，这里不提供教程  

如果您的问题仍然没有解决，请联系作者[B站账号](https://space.bilibili.com/15109387)
