# IsaacAPI

这个模块提供了一些以撒官方API没有提供的接口

- [IsaacAPI](#isaacapi)
  - [模块函数](#模块函数)
    - [ReloadLua()](#reloadlua)
    - [ForcePause()](#forcepause)
    - [IsForcePaused()](#isforcepaused)
    - [GetDebugFlag()](#getdebugflag)
    - [GetConsoleInput()](#getconsoleinput)
    - [IsConsoleOpen()](#isconsoleopen)
    - [SetCanShoot()](#setcanshoot)
    - [IsPauseMenuForceHidden()](#ispausemenuforcehidden)
    - [ForceHidePauseMenu()](#forcehidepausemenu)
    - [GetActive()](#getactive)
    - [SetActive()](#setactive)
    - [GetEdenTokens()](#getedentokens)
    - [SetEdenTokens()](#setedentokens)
    - [IsAchievementUnlocked()](#isachievementunlocked)
    - [UnlockAchievement()](#unlockachievement)
    - [IsMTRandomLocked()](#ismtrandomlocked)
    - [LockMTRandom()](#lockmtrandom)

## 模块函数

### ReloadLua()

ReloadLua(boolean luaDebug=luaDebug)

- 注意：由于在游戏进行中调用会出现一些已知问题，因此如果需要在正式版本中调用此方法，请在小退的回调中调用，这样会在菜单界面重置，与游戏本体的重置方式一致，不会出现任何问题
- 功能：重置游戏的**Lua环境**，所有mod都会被重新加载，与在mod菜单界面开关mod之后触发的重新加载的效果完全一致，可以替代**luamod**用于测试
- 参数：
  - `luaDebug`：是否开启**luaDebug**，留空则维持原状
- 已知问题：
  - 在游戏进行中调用会导致：
    - 在当前房间击杀怪物时，有时会导致游戏崩溃/卡住/出现意外的特效，小退恢复正常
    - 当前房间若有苍蝇，则其音效永远不会结束，小退无法恢复正常
    - 角色的影子尺寸不正常，消失或者变得很大，小退恢复正常
    - 角色的质量不正常，表现为角色不能推动任何实体，小退恢复正常
    - 如果你开启了某些mod（比如EID或者东方之类的大型mod），会导致游戏崩溃
    - 使用换人器会使游戏崩溃

- 示例（在小退回调时调用）：

  ```lua
  local function OnGameExit(_, shouldSave)
      if shouldSave then
          IsaacSocket.IsaacAPI.ReloadLua()
      end
  end
  
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, OnGameExit)
  ```

### ForcePause()

ForcePause(boolean pause=true)

- 功能：强制暂停/取消强制暂停游戏，强制暂停将导致 **Update** 完全停止，`Game():IsPaused()`返回`true`，无法呼出官方控制台和暂停菜单，不会影响 **Render** 以及获取按键输入。
- 参数：
  - `pause`：是否强制暂停，`true` 强制暂停，`false` 取消强制暂停
- 自动恢复：此接口具有自动恢复特性，当IsaacSocket断开连接时，会自动取消强制暂停

### IsForcePaused()

boolean IsForcePaused()

- 判断当前是否强制暂停
- 返回值：`true` 当前强制暂停，`false` 当前没有强制暂停

### GetDebugFlag()

integer GetDebugFlag()

- 功能：获取当前的 **debug标志**
- 返回值：按位存储了 **debug标志** 的整数，最低位为**debug 1**，请用位与 `&` 运算符取出所需的标志位
- 使用示例：
  
```lua
local debugFlag = IsaacSocket.IsaacAPI.GetDebugFlag()
for i = 1, 14 do
    if debugFlag & 2 ^ (i - 1) ~= 0 then
        print("Debug " .. i .. " is Enabled")
    end
end
```

### GetConsoleInput()

string GetConsoleInput()

- 功能：获取当前官方控制台的输入框中的文本

### IsConsoleOpen()

boolean IsConsoleOpen()

- 功能：判断用户是否呼出了官方控制台

### SetCanShoot()

SetCanShoot(integer playerId=0,canShoot=true)

- 功能：设置角色是否能射击，可以用来蒙眼或者解除蒙眼
- 参数：
  - `canShoot`：角色是否能射击

### IsPauseMenuForceHidden()

boolean IsPauseMenuForceHidden()

- 功能：查询是否强制隐藏了暂停菜单

### ForceHidePauseMenu()

ForceHidePauseMenu(boolean hide=true)

- 功能：强制隐藏/解除强制隐藏暂停菜单，只在游戏暂停并显示了暂停菜单时才有效，在强制隐藏状态下，玩家将无法取消暂停
- 参数：
  - `hide`：是否强制隐藏暂停菜单
- 自动恢复：此接口具有自动恢复特性，当**IsaacSocket**断开连接时，会自动取消强制隐藏

### GetActive()

table GetActive(integer playerId=0,[ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html?h=activ) activeId=0)

- 功能：获取角色的主动信息

- 参数：

  - `playerId`：角色id
  - `activeId`：主动槽位

- 返回值：这样格式的一个表

  ```lua
  local active = {
      item = 105,
      charge = 0,
      batteryCharge = 0,
      subCharge = 0,
      timedRechargeCooldown = 0,
      partialCharge = 0.0,
      varData = 0
  }
  ```

  具体字段含义可以参考官方文档[PlayerTypesActiveItemDesc](https://moddingofisaac.com/docs/rep/PlayerTypes_ActiveItemDesc.html)

  注意不要直接复制官方文档中的字段，因为它们是首字母大写的

  这个表可以用于[SetActive()](#setactive)的参数，但是一般来说没有必要这样做

### SetActive()

SetActive(integer playerId=0,[ActiveSlot](https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html?h=activ) activeId=0,table active)

- 功能：设置主动的属性

- 参数：

  - `playerId`：角色id

  - `activeId`：主动槽位

  - `active`：要设置的主动属性，表的格式应该像这样：

    ```lua
    local active = {
        item = 105,
        charge = 0,
        batteryCharge = 0,
        subCharge = 0,
        timedRechargeCooldown = 0,
        partialCharge = 0.0,
        varData = 0
    }
    ```

    表中所有的字段都不是必须的，你只需要指定你需要修改的字段即可，缺失的字段将维持原样

    具体字段含义可以参考官方文档[PlayerTypesActiveItemDesc](https://moddingofisaac.com/docs/rep/PlayerTypes_ActiveItemDesc.html)

    注意不要直接复制官方文档中的字段，因为它们是首字母大写的

### GetEdenTokens()

integer GetEdenTokens()

- 功能：获取当前的伊甸币数量

### SetEdenTokens()

SetEdenTokens(integer tokens)

- 功能：设置伊甸币数量为指定值
- 参数：
  - `tokens`：要设定的伊甸币数量的值

### IsAchievementUnlocked()

boolean IsAchievementUnlocked(integer achievementId=0)

- 功能：查询指定成就是否解锁/查询是否已解锁全成就
- 参数：
  - `achievementId`：要查询的成就id，传入0代表查询是否已解锁全成就

### UnlockAchievement()

UnlockAchievement(integer achievementId,boolean unlock=true)

- 功能：解锁/锁定指定成就
- 参数：
  - `achievementId`：要解锁/锁定的成就id，传入0代表所有成就
  - `unlock`：`true`表示解锁，`false`表示锁定

### IsMTRandomLocked()

boolean IsMTRandomLocked()

- 查询真随机的随机结果是否被锁定了，如需获取被锁定的具体值，可以调用`Random()`函数来获取

### LockMTRandom()

LockMTRandom(integer value=0)

- 功能：锁定/解除锁定真随机的随机结果为指定值，对伪随机无效，调用后可以通过`Random()`函数查看效果
- 参数：
  - `value`：要锁定的值，传入0将解除锁定
- 自动恢复：此接口具有自动恢复特性，当**IsaacSocket**断开连接时，会自动解除锁定
