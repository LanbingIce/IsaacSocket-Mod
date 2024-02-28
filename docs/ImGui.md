# ImGui

这个模块提供了ImGui库的方法，关于ImGui库请看[ImGui](https://github.com/ocornut/imgui)

渲染窗口需要在[ISMC_IMGUI_RENDER](Callbacks.md#ISMC_IMGUI_RENDER)回调下执行

渲染主菜单需要在[ISMC_IMGUI_MAIN_MENU_BAR_RENDER](Callbacks.md#ISMC_IMGUI_MAIN_MENU_BAR_RENDER)回调下执行

目前已经实现ImGui库中的大部分方法，由于方法数量巨大，文档还没有编写完，但是可以参考ImGui库的文档

方法严格按照ImGui库的名称，参数，返回值实现，但是由于lua和c++的差别，有以下变化规则：

- 参数中传入值的指针，并且依赖此指针返回改变之后的值->
  - 在参数中正常传入原值
  - 如果原函数有返回值，从第二个返回值开始，按照指针参数的顺序依次返回变化后的值
  - 如果原函数无返回值，从第一个返回值开始，按照指针参数的顺序依次返回变化后的值
- 支持fmt+不定量参数的格式文本->
  - 不支持格式文本，fmt改为text，需要格式文本请用lua构建
- 参数中有callback和user_data->
  - 移除callback和user_data参数
- 需要构建ImVec2或ImVec4类型的对象，作为参数传入->
  - 使用ImVec2()和ImVec4方法构建对象，作为参数传入
- 需要枚举类型作为参数->
  - 枚举类型参数全部改为integer

---

- [ImGui](#imgui)
  - [常用枚举](#常用枚举)
    - [ImGuiDir](#imguidir)
    - [ImGuiWindowFlags](#imguiwindowflags)
    - [ImGuiComboFlags](#imguicomboflags)
  - [模块函数](#模块函数)
    - [ImVec2()](#imvec2)

## 常用枚举

### ImGuiDir

```lua
local ImGuiDir = {
    ImGuiDir_None = -1,
    ImGuiDir_Left = 0,
    ImGuiDir_Right = 1,
    ImGuiDir_Up = 2,
    ImGuiDir_Down = 3,
    ImGuiDir_COUNT = 4
}
```

### ImGuiWindowFlags

```lua
local ImGuiWindowFlags = {
    ImGuiWindowFlags_None = 0,
    ImGuiWindowFlags_NoTitleBar = 1 << 0, -- Disable title-bar
    ImGuiWindowFlags_NoResize = 1 << 1, -- Disable user resizing with the lower-right grip
    ImGuiWindowFlags_NoMove = 1 << 2, -- Disable user moving the window
    ImGuiWindowFlags_NoScrollbar = 1 << 3, -- Disable scrollbars (window can still scroll with mouse or programmatically)
    ImGuiWindowFlags_NoScrollWithMouse = 1 << 4, -- Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
    ImGuiWindowFlags_NoCollapse = 1 << 5, -- Disable user collapsing window by double-clicking on it. Also referred to as Window Menu Button (e.g. within a docking node).
    ImGuiWindowFlags_AlwaysAutoResize = 1 << 6, -- Resize every window to its content every frame
    ImGuiWindowFlags_NoBackground = 1 << 7, -- Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
    ImGuiWindowFlags_NoSavedSettings = 1 << 8, -- Never load/save settings in .ini file
    ImGuiWindowFlags_NoMouseInputs = 1 << 9, -- Disable catching mouse, hovering test with pass through.
    ImGuiWindowFlags_MenuBar = 1 << 10, -- Has a menu-bar
    ImGuiWindowFlags_HorizontalScrollbar = 1 << 11, -- Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    ImGuiWindowFlags_NoFocusOnAppearing = 1 << 12, -- Disable taking focus when transitioning from hidden to visible state
    ImGuiWindowFlags_NoBringToFrontOnFocus = 1 << 13, -- Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
    ImGuiWindowFlags_AlwaysVerticalScrollbar = 1 << 14, -- Always show vertical scrollbar (even if ContentSize.y < Size.y)
    ImGuiWindowFlags_AlwaysHorizontalScrollbar = 1 << 15, -- Always show horizontal scrollbar (even if ContentSize.x < Size.x)
    ImGuiWindowFlags_NoNavInputs = 1 << 16, -- No gamepad/keyboard navigation within the window
    ImGuiWindowFlags_NoNavFocus = 1 << 17, -- No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
    ImGuiWindowFlags_UnsavedDocument = 1 << 18, -- Display a dot next to the title. When used in a tab/docking context, tab is selected when clicking the X + closure is not assumed (will wait for user to stop submitting the tab). Otherwise closure is assumed when pressing the X, so if you keep submitting the tab may reappear at end of tab bar.
    ImGuiWindowFlags_NoNav = 1 << 16 | 1 << 17,
    ImGuiWindowFlags_NoDecoration = 1 << 0 | 1 << 1 | 1 << 3 | 1 << 5,
    ImGuiWindowFlags_NoInputs = 1 << 9 | 1 << 16 | 1 << 17,

    -- [Internal]
    ImGuiWindowFlags_NavFlattened = 1 << 23, -- [BETA] On child window: share focus scope, allow gamepad/keyboard navigation to cross over parent border to this child or between sibling child windows.
    ImGuiWindowFlags_ChildWindow = 1 << 24, -- Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_Tooltip = 1 << 25, -- Don't use! For internal use by BeginTooltip()
    ImGuiWindowFlags_Popup = 1 << 26, -- Don't use! For internal use by BeginPopup()
    ImGuiWindowFlags_Modal = 1 << 27, -- Don't use! For internal use by BeginPopupModal()
    ImGuiWindowFlags_ChildMenu = 1 << 28 -- Don't use! For internal use by BeginMenu()
}
```

### ImGuiComboFlags

```lua
local ImGuiComboFlags = {
    ImGuiComboFlags_None = 0,
    ImGuiComboFlags_PopupAlignLeft = 1 << 0, -- Align the popup toward the left by default
    ImGuiComboFlags_HeightSmall = 1 << 1, -- Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
    ImGuiComboFlags_HeightRegular = 1 << 2, -- Max ~8 items visible (default)
    ImGuiComboFlags_HeightLarge = 1 << 3, -- Max ~20 items visible
    ImGuiComboFlags_HeightLargest = 1 << 4, -- As many fitting items as possible
    ImGuiComboFlags_NoArrowButton = 1 << 5, -- Display on the preview box without the square arrow button
    ImGuiComboFlags_NoPreview = 1 << 6, -- Display only a square arrow button
    ImGuiComboFlags_WidthFitPreview = 1 << 7, -- Width dynamically calculated from preview contents
    ImGuiComboFlags_HeightMask_ = 1 << 1 | 1 << 2 | 1 << 3 | 1 << 4
}
```

## 模块函数

### ImVec2()

ImVec2 ImVec2(number x,number y)

- 功能：生成一个ImVec2二维向量对象
- 参数：
  - `x`：x坐标
  - `y`：y坐标
- 返回值：
  - ImVec2二维向量对象

ImVec4 ImVec4(number x,number y,number z,number w)

- 功能：生成一个ImVec4四维向量对象
- 参数：
  - `x`：x坐标
  - `y`：y坐标
  - `z`：z坐标
  - `w`：w坐标
- 返回值：
  - ImVec4四维向量对象

AcceptDragDropPayload()

- 功能：
- 参数：
- 返回值：

---

AlignTextToFramePadding()

- 功能：
- 参数：
- 返回值：

---

boolean ArrowButton(string str_id,[ImGuiDir](#imguidir) dir)

- 功能：箭头按钮
- 参数：
  - `str_id`：控件的id
  - `dir`：箭头的方向

- 返回值：按钮被点击时，返回`true`

---

boolean, boolean Begin(string name,boolean open=true,[ImGuiWindowFlags](#imguiwindowflags) flags=0)

- 功能：开始一个普通窗口
- 参数：

  - `name`：控件的id
  - `open`：是否打开窗口 (无实际效果，只用于模拟c++的指针，如果需要关闭窗口，需要直接跳过此函数的执行)
  - `flags`：窗口的设置标志

- 返回值：

  - 是否显示窗口，如果为`false`，说明窗口被折叠
  - 是否打开窗口，如果为`false`，说明需要关闭窗口，之后请跳过此函数的执行

- 示例代码（创建一个总是自动调节尺寸，并且不能手动调节尺寸的窗口，窗口中显示一行文本）：

    ```lua
    local open = true
    local function ImGuiRender()
        local ImGui = IsaacSocket.ImGui
        local flags = 1 << 1 | 1 << 6
        if open then
            _, open = ImGui.Begin("示例窗口##window1", open, flags)
            ImGui.Text("这是一行文本")
            ImGui.End()
        end
    end
    mod:AddCallback("ISMC_IMGUI_RENDER", ImGuiRender)
    ```

---

BeginChild()

- 功能：
- 参数：
- 返回值：

---

BeginChildFrame()

- 功能：
- 参数：
- 返回值：

---

boolean BeginCombo(string label,string preview_value,[ImGuiComboFlags](#imguicomboflags) flags = 0)

- 功能：开始一个组合框
- 参数：
  - `label`：控件的id
  - `preview_value`：组合框上显示的文本
  - `flags`：组合框的设置标志

- 返回值：
  - 选择框被展开时返回`true`

---

BeginDisabled()

- 功能：
- 参数：
- 返回值：

---

BeginDragDropSource()

- 功能：
- 参数：
- 返回值：

---

BeginDragDropTarget()

- 功能：
- 参数：
- 返回值：

---

BeginGroup()

- 功能：
- 参数：
- 返回值：

---

BeginItemTooltip()

- 功能：
- 参数：
- 返回值：

---

BeginListBox()

- 功能：
- 参数：
- 返回值：

---

BeginMainMenuBar()

- 功能：
- 参数：
- 返回值：

---

BeginMenu()

- 功能：
- 参数：
- 返回值：

---

BeginMenuBar()

- 功能：
- 参数：
- 返回值：

---

BeginPopup()

- 功能：
- 参数：
- 返回值：

---

BeginPopupContextItem()

- 功能：
- 参数：
- 返回值：

---

BeginPopupContextVoid()

- 功能：
- 参数：
- 返回值：

---

BeginPopupContextWindow()

- 功能：
- 参数：
- 返回值：

---

BeginPopupModal()

- 功能：
- 参数：
- 返回值：

---

BeginTabBar()

- 功能：
- 参数：
- 返回值：

---

BeginTabItem()

- 功能：
- 参数：
- 返回值：

---

BeginTable()

- 功能：
- 参数：
- 返回值：

---

BeginTooltip()

- 功能：
- 参数：
- 返回值：

---

Bullet()

- 功能：
- 参数：
- 返回值：

---

BulletText()

- 功能：
- 参数：
- 返回值：

---

BulletTextV()

- 功能：
- 参数：
- 返回值：

---

Button()

- 功能：
- 参数：
- 返回值：

---

CalcItemWidth()

- 功能：
- 参数：
- 返回值：

---

CalcTextSize()

- 功能：
- 参数：
- 返回值：

---

CaptureKeyboardFromApp()

- 功能：
- 参数：
- 返回值：

---

CaptureMouseFromApp()

- 功能：
- 参数：
- 返回值：

---

Checkbox()

- 功能：
- 参数：
- 返回值：

---

CheckboxFlags()

- 功能：
- 参数：
- 返回值：

---

CloseCurrentPopup()

- 功能：
- 参数：
- 返回值：

---

CollapsingHeader()

- 功能：
- 参数：
- 返回值：

---

ColorButton()

- 功能：
- 参数：
- 返回值：

---

ColorConvertFloat4ToU32()

- 功能：
- 参数：
- 返回值：

---

ColorConvertHSVtoRGB()

- 功能：
- 参数：
- 返回值：

---

ColorConvertRGBtoHSV()

- 功能：
- 参数：
- 返回值：

---

ColorConvertU32ToFloat4()

- 功能：
- 参数：
- 返回值：

---

ColorEdit3()

- 功能：
- 参数：
- 返回值：

---

ColorEdit4()

- 功能：
- 参数：
- 返回值：

---

ColorPicker3()

- 功能：
- 参数：
- 返回值：

---

ColorPicker4()

- 功能：
- 参数：
- 返回值：

---

Columns()

- 功能：
- 参数：
- 返回值：

---

Combo()

- 功能：
- 参数：
- 返回值：

---

CreateContext()

- 功能：
- 参数：
- 返回值：

---

DebugCheckVersionAndDataLayout()

- 功能：
- 参数：
- 返回值：

---

DebugFlashStyleColor()

- 功能：
- 参数：
- 返回值：

---

DebugTextEncoding()

- 功能：
- 参数：
- 返回值：

---

DestroyContext()

- 功能：
- 参数：
- 返回值：

---

DragFloat()

- 功能：
- 参数：
- 返回值：

---

DragFloat2()

- 功能：
- 参数：
- 返回值：

---

DragFloat3()

- 功能：
- 参数：
- 返回值：

---

DragFloat4()

- 功能：
- 参数：
- 返回值：

---

DragFloatRange2()

- 功能：
- 参数：
- 返回值：

---

DragInt()

- 功能：
- 参数：
- 返回值：

---

DragInt2()

- 功能：
- 参数：
- 返回值：

---

DragInt3()

- 功能：
- 参数：
- 返回值：

---

DragInt4()

- 功能：
- 参数：
- 返回值：

---

DragIntRange2()

- 功能：
- 参数：
- 返回值：

---

DragScalar()

- 功能：
- 参数：
- 返回值：

---

DragScalarN()

- 功能：
- 参数：
- 返回值：

---

Dummy()

- 功能：
- 参数：
- 返回值：

---

End()

- 功能：
- 参数：
- 返回值：

---

EndChild()

- 功能：
- 参数：
- 返回值：

---

EndChildFrame()

- 功能：
- 参数：
- 返回值：

---

EndCombo()

- 功能：
- 参数：
- 返回值：

---

EndDisabled()

- 功能：
- 参数：
- 返回值：

---

EndDragDropSource()

- 功能：
- 参数：
- 返回值：

---

EndDragDropTarget()

- 功能：
- 参数：
- 返回值：

---

EndFrame()

- 功能：
- 参数：
- 返回值：

---

EndGroup()

- 功能：
- 参数：
- 返回值：

---

EndListBox()

- 功能：
- 参数：
- 返回值：

---

EndMainMenuBar()

- 功能：
- 参数：
- 返回值：

---

EndMenu()

- 功能：
- 参数：
- 返回值：

---

EndMenuBar()

- 功能：
- 参数：
- 返回值：

---

EndPopup()

- 功能：
- 参数：
- 返回值：

---

EndTabBar()

- 功能：
- 参数：
- 返回值：

---

EndTabItem()

- 功能：
- 参数：
- 返回值：

---

EndTable()

- 功能：
- 参数：
- 返回值：

---

EndTooltip()

- 功能：
- 参数：
- 返回值：

---

GetAllocatorFunctions()

- 功能：
- 参数：
- 返回值：

---

GetBackgroundDrawList()

- 功能：
- 参数：
- 返回值：

---

GetClipboardText()

- 功能：
- 参数：
- 返回值：

---

GetColorU32()

- 功能：
- 参数：
- 返回值：

---

GetColumnIndex()

- 功能：
- 参数：
- 返回值：

---

GetColumnOffset()

- 功能：
- 参数：
- 返回值：

---

GetColumnsCount()

- 功能：
- 参数：
- 返回值：

---

GetColumnWidth()

- 功能：
- 参数：
- 返回值：

---

GetContentRegionAvail()

- 功能：
- 参数：
- 返回值：

---

GetContentRegionMax()

- 功能：
- 参数：
- 返回值：

---

GetCurrentContext()

- 功能：
- 参数：
- 返回值：

---

GetCursorPos()

- 功能：
- 参数：
- 返回值：

---

GetCursorPosX()

- 功能：
- 参数：
- 返回值：

---

GetCursorPosY()

- 功能：
- 参数：
- 返回值：

---

GetCursorScreenPos()

- 功能：
- 参数：
- 返回值：

---

GetCursorStartPos()

- 功能：
- 参数：
- 返回值：

---

GetDragDropPayload()

- 功能：
- 参数：
- 返回值：

---

GetDrawData()

- 功能：
- 参数：
- 返回值：

---

GetDrawListSharedData()

- 功能：
- 参数：
- 返回值：

---

GetFont()

- 功能：
- 参数：
- 返回值：

---

GetFontSize()

- 功能：
- 参数：
- 返回值：

---

GetFontTexUvWhitePixel()

- 功能：
- 参数：
- 返回值：

---

GetForegroundDrawList()

- 功能：
- 参数：
- 返回值：

---

GetFrameCount()

- 功能：
- 参数：
- 返回值：

---

GetFrameHeight()

- 功能：
- 参数：
- 返回值：

---

GetFrameHeightWithSpacing()

- 功能：
- 参数：
- 返回值：

---

GetID()

- 功能：
- 参数：
- 返回值：

---

GetIO()

- 功能：
- 参数：
- 返回值：

---

GetItemID()

- 功能：
- 参数：
- 返回值：

---

GetItemRectMax()

- 功能：
- 参数：
- 返回值：

---

GetItemRectMin()

- 功能：
- 参数：
- 返回值：

---

GetItemRectSize()

- 功能：
- 参数：
- 返回值：

---

GetKeyIndex()

- 功能：
- 参数：
- 返回值：

---

GetKeyName()

- 功能：
- 参数：
- 返回值：

---

GetKeyPressedAmount()

- 功能：
- 参数：
- 返回值：

---

GetMainViewport()

- 功能：
- 参数：
- 返回值：

---

GetMouseClickedCount()

- 功能：
- 参数：
- 返回值：

---

GetMouseCursor()

- 功能：
- 参数：
- 返回值：

---

GetMouseDragDelta()

- 功能：
- 参数：
- 返回值：

---

GetMousePos()

- 功能：
- 参数：
- 返回值：

---

GetMousePosOnOpeningCurrentPopup()

- 功能：
- 参数：
- 返回值：

---

GetScrollMaxX()

- 功能：
- 参数：
- 返回值：

---

GetScrollMaxY()

- 功能：
- 参数：
- 返回值：

---

GetScrollX()

- 功能：
- 参数：
- 返回值：

---

GetScrollY()

- 功能：
- 参数：
- 返回值：

---

GetStateStorage()

- 功能：
- 参数：
- 返回值：

---

GetStyle()

- 功能：
- 参数：
- 返回值：

---

GetStyleColorName()

- 功能：
- 参数：
- 返回值：

---

GetStyleColorVec4()

- 功能：
- 参数：
- 返回值：

---

GetTextLineHeight()

- 功能：
- 参数：
- 返回值：

---

GetTextLineHeightWithSpacing()

- 功能：
- 参数：
- 返回值：

---

GetTime()

- 功能：
- 参数：
- 返回值：

---

GetTreeNodeToLabelSpacing()

- 功能：
- 参数：
- 返回值：

---

GetVersion()

- 功能：
- 参数：
- 返回值：

---

GetWindowContentRegionMax()

- 功能：
- 参数：
- 返回值：

---

GetWindowContentRegionMin()

- 功能：
- 参数：
- 返回值：

---

GetWindowDrawList()

- 功能：
- 参数：
- 返回值：

---

GetWindowHeight()

- 功能：
- 参数：
- 返回值：

---

GetWindowPos()

- 功能：
- 参数：
- 返回值：

---

GetWindowSize()

- 功能：
- 参数：
- 返回值：

---

GetWindowWidth()

- 功能：
- 参数：
- 返回值：

---

Image()

- 功能：
- 参数：
- 返回值：

---

ImageButton()

- 功能：
- 参数：
- 返回值：

---

Indent()

- 功能：
- 参数：
- 返回值：

---

InputDouble()

- 功能：
- 参数：
- 返回值：

---

InputFloat()

- 功能：
- 参数：
- 返回值：

---

InputFloat2()

- 功能：
- 参数：
- 返回值：

---

InputFloat3()

- 功能：
- 参数：
- 返回值：

---

InputFloat4()

- 功能：
- 参数：
- 返回值：

---

InputInt()

- 功能：
- 参数：
- 返回值：

---

InputInt2()

- 功能：
- 参数：
- 返回值：

---

InputInt3()

- 功能：
- 参数：
- 返回值：

---

InputInt4()

- 功能：
- 参数：
- 返回值：

---

InputScalar()

- 功能：
- 参数：
- 返回值：

---

InputScalarN()

- 功能：
- 参数：
- 返回值：

---

InputText()

- 功能：
- 参数：
- 返回值：

---

InputTextMultiline()

- 功能：
- 参数：
- 返回值：

---

InputTextWithHint()

- 功能：
- 参数：
- 返回值：

---

InvisibleButton()

- 功能：
- 参数：
- 返回值：

---

IsAnyItemActive()

- 功能：
- 参数：
- 返回值：

---

IsAnyItemFocused()

- 功能：
- 参数：
- 返回值：

---

IsAnyItemHovered()

- 功能：
- 参数：
- 返回值：

---

IsAnyMouseDown()

- 功能：
- 参数：
- 返回值：

---

IsItemActivated()

- 功能：
- 参数：
- 返回值：

---

IsItemActive()

- 功能：
- 参数：
- 返回值：

---

IsItemClicked()

- 功能：
- 参数：
- 返回值：

---

IsItemDeactivated()

- 功能：
- 参数：
- 返回值：

---

IsItemDeactivatedAfterEdit()

- 功能：
- 参数：
- 返回值：

---

IsItemEdited()

- 功能：
- 参数：
- 返回值：

---

IsItemFocused()

- 功能：
- 参数：
- 返回值：

---

IsItemHovered()

- 功能：
- 参数：
- 返回值：

---

IsItemToggledOpen()

- 功能：
- 参数：
- 返回值：

---

IsItemVisible()

- 功能：
- 参数：
- 返回值：

---

IsKeyChordPressed()

- 功能：
- 参数：
- 返回值：

---

IsKeyDown()

- 功能：
- 参数：
- 返回值：

---

IsKeyPressed()

- 功能：
- 参数：
- 返回值：

---

IsKeyReleased()

- 功能：
- 参数：
- 返回值：

---

IsMouseClicked()

- 功能：
- 参数：
- 返回值：

---

IsMouseDoubleClicked()

- 功能：
- 参数：
- 返回值：

---

IsMouseDown()

- 功能：
- 参数：
- 返回值：

---

IsMouseDragging()

- 功能：
- 参数：
- 返回值：

---

IsMouseHoveringRect()

- 功能：
- 参数：
- 返回值：

---

IsMousePosValid()

- 功能：
- 参数：
- 返回值：

---

IsMouseReleased()

- 功能：
- 参数：
- 返回值：

---

IsPopupOpen()

- 功能：
- 参数：
- 返回值：

---

IsRectVisible()

- 功能：
- 参数：
- 返回值：

---

IsWindowAppearing()

- 功能：
- 参数：
- 返回值：

---

IsWindowCollapsed()

- 功能：
- 参数：
- 返回值：

---

IsWindowFocused()

- 功能：
- 参数：
- 返回值：

---

IsWindowHovered()

- 功能：
- 参数：
- 返回值：

---

LabelText()

- 功能：
- 参数：
- 返回值：

---

LabelTextV()

- 功能：
- 参数：
- 返回值：

---

ListBox()

- 功能：
- 参数：
- 返回值：

---

LoadIniSettingsFromDisk()

- 功能：
- 参数：
- 返回值：

---

LoadIniSettingsFromMemory()

- 功能：
- 参数：
- 返回值：

---

LogButtons()

- 功能：
- 参数：
- 返回值：

---

LogFinish()

- 功能：
- 参数：
- 返回值：

---

LogText()

- 功能：
- 参数：
- 返回值：

---

LogTextV()

- 功能：
- 参数：
- 返回值：

---

LogToClipboard()

- 功能：
- 参数：
- 返回值：

---

LogToFile()

- 功能：
- 参数：
- 返回值：

---

LogToTTY()

- 功能：
- 参数：
- 返回值：

---

MemAlloc()

- 功能：
- 参数：
- 返回值：

---

MemFree()

- 功能：
- 参数：
- 返回值：

---

MenuItem()

- 功能：
- 参数：
- 返回值：

---

NewFrame()

- 功能：
- 参数：
- 返回值：

---

NewLine()

- 功能：
- 参数：
- 返回值：

---

NextColumn()

- 功能：
- 参数：
- 返回值：

---

OpenPopup()

- 功能：
- 参数：
- 返回值：

---

OpenPopupOnItemClick()

- 功能：
- 参数：
- 返回值：

---

PlotHistogram()

- 功能：
- 参数：
- 返回值：

---

PlotLines()

- 功能：
- 参数：
- 返回值：

---

PopAllowKeyboardFocus()

- 功能：
- 参数：
- 返回值：

---

PopButtonRepeat()

- 功能：
- 参数：
- 返回值：

---

PopClipRect()

- 功能：
- 参数：
- 返回值：

---

PopFont()

- 功能：
- 参数：
- 返回值：

---

PopID()

- 功能：
- 参数：
- 返回值：

---

PopItemWidth()

- 功能：
- 参数：
- 返回值：

---

PopStyleColor()

- 功能：
- 参数：
- 返回值：

---

PopStyleVar()

- 功能：
- 参数：
- 返回值：

---

PopTabStop()

- 功能：
- 参数：
- 返回值：

---

PopTextWrapPos()

- 功能：
- 参数：
- 返回值：

---

ProgressBar()

- 功能：
- 参数：
- 返回值：

---

PushAllowKeyboardFocus()

- 功能：
- 参数：
- 返回值：

---

PushButtonRepeat()

- 功能：
- 参数：
- 返回值：

---

PushClipRect()

- 功能：
- 参数：
- 返回值：

---

PushFont()

- 功能：
- 参数：
- 返回值：

---

PushID()

- 功能：
- 参数：
- 返回值：

---

PushItemWidth()

- 功能：
- 参数：
- 返回值：

---

PushStyleColor()

- 功能：
- 参数：
- 返回值：

---

PushStyleVar()

- 功能：
- 参数：
- 返回值：

---

PushTabStop()

- 功能：
- 参数：
- 返回值：

---

PushTextWrapPos()

- 功能：
- 参数：
- 返回值：

---

RadioButton()

- 功能：
- 参数：
- 返回值：

---

Render()

- 功能：
- 参数：
- 返回值：

---

ResetMouseDragDelta()

- 功能：
- 参数：
- 返回值：

---

SameLine()

- 功能：
- 参数：
- 返回值：

---

SaveIniSettingsToDisk()

- 功能：
- 参数：
- 返回值：

---

SaveIniSettingsToMemory()

- 功能：
- 参数：
- 返回值：

---

Selectable()

- 功能：
- 参数：
- 返回值：

---

Separator()

- 功能：
- 参数：
- 返回值：

---

SeparatorText()

- 功能：
- 参数：
- 返回值：

---

SetAllocatorFunctions()

- 功能：
- 参数：
- 返回值：

---

SetClipboardText()

- 功能：
- 参数：
- 返回值：

---

SetColorEditOptions()

- 功能：
- 参数：
- 返回值：

---

SetColumnOffset()

- 功能：
- 参数：
- 返回值：

---

SetColumnWidth()

- 功能：
- 参数：
- 返回值：

---

SetCurrentContext()

- 功能：
- 参数：
- 返回值：

---

SetCursorPos()

- 功能：
- 参数：
- 返回值：

---

SetCursorPosX()

- 功能：
- 参数：
- 返回值：

---

SetCursorPosY()

- 功能：
- 参数：
- 返回值：

---

SetCursorScreenPos()

- 功能：
- 参数：
- 返回值：

---

SetDragDropPayload()

- 功能：
- 参数：
- 返回值：

---

SetItemAllowOverlap()

- 功能：
- 参数：
- 返回值：

---

SetItemDefaultFocus()

- 功能：
- 参数：
- 返回值：

---

SetItemTooltip()

- 功能：
- 参数：
- 返回值：

---

SetItemTooltipV()

- 功能：
- 参数：
- 返回值：

---

SetKeyboardFocusHere()

- 功能：
- 参数：
- 返回值：

---

SetMouseCursor()

- 功能：
- 参数：
- 返回值：

---

SetNextFrameWantCaptureKeyboard()

- 功能：
- 参数：
- 返回值：

---

SetNextFrameWantCaptureMouse()

- 功能：
- 参数：
- 返回值：

---

SetNextItemAllowOverlap()

- 功能：
- 参数：
- 返回值：

---

SetNextItemOpen()

- 功能：
- 参数：
- 返回值：

---

SetNextItemWidth()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowBgAlpha()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowCollapsed()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowContentSize()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowFocus()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowPos()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowScroll()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowSize()

- 功能：
- 参数：
- 返回值：

---

SetNextWindowSizeConstraints()

- 功能：
- 参数：
- 返回值：

---

SetScrollFromPosX()

- 功能：
- 参数：
- 返回值：

---

SetScrollFromPosY()

- 功能：
- 参数：
- 返回值：

---

SetScrollHereX()

- 功能：
- 参数：
- 返回值：

---

SetScrollHereY()

- 功能：
- 参数：
- 返回值：

---

SetScrollX()

- 功能：
- 参数：
- 返回值：

---

SetScrollY()

- 功能：
- 参数：
- 返回值：

---

SetStateStorage()

- 功能：
- 参数：
- 返回值：

---

SetTabItemClosed()

- 功能：
- 参数：
- 返回值：

---

SetTooltip()

- 功能：
- 参数：
- 返回值：

---

SetTooltipV()

- 功能：
- 参数：
- 返回值：

---

SetWindowCollapsed()

- 功能：
- 参数：
- 返回值：

---

SetWindowFocus()

- 功能：
- 参数：
- 返回值：

---

SetWindowFontScale()

- 功能：
- 参数：
- 返回值：

---

SetWindowPos()

- 功能：
- 参数：
- 返回值：

---

SetWindowSize()

- 功能：
- 参数：
- 返回值：

---

ShowAboutWindow()

- 功能：
- 参数：
- 返回值：

---

ShowDebugLogWindow()

- 功能：
- 参数：
- 返回值：

---

ShowDemoWindow()

- 功能：
- 参数：
- 返回值：

---

ShowFontSelector()

- 功能：
- 参数：
- 返回值：

---

ShowIDStackToolWindow()

- 功能：
- 参数：
- 返回值：

---

ShowMetricsWindow()

- 功能：
- 参数：
- 返回值：

---

ShowStackToolWindow()

- 功能：
- 参数：
- 返回值：

---

ShowStyleEditor()

- 功能：
- 参数：
- 返回值：

---

ShowStyleSelector()

- 功能：
- 参数：
- 返回值：

---

ShowUserGuide()

- 功能：
- 参数：
- 返回值：

---

SliderAngle()

- 功能：
- 参数：
- 返回值：

---

SliderFloat()

- 功能：
- 参数：
- 返回值：

---

SliderFloat2()

- 功能：
- 参数：
- 返回值：

---

SliderFloat3()

- 功能：
- 参数：
- 返回值：

---

SliderFloat4()

- 功能：
- 参数：
- 返回值：

---

SliderInt()

- 功能：
- 参数：
- 返回值：

---

SliderInt2()

- 功能：
- 参数：
- 返回值：

---

SliderInt3()

- 功能：
- 参数：
- 返回值：

---

SliderInt4()

- 功能：
- 参数：
- 返回值：

---

SliderScalar()

- 功能：
- 参数：
- 返回值：

---

SliderScalarN()

- 功能：
- 参数：
- 返回值：

---

SmallButton()

- 功能：
- 参数：
- 返回值：

---

Spacing()

- 功能：
- 参数：
- 返回值：

---

StyleColorsClassic()

- 功能：
- 参数：
- 返回值：

---

StyleColorsDark()

- 功能：
- 参数：
- 返回值：

---

StyleColorsLight()

- 功能：
- 参数：
- 返回值：

---

TabItemButton()

- 功能：
- 参数：
- 返回值：

---

TableAngledHeadersRow()

- 功能：
- 参数：
- 返回值：

---

TableGetColumnCount()

- 功能：
- 参数：
- 返回值：

---

TableGetColumnFlags()

- 功能：
- 参数：
- 返回值：

---

TableGetColumnIndex()

- 功能：
- 参数：
- 返回值：

---

TableGetColumnName()

- 功能：
- 参数：
- 返回值：

---

TableGetRowIndex()

- 功能：
- 参数：
- 返回值：

---

TableGetSortSpecs()

- 功能：
- 参数：
- 返回值：

---

TableHeader()

- 功能：
- 参数：
- 返回值：

---

TableHeadersRow()

- 功能：
- 参数：
- 返回值：

---

TableNextColumn()

- 功能：
- 参数：
- 返回值：

---

TableNextRow()

- 功能：
- 参数：
- 返回值：

---

TableSetBgColor()

- 功能：
- 参数：
- 返回值：

---

TableSetColumnEnabled()

- 功能：
- 参数：
- 返回值：

---

TableSetColumnIndex()

- 功能：
- 参数：
- 返回值：

---

TableSetupColumn()

- 功能：
- 参数：
- 返回值：

---

TableSetupScrollFreeze()

- 功能：
- 参数：
- 返回值：

---

Text()

- 功能：
- 参数：
- 返回值：

---

TextColored()

- 功能：
- 参数：
- 返回值：

---

TextColoredV()

- 功能：
- 参数：
- 返回值：

---

TextDisabled()

- 功能：
- 参数：
- 返回值：

---

TextDisabledV()

- 功能：
- 参数：
- 返回值：

---

TextUnformatted()

- 功能：
- 参数：
- 返回值：

---

TextV()

- 功能：
- 参数：
- 返回值：

---

TextWrapped()

- 功能：
- 参数：
- 返回值：

---

TextWrappedV()

- 功能：
- 参数：
- 返回值：

---

TreeNode()

- 功能：
- 参数：
- 返回值：

---

TreeNodeEx()

- 功能：
- 参数：
- 返回值：

---

TreeNodeExV()

- 功能：
- 参数：
- 返回值：

---

TreeNodeV()

- 功能：
- 参数：
- 返回值：

---

TreePop()

- 功能：
- 参数：
- 返回值：

---

TreePush()

- 功能：
- 参数：
- 返回值：

---

Unindent()

- 功能：
- 参数：
- 返回值：

---

Value()

- 功能：
- 参数：
- 返回值：

---

VSliderFloat()

- 功能：
- 参数：
- 返回值：

---

VSliderInt()

- 功能：
- 参数：
- 返回值：

---

VSliderScalar()

- 功能：
- 参数：
- 返回值：

---
