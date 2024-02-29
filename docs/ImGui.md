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
    - [ImVec4()](#imvec4)
    - [CreateContext()](#createcontext)
    - [DestroyContext()](#destroycontext)
    - [GetCurrentContext()](#getcurrentcontext)
    - [SetCurrentContext()](#setcurrentcontext)
    - [GetIO()](#getio)
    - [GetStyle()](#getstyle)
    - [NewFrame()](#newframe)
    - [EndFrame()](#endframe)
    - [Render()](#render)
    - [GetDrawData()](#getdrawdata)
    - [ShowDemoWindow()](#showdemowindow)
    - [ShowMetricsWindow()](#showmetricswindow)
    - [ShowDebugLogWindow()](#showdebuglogwindow)
    - [ShowIDStackToolWindow()](#showidstacktoolwindow)
    - [ShowAboutWindow()](#showaboutwindow)
    - [ShowStyleEditor()](#showstyleeditor)
    - [ShowStyleSelector()](#showstyleselector)
    - [ShowFontSelector()](#showfontselector)
    - [ShowUserGuide()](#showuserguide)
    - [GetVersion()](#getversion)
    - [StyleColorsDark()](#stylecolorsdark)
    - [StyleColorsLight()](#stylecolorslight)
    - [StyleColorsClassic()](#stylecolorsclassic)
    - [Begin()](#begin)
    - [End()](#end)
    - [BeginChild()](#beginchild)
    - [EndChild()](#endchild)
    - [IsWindowAppearing()](#iswindowappearing)
    - [IsWindowCollapsed()](#iswindowcollapsed)
    - [IsWindowFocused()](#iswindowfocused)
    - [IsWindowHovered()](#iswindowhovered)
    - [GetWindowDrawList()](#getwindowdrawlist)
    - [GetWindowPos()](#getwindowpos)
    - [GetWindowSize()](#getwindowsize)
    - [GetWindowWidth()](#getwindowwidth)
    - [GetWindowHeight()](#getwindowheight)
    - [SetNextWindowPos()](#setnextwindowpos)
    - [SetNextWindowSize()](#setnextwindowsize)
    - [SetNextWindowSizeConstraints()](#setnextwindowsizeconstraints)
    - [SetNextWindowContentSize()](#setnextwindowcontentsize)
    - [SetNextWindowCollapsed()](#setnextwindowcollapsed)
    - [SetNextWindowFocus()](#setnextwindowfocus)
    - [SetNextWindowScroll()](#setnextwindowscroll)
    - [SetNextWindowBgAlpha()](#setnextwindowbgalpha)
    - [SetWindowPos()](#setwindowpos)
    - [SetWindowSize()](#setwindowsize)
    - [SetWindowCollapsed()](#setwindowcollapsed)
    - [SetWindowFocus()](#setwindowfocus)
    - [SetWindowFontScale()](#setwindowfontscale)
    - [GetContentRegionAvail()](#getcontentregionavail)
    - [GetContentRegionMax()](#getcontentregionmax)
    - [GetWindowContentRegionMin()](#getwindowcontentregionmin)
    - [GetWindowContentRegionMax()](#getwindowcontentregionmax)
    - [GetScrollX()](#getscrollx)
    - [GetScrollY()](#getscrolly)
    - [SetScrollX()](#setscrollx)
    - [SetScrollY()](#setscrolly)
    - [GetScrollMaxX()](#getscrollmaxx)
    - [GetScrollMaxY()](#getscrollmaxy)
    - [SetScrollHereX()](#setscrollherex)
    - [SetScrollHereY()](#setscrollherey)
    - [SetScrollFromPosX()](#setscrollfromposx)
    - [SetScrollFromPosY()](#setscrollfromposy)
    - [PushFont()](#pushfont)
    - [PopFont()](#popfont)
    - [PushStyleColor()](#pushstylecolor)
    - [PopStyleColor()](#popstylecolor)
    - [PushStyleVar()](#pushstylevar)
    - [PopStyleVar()](#popstylevar)
    - [PushTabStop()](#pushtabstop)
    - [PopTabStop()](#poptabstop)
    - [PushButtonRepeat()](#pushbuttonrepeat)
    - [PopButtonRepeat()](#popbuttonrepeat)
    - [PushItemWidth()](#pushitemwidth)
    - [PopItemWidth()](#popitemwidth)
    - [SetNextItemWidth()](#setnextitemwidth)
    - [CalcItemWidth()](#calcitemwidth)
    - [PushTextWrapPos()](#pushtextwrappos)
    - [PopTextWrapPos()](#poptextwrappos)
    - [GetFont()](#getfont)
    - [GetFontSize()](#getfontsize)
    - [GetFontTexUvWhitePixel()](#getfonttexuvwhitepixel)
    - [GetColorU32()](#getcoloru32)
    - [GetStyleColorVec4()](#getstylecolorvec4)
    - [GetCursorScreenPos()](#getcursorscreenpos)
    - [SetCursorScreenPos()](#setcursorscreenpos)
    - [GetCursorPos()](#getcursorpos)
    - [GetCursorPosX()](#getcursorposx)
    - [GetCursorPosY()](#getcursorposy)
    - [SetCursorPos()](#setcursorpos)
    - [SetCursorPosX()](#setcursorposx)
    - [SetCursorPosY()](#setcursorposy)
    - [GetCursorStartPos()](#getcursorstartpos)
    - [Separator()](#separator)
    - [SameLine()](#sameline)
    - [NewLine()](#newline)
    - [Spacing()](#spacing)
    - [Dummy()](#dummy)
    - [Indent()](#indent)
    - [Unindent()](#unindent)
    - [BeginGroup()](#begingroup)
    - [EndGroup()](#endgroup)
    - [AlignTextToFramePadding()](#aligntexttoframepadding)
    - [GetTextLineHeight()](#gettextlineheight)
    - [GetTextLineHeightWithSpacing()](#gettextlineheightwithspacing)
    - [GetFrameHeight()](#getframeheight)
    - [GetFrameHeightWithSpacing()](#getframeheightwithspacing)
    - [PushID()](#pushid)
    - [PopID()](#popid)
    - [GetID()](#getid)
    - [TextUnformatted()](#textunformatted)
    - [Text()](#text)
    - [TextV()](#textv)
    - [TextColored()](#textcolored)
    - [TextColoredV()](#textcoloredv)
    - [TextDisabled()](#textdisabled)
    - [TextDisabledV()](#textdisabledv)
    - [TextWrapped()](#textwrapped)
    - [TextWrappedV()](#textwrappedv)
    - [LabelText()](#labeltext)
    - [LabelTextV()](#labeltextv)
    - [BulletText()](#bullettext)
    - [BulletTextV()](#bullettextv)
    - [SeparatorText()](#separatortext)
    - [Button()](#button)
    - [SmallButton()](#smallbutton)
    - [InvisibleButton()](#invisiblebutton)
    - [ArrowButton()](#arrowbutton)
    - [Checkbox()](#checkbox)
    - [CheckboxFlags()](#checkboxflags)
    - [RadioButton()](#radiobutton)
    - [ProgressBar()](#progressbar)
    - [Bullet()](#bullet)
    - [Image()](#image)
    - [ImageButton()](#imagebutton)
    - [BeginCombo()](#begincombo)
    - [EndCombo()](#endcombo)
    - [Combo()](#combo)
    - [DragFloat()](#dragfloat)
    - [DragFloat2()](#dragfloat2)
    - [DragFloat3()](#dragfloat3)
    - [DragFloat4()](#dragfloat4)
    - [DragFloatRange2()](#dragfloatrange2)
    - [DragInt()](#dragint)
    - [DragInt2()](#dragint2)
    - [DragInt3()](#dragint3)
    - [DragInt4()](#dragint4)
    - [DragIntRange2()](#dragintrange2)
    - [DragScalar()](#dragscalar)
    - [DragScalarN()](#dragscalarn)
    - [SliderFloat()](#sliderfloat)
    - [SliderFloat2()](#sliderfloat2)
    - [SliderFloat3()](#sliderfloat3)
    - [SliderFloat4()](#sliderfloat4)
    - [SliderAngle()](#sliderangle)
    - [SliderInt()](#sliderint)
    - [SliderInt2()](#sliderint2)
    - [SliderInt3()](#sliderint3)
    - [SliderInt4()](#sliderint4)
    - [SliderScalar()](#sliderscalar)
    - [SliderScalarN()](#sliderscalarn)
    - [VSliderFloat()](#vsliderfloat)
    - [VSliderInt()](#vsliderint)
    - [VSliderScalar()](#vsliderscalar)
    - [InputText()](#inputtext)
    - [InputTextMultiline()](#inputtextmultiline)
    - [InputTextWithHint()](#inputtextwithhint)
    - [InputFloat()](#inputfloat)
    - [InputFloat2()](#inputfloat2)
    - [InputFloat3()](#inputfloat3)
    - [InputFloat4()](#inputfloat4)
    - [InputInt()](#inputint)
    - [InputInt2()](#inputint2)
    - [InputInt3()](#inputint3)
    - [InputInt4()](#inputint4)
    - [InputDouble()](#inputdouble)
    - [InputScalar()](#inputscalar)
    - [InputScalarN()](#inputscalarn)
    - [ColorEdit3()](#coloredit3)
    - [ColorEdit4()](#coloredit4)
    - [ColorPicker3()](#colorpicker3)
    - [ColorPicker4()](#colorpicker4)
    - [ColorButton()](#colorbutton)
    - [SetColorEditOptions()](#setcoloreditoptions)
    - [TreeNode()](#treenode)
    - [TreeNodeV()](#treenodev)
    - [TreeNodeEx()](#treenodeex)
    - [TreeNodeExV()](#treenodeexv)
    - [TreePush()](#treepush)
    - [TreePop()](#treepop)
    - [GetTreeNodeToLabelSpacing()](#gettreenodetolabelspacing)
    - [CollapsingHeader()](#collapsingheader)
    - [SetNextItemOpen()](#setnextitemopen)
    - [Selectable()](#selectable)
    - [BeginListBox()](#beginlistbox)
    - [EndListBox()](#endlistbox)
    - [ListBox()](#listbox)
    - [PlotLines()](#plotlines)
    - [PlotHistogram()](#plothistogram)
    - [Value()](#value)
    - [BeginMenuBar()](#beginmenubar)
    - [EndMenuBar()](#endmenubar)
    - [BeginMainMenuBar()](#beginmainmenubar)
    - [EndMainMenuBar()](#endmainmenubar)
    - [BeginMenu()](#beginmenu)
    - [EndMenu()](#endmenu)
    - [MenuItem()](#menuitem)
    - [BeginTooltip()](#begintooltip)
    - [EndTooltip()](#endtooltip)
    - [SetTooltip()](#settooltip)
    - [SetTooltipV()](#settooltipv)
    - [BeginItemTooltip()](#beginitemtooltip)
    - [SetItemTooltip()](#setitemtooltip)
    - [SetItemTooltipV()](#setitemtooltipv)
    - [BeginPopup()](#beginpopup)
    - [BeginPopupModal()](#beginpopupmodal)
    - [EndPopup()](#endpopup)
    - [OpenPopup()](#openpopup)
    - [OpenPopupOnItemClick()](#openpopuponitemclick)
    - [CloseCurrentPopup()](#closecurrentpopup)
    - [BeginPopupContextItem()](#beginpopupcontextitem)
    - [BeginPopupContextWindow()](#beginpopupcontextwindow)
    - [BeginPopupContextVoid()](#beginpopupcontextvoid)
    - [IsPopupOpen()](#ispopupopen)
    - [BeginTable()](#begintable)
    - [EndTable()](#endtable)
    - [TableNextRow()](#tablenextrow)
    - [TableNextColumn()](#tablenextcolumn)
    - [TableSetColumnIndex()](#tablesetcolumnindex)
    - [TableSetupColumn()](#tablesetupcolumn)
    - [TableSetupScrollFreeze()](#tablesetupscrollfreeze)
    - [TableHeader()](#tableheader)
    - [TableHeadersRow()](#tableheadersrow)
    - [TableAngledHeadersRow()](#tableangledheadersrow)
    - [TableGetSortSpecs()](#tablegetsortspecs)
    - [TableGetColumnCount()](#tablegetcolumncount)
    - [TableGetColumnIndex()](#tablegetcolumnindex)
    - [TableGetRowIndex()](#tablegetrowindex)
    - [TableGetColumnName()](#tablegetcolumnname)
    - [TableGetColumnFlags()](#tablegetcolumnflags)
    - [TableSetColumnEnabled()](#tablesetcolumnenabled)
    - [TableSetBgColor()](#tablesetbgcolor)
    - [Columns()](#columns)
    - [NextColumn()](#nextcolumn)
    - [GetColumnIndex()](#getcolumnindex)
    - [GetColumnWidth()](#getcolumnwidth)
    - [SetColumnWidth()](#setcolumnwidth)
    - [GetColumnOffset()](#getcolumnoffset)
    - [SetColumnOffset()](#setcolumnoffset)
    - [GetColumnsCount()](#getcolumnscount)
    - [BeginTabBar()](#begintabbar)
    - [EndTabBar()](#endtabbar)
    - [BeginTabItem()](#begintabitem)
    - [EndTabItem()](#endtabitem)
    - [TabItemButton()](#tabitembutton)
    - [SetTabItemClosed()](#settabitemclosed)
    - [LogToTTY()](#logtotty)
    - [LogToFile()](#logtofile)
    - [LogToClipboard()](#logtoclipboard)
    - [LogFinish()](#logfinish)
    - [LogButtons()](#logbuttons)
    - [LogText()](#logtext)
    - [LogTextV()](#logtextv)
    - [BeginDragDropSource()](#begindragdropsource)
    - [SetDragDropPayload()](#setdragdroppayload)
    - [EndDragDropSource()](#enddragdropsource)
    - [BeginDragDropTarget()](#begindragdroptarget)
    - [AcceptDragDropPayload()](#acceptdragdroppayload)
    - [EndDragDropTarget()](#enddragdroptarget)
    - [GetDragDropPayload()](#getdragdroppayload)
    - [BeginDisabled()](#begindisabled)
    - [EndDisabled()](#enddisabled)
    - [PushClipRect()](#pushcliprect)
    - [PopClipRect()](#popcliprect)
    - [SetItemDefaultFocus()](#setitemdefaultfocus)
    - [SetKeyboardFocusHere()](#setkeyboardfocushere)
    - [SetNextItemAllowOverlap()](#setnextitemallowoverlap)
    - [IsItemHovered()](#isitemhovered)
    - [IsItemActive()](#isitemactive)
    - [IsItemFocused()](#isitemfocused)
    - [IsItemClicked()](#isitemclicked)
    - [IsItemVisible()](#isitemvisible)
    - [IsItemEdited()](#isitemedited)
    - [IsItemActivated()](#isitemactivated)
    - [IsItemDeactivated()](#isitemdeactivated)
    - [IsItemDeactivatedAfterEdit()](#isitemdeactivatedafteredit)
    - [IsItemToggledOpen()](#isitemtoggledopen)
    - [IsAnyItemHovered()](#isanyitemhovered)
    - [IsAnyItemActive()](#isanyitemactive)
    - [IsAnyItemFocused()](#isanyitemfocused)
    - [GetItemID()](#getitemid)
    - [GetItemRectMin()](#getitemrectmin)
    - [GetItemRectMax()](#getitemrectmax)
    - [GetItemRectSize()](#getitemrectsize)
    - [GetMainViewport()](#getmainviewport)
    - [GetBackgroundDrawList()](#getbackgrounddrawlist)
    - [GetForegroundDrawList()](#getforegrounddrawlist)
    - [IsRectVisible()](#isrectvisible)
    - [GetTime()](#gettime)
    - [GetFrameCount()](#getframecount)
    - [GetDrawListSharedData()](#getdrawlistshareddata)
    - [GetStyleColorName()](#getstylecolorname)
    - [SetStateStorage()](#setstatestorage)
    - [GetStateStorage()](#getstatestorage)
    - [CalcTextSize()](#calctextsize)
    - [ColorConvertU32ToFloat4()](#colorconvertu32tofloat4)
    - [ColorConvertFloat4ToU32()](#colorconvertfloat4tou32)
    - [ColorConvertRGBtoHSV()](#colorconvertrgbtohsv)
    - [ColorConvertHSVtoRGB()](#colorconverthsvtorgb)
    - [IsKeyDown()](#iskeydown)
    - [IsKeyPressed()](#iskeypressed)
    - [IsKeyReleased()](#iskeyreleased)
    - [IsKeyChordPressed()](#iskeychordpressed)
    - [GetKeyPressedAmount()](#getkeypressedamount)
    - [GetKeyName()](#getkeyname)
    - [SetNextFrameWantCaptureKeyboard()](#setnextframewantcapturekeyboard)
    - [IsMouseDown()](#ismousedown)
    - [IsMouseClicked()](#ismouseclicked)
    - [IsMouseReleased()](#ismousereleased)
    - [IsMouseDoubleClicked()](#ismousedoubleclicked)
    - [GetMouseClickedCount()](#getmouseclickedcount)
    - [IsMouseHoveringRect()](#ismousehoveringrect)
    - [IsMousePosValid()](#ismouseposvalid)
    - [IsAnyMouseDown()](#isanymousedown)
    - [GetMousePos()](#getmousepos)
    - [GetMousePosOnOpeningCurrentPopup()](#getmouseposonopeningcurrentpopup)
    - [IsMouseDragging()](#ismousedragging)
    - [GetMouseDragDelta()](#getmousedragdelta)
    - [ResetMouseDragDelta()](#resetmousedragdelta)
    - [ImGuiMouseCursor()](#imguimousecursor)
    - [SetMouseCursor()](#setmousecursor)
    - [SetNextFrameWantCaptureMouse()](#setnextframewantcapturemouse)
    - [GetClipboardText()](#getclipboardtext)
    - [SetClipboardText()](#setclipboardtext)
    - [LoadIniSettingsFromDisk()](#loadinisettingsfromdisk)
    - [LoadIniSettingsFromMemory()](#loadinisettingsfrommemory)
    - [SaveIniSettingsToDisk()](#saveinisettingstodisk)
    - [SaveIniSettingsToMemory()](#saveinisettingstomemory)
    - [DebugTextEncoding()](#debugtextencoding)
    - [DebugFlashStyleColor()](#debugflashstylecolor)
    - [DebugStartItemPicker()](#debugstartitempicker)
    - [DebugCheckVersionAndDataLayout()](#debugcheckversionanddatalayout)
    - [SetAllocatorFunctions()](#setallocatorfunctions)
    - [GetAllocatorFunctions()](#getallocatorfunctions)
    - [MemAlloc()](#memalloc)
    - [MemFree()](#memfree)

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

---

### ImVec4()

ImVec4 ImVec4(number x,number y,number z,number w)

- 功能：生成一个ImVec4四维向量对象
- 参数：
  - `x`：x坐标
  - `y`：y坐标
  - `z`：z坐标
  - `w`：w坐标
- 返回值：
  - ImVec4四维向量对象

---

### CreateContext()

 ImGuiContext\* CreateContext(ImFontAtlas* shared_font_atlas = NULL)

- 功能：
- 参数：
- 返回值：

---

### DestroyContext()

 void DestroyContext(ImGuiContext* ctx = NULL)

- 功能：
- 参数：
- 返回值：

---

### GetCurrentContext()

 ImGuiContext* GetCurrentContext()

- 功能：
- 参数：
- 返回值：

---

### SetCurrentContext()

 void SetCurrentContext(ImGuiContext* ctx)

- 功能：
- 参数：
- 返回值：

---

### GetIO()

 ImGuiIO& GetIO()

- 功能：
- 参数：
- 返回值：

---

### GetStyle()

 ImGuiStyle& GetStyle()

- 功能：
- 参数：
- 返回值：

---

### NewFrame()

 void NewFrame()

- 功能：
- 参数：
- 返回值：

---

### EndFrame()

 void EndFrame()

- 功能：
- 参数：
- 返回值：

---

### Render()

 void Render()

- 功能：
- 参数：
- 返回值：

---

### GetDrawData()

 ImDrawData* GetDrawData()

- 功能：
- 参数：
- 返回值：

---

### ShowDemoWindow()

 void ShowDemoWindow(bool* p_open = NULL)

- 功能：
- 参数：
- 返回值：

---

### ShowMetricsWindow()

 void ShowMetricsWindow(bool* p_open = NULL)

- 功能：
- 参数：
- 返回值：

---

### ShowDebugLogWindow()

 void ShowDebugLogWindow(bool* p_open = NULL)

- 功能：
- 参数：
- 返回值：

---

### ShowIDStackToolWindow()

 void ShowIDStackToolWindow(bool* p_open = NULL)

- 功能：
- 参数：
- 返回值：

---

### ShowAboutWindow()

 void ShowAboutWindow(bool* p_open = NULL)

- 功能：
- 参数：
- 返回值：

---

### ShowStyleEditor()

 void ShowStyleEditor(ImGuiStyle* ref = NULL)

- 功能：
- 参数：
- 返回值：

---

### ShowStyleSelector()

 bool ShowStyleSelector(const char* label)

- 功能：
- 参数：
- 返回值：

---

### ShowFontSelector()

 void ShowFontSelector(const char* label)

- 功能：
- 参数：
- 返回值：

---

### ShowUserGuide()

 void ShowUserGuide()

- 功能：
- 参数：
- 返回值：

---

### GetVersion()

 const char* GetVersion()

- 功能：
- 参数：
- 返回值：

---

### StyleColorsDark()

 void StyleColorsDark(ImGuiStyle* dst = NULL)

- 功能：
- 参数：
- 返回值：

---

### StyleColorsLight()

 void StyleColorsLight(ImGuiStyle* dst = NULL)

- 功能：
- 参数：
- 返回值：

---

### StyleColorsClassic()

 void StyleColorsClassic(ImGuiStyle* dst = NULL)

- 功能：
- 参数：
- 返回值：

---

### Begin()

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

### End()

 void End()

- 功能：
- 参数：
- 返回值：

---

### BeginChild()

 bool BeginChild(const char* str_id, const ImVec2& size = ImVec2(0, 0), ImGuiChildFlags child_flags = 0, ImGuiWindowFlags window_flags = 0)
 bool BeginChild(ImGuiID id, const ImVec2& size = ImVec2(0, 0), ImGuiChildFlags child_flags = 0, ImGuiWindowFlags window_flags = 0)

- 功能：
- 参数：
- 返回值：

---

### EndChild()

 void EndChild()

- 功能：
- 参数：
- 返回值：

---

### IsWindowAppearing()

 bool IsWindowAppearing()

- 功能：
- 参数：
- 返回值：

---

### IsWindowCollapsed()

 bool IsWindowCollapsed()

- 功能：
- 参数：
- 返回值：

---

### IsWindowFocused()

 bool IsWindowFocused(ImGuiFocusedFlags flags=0)

- 功能：
- 参数：
- 返回值：

---

### IsWindowHovered()

 bool IsWindowHovered(ImGuiHoveredFlags flags=0)

- 功能：
- 参数：
- 返回值：

---

### GetWindowDrawList()

 ImDrawList* GetWindowDrawList()

- 功能：
- 参数：
- 返回值：

---

### GetWindowPos()

 ImVec2 GetWindowPos()

- 功能：
- 参数：
- 返回值：

---

### GetWindowSize()

 ImVec2 GetWindowSize()

- 功能：
- 参数：
- 返回值：

---

### GetWindowWidth()

 float GetWindowWidth()

- 功能：
- 参数：
- 返回值：

---

### GetWindowHeight()

 float GetWindowHeight()

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowPos()

 void SetNextWindowPos(const ImVec2& pos, ImGuiCond cond = 0, const ImVec2& pivot = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowSize()

 void SetNextWindowSize(const ImVec2& size, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowSizeConstraints()

 void SetNextWindowSizeConstraints(const ImVec2& size_min, const ImVec2& size_max, ImGuiSizeCallback custom_callback = NULL, void* custom_callback_data = NULL)

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowContentSize()

 void SetNextWindowContentSize(const ImVec2& size)

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowCollapsed()

 void SetNextWindowCollapsed(bool collapsed, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowFocus()

 void SetNextWindowFocus()

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowScroll()

 void SetNextWindowScroll(const ImVec2& scroll)

- 功能：
- 参数：
- 返回值：

---

### SetNextWindowBgAlpha()

 void SetNextWindowBgAlpha(float alpha)

- 功能：
- 参数：
- 返回值：

---

### SetWindowPos()

 void SetWindowPos(const ImVec2& pos, ImGuiCond cond = 0)
 void SetWindowPos(const char* name, const ImVec2& pos, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### SetWindowSize()

 void SetWindowSize(const ImVec2& size, ImGuiCond cond = 0)
 void SetWindowSize(const char* name, const ImVec2& size, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### SetWindowCollapsed()

 void SetWindowCollapsed(bool collapsed, ImGuiCond cond = 0)
 void SetWindowCollapsed(const char* name, bool collapsed, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### SetWindowFocus()

 void SetWindowFocus()
 void SetWindowFocus(const char* name)

- 功能：
- 参数：
- 返回值：

---

### SetWindowFontScale()

 void SetWindowFontScale(float scale)

- 功能：
- 参数：
- 返回值：

---

### GetContentRegionAvail()

 ImVec2 GetContentRegionAvail()

- 功能：
- 参数：
- 返回值：

---

### GetContentRegionMax()

 ImVec2 GetContentRegionMax()

- 功能：
- 参数：
- 返回值：

---

### GetWindowContentRegionMin()

 ImVec2 GetWindowContentRegionMin()

- 功能：
- 参数：
- 返回值：

---

### GetWindowContentRegionMax()

 ImVec2 GetWindowContentRegionMax()

- 功能：
- 参数：
- 返回值：

---

### GetScrollX()

 float GetScrollX()

- 功能：
- 参数：
- 返回值：

---

### GetScrollY()

 float GetScrollY()

- 功能：
- 参数：
- 返回值：

---

### SetScrollX()

 void SetScrollX(float scroll_x)

- 功能：
- 参数：
- 返回值：

---

### SetScrollY()

 void SetScrollY(float scroll_y)

- 功能：
- 参数：
- 返回值：

---

### GetScrollMaxX()

 float GetScrollMaxX()

- 功能：
- 参数：
- 返回值：

---

### GetScrollMaxY()

 float GetScrollMaxY()

- 功能：
- 参数：
- 返回值：

---

### SetScrollHereX()

 void SetScrollHereX(float center_x_ratio = 0.5f)

- 功能：
- 参数：
- 返回值：

---

### SetScrollHereY()

 void SetScrollHereY(float center_y_ratio = 0.5f)

- 功能：
- 参数：
- 返回值：

---

### SetScrollFromPosX()

 void SetScrollFromPosX(float local_x, float center_x_ratio = 0.5f)

- 功能：
- 参数：
- 返回值：

---

### SetScrollFromPosY()

 void SetScrollFromPosY(float local_y, float center_y_ratio = 0.5f)

- 功能：
- 参数：
- 返回值：

---

### PushFont()

 void PushFont(ImFont* font)

- 功能：
- 参数：
- 返回值：

---

### PopFont()

 void PopFont()

- 功能：
- 参数：
- 返回值：

---

### PushStyleColor()

 void PushStyleColor(ImGuiCol idx, ImU32 col)
 void PushStyleColor(ImGuiCol idx, const ImVec4& col)

- 功能：
- 参数：
- 返回值：

---

### PopStyleColor()

 void PopStyleColor(int count = 1)

- 功能：
- 参数：
- 返回值：

---

### PushStyleVar()

 void PushStyleVar(ImGuiStyleVar idx, float val)
 void PushStyleVar(ImGuiStyleVar idx, const ImVec2& val)

- 功能：
- 参数：
- 返回值：

---

### PopStyleVar()

 void PopStyleVar(int count = 1)

- 功能：
- 参数：
- 返回值：

---

### PushTabStop()

 void PushTabStop(bool tab_stop)

- 功能：
- 参数：
- 返回值：

---

### PopTabStop()

 void PopTabStop()

- 功能：
- 参数：
- 返回值：

---

### PushButtonRepeat()

 void PushButtonRepeat(bool repeat)

- 功能：
- 参数：
- 返回值：

---

### PopButtonRepeat()

 void PopButtonRepeat()

- 功能：
- 参数：
- 返回值：

---

### PushItemWidth()

 void PushItemWidth(float item_width)

- 功能：
- 参数：
- 返回值：

---

### PopItemWidth()

 void PopItemWidth()

- 功能：
- 参数：
- 返回值：

---

### SetNextItemWidth()

 void SetNextItemWidth(float item_width)

- 功能：
- 参数：
- 返回值：

---

### CalcItemWidth()

 float CalcItemWidth()

- 功能：
- 参数：
- 返回值：

---

### PushTextWrapPos()

 void PushTextWrapPos(float wrap_local_pos_x = 0.0f)

- 功能：
- 参数：
- 返回值：

---

### PopTextWrapPos()

 void PopTextWrapPos()

- 功能：
- 参数：
- 返回值：

---

### GetFont()

 ImFont* GetFont()

- 功能：
- 参数：
- 返回值：

---

### GetFontSize()

 float GetFontSize()

- 功能：
- 参数：
- 返回值：

---

### GetFontTexUvWhitePixel()

 ImVec2 GetFontTexUvWhitePixel()

- 功能：
- 参数：
- 返回值：

---

### GetColorU32()

 ImU32 GetColorU32(ImGuiCol idx, float alpha_mul = 1.0f)
 ImU32 GetColorU32(const ImVec4& col)

 ImU32 GetColorU32(ImU32 col, float alpha_mul = 1.0f)

- 功能：
- 参数：
- 返回值：

---

### GetStyleColorVec4()

 const ImVec4& GetStyleColorVec4(ImGuiCol idx)

- 功能：
- 参数：
- 返回值：

---

### GetCursorScreenPos()

 ImVec2 GetCursorScreenPos()

- 功能：
- 参数：
- 返回值：

---

### SetCursorScreenPos()

 void SetCursorScreenPos(const ImVec2& pos)

- 功能：
- 参数：
- 返回值：

---

### GetCursorPos()

 ImVec2 GetCursorPos()

- 功能：
- 参数：
- 返回值：

---

### GetCursorPosX()

 float GetCursorPosX()

- 功能：
- 参数：
- 返回值：

---

### GetCursorPosY()

 float GetCursorPosY()

- 功能：
- 参数：
- 返回值：

---

### SetCursorPos()

 void SetCursorPos(const ImVec2& local_pos)

- 功能：
- 参数：
- 返回值：

---

### SetCursorPosX()

 void SetCursorPosX(float local_x)

- 功能：
- 参数：
- 返回值：

---

### SetCursorPosY()

 void SetCursorPosY(float local_y)

- 功能：
- 参数：
- 返回值：

---

### GetCursorStartPos()

 ImVec2 GetCursorStartPos()

- 功能：
- 参数：
- 返回值：

---

### Separator()

 void Separator()

- 功能：
- 参数：
- 返回值：

---

### SameLine()

 void SameLine(float offset_from_start_x=0.0f, float spacing=-1.0f)

- 功能：
- 参数：
- 返回值：

---

### NewLine()

 void NewLine()

- 功能：
- 参数：
- 返回值：

---

### Spacing()

 void Spacing()

- 功能：
- 参数：
- 返回值：

---

### Dummy()

 void Dummy(const ImVec2& size)

- 功能：
- 参数：
- 返回值：

---

### Indent()

 void Indent(float indent_w = 0.0f)

- 功能：
- 参数：
- 返回值：

---

### Unindent()

 void Unindent(float indent_w = 0.0f)

- 功能：
- 参数：
- 返回值：

---

### BeginGroup()

 void BeginGroup()

- 功能：
- 参数：
- 返回值：

---

### EndGroup()

 void EndGroup()

- 功能：
- 参数：
- 返回值：

---

### AlignTextToFramePadding()

 void AlignTextToFramePadding()

- 功能：
- 参数：
- 返回值：

---

### GetTextLineHeight()

 float GetTextLineHeight()

- 功能：
- 参数：
- 返回值：

---

### GetTextLineHeightWithSpacing()

 float GetTextLineHeightWithSpacing()

- 功能：
- 参数：
- 返回值：

---

### GetFrameHeight()

 float GetFrameHeight()

- 功能：
- 参数：
- 返回值：

---

### GetFrameHeightWithSpacing()

 float GetFrameHeightWithSpacing()

- 功能：
- 参数：
- 返回值：

---

### PushID()

 void PushID(const char* str_id)

 void PushID(const char*str_id_begin, const char* str_id_end)

 void PushID(const void* ptr_id)

 void PushID(int int_id)

- 功能：
- 参数：
- 返回值：

---

### PopID()

 void PopID()

- 功能：
- 参数：
- 返回值：

---

### GetID()

 ImGuiID GetID(const char*str_id)
 ImGuiID GetID(const char*str_id_begin, const char\* str_id_end)
 ImGuiID GetID(const void* ptr_id)

- 功能：
- 参数：
- 返回值：

---

### TextUnformatted()

 void TextUnformatted(const char*text, const char* text_end = NULL)

- 功能：
- 参数：
- 返回值：

---

### Text()

 void Text(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### TextV()

 void TextV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### TextColored()

 void TextColored(const ImVec4& col, const char* fmt, ...) IM_FMTARGS(2)

- 功能：
- 参数：
- 返回值：

---

### TextColoredV()

 void TextColoredV(const ImVec4& col, const char* fmt, va_list args) IM_FMTLIST(2)

- 功能：
- 参数：
- 返回值：

---

### TextDisabled()

 void TextDisabled(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### TextDisabledV()

 void TextDisabledV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### TextWrapped()

 void TextWrapped(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### TextWrappedV()

 void TextWrappedV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### LabelText()

 void LabelText(const char*label, const char* fmt, ...) IM_FMTARGS(2)

- 功能：
- 参数：
- 返回值：

---

### LabelTextV()

 void LabelTextV(const char*label, const char* fmt, va_list args) IM_FMTLIST(2)

- 功能：
- 参数：
- 返回值：

---

### BulletText()

 void BulletText(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### BulletTextV()

 void BulletTextV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### SeparatorText()

 void SeparatorText(const char* label)

- 功能：
- 参数：
- 返回值：

---

### Button()

 bool Button(const char* label, const ImVec2& size = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### SmallButton()

 bool SmallButton(const char* label)

- 功能：
- 参数：
- 返回值：

---

### InvisibleButton()

 bool InvisibleButton(const char* str_id, const ImVec2& size, ImGuiButtonFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### ArrowButton()

boolean ArrowButton(string str_id,[ImGuiDir](#imguidir) dir)

- 功能：箭头按钮
- 参数：
  - `str_id`：控件的id
  - `dir`：箭头的方向

- 返回值：按钮被点击时，返回`true`

---

### Checkbox()

 bool Checkbox(const char*label, bool* v)

- 功能：
- 参数：
- 返回值：

---

### CheckboxFlags()

 bool CheckboxFlags(const char*label, int* flags, int flags_value)

 bool CheckboxFlags(const char*label, unsigned int* flags, unsigned int flags_value)

- 功能：
- 参数：
- 返回值：

---

### RadioButton()

 bool RadioButton(const char* label, bool active)
 bool RadioButton(const char*label, int* v, int v_button)

- 功能：
- 参数：
- 返回值：

---

### ProgressBar()

 void ProgressBar(float fraction, const ImVec2& size_arg = ImVec2(-FLT_MIN, 0), const char* overlay = NULL)

- 功能：
- 参数：
- 返回值：

---

### Bullet()

 void Bullet()

- 功能：
- 参数：
- 返回值：

---

### Image()

 void Image(ImTextureID user_texture_id, const ImVec2& image_size, const ImVec2& uv0 = ImVec2(0, 0), const ImVec2& uv1 = ImVec2(1, 1), const ImVec4& tint_col = ImVec4(1, 1, 1, 1), const ImVec4& border_col = ImVec4(0, 0, 0, 0))

- 功能：
- 参数：
- 返回值：

---

### ImageButton()

 bool ImageButton(const char* str_id, ImTextureID user_texture_id, const ImVec2& image_size, const ImVec2& uv0 = ImVec2(0, 0), const ImVec2& uv1 = ImVec2(1, 1), const ImVec4& bg_col = ImVec4(0, 0, 0, 0), const ImVec4& tint_col = ImVec4(1, 1, 1, 1))

- 功能：
- 参数：
- 返回值：

---

### BeginCombo()

boolean BeginCombo(string label,string preview_value,[ImGuiComboFlags](#imguicomboflags) flags = 0)

- 功能：开始一个组合框
- 参数：
  - `label`：控件的id
  - `preview_value`：组合框上显示的文本
  - `flags`：组合框的设置标志

- 返回值：
  - 选择框被展开时返回`true`

---

### EndCombo()

 void EndCombo()

- 功能：
- 参数：
- 返回值：

---

### Combo()

 bool Combo(const char*label, int* current_item, const char*const items[], int items_count, int popup_max_height_in_items = -1)
 bool Combo(const char*label, int\* current_item, const char\* items_separated_by_zeros, int popup_max_height_in_items = -1)
 bool Combo(const char*label, int* current_item, const char*(*getter)(void* user_data, int idx), void* user_data, int items_count, int popup_max_height_in_items = -1)

- 功能：
- 参数：
- 返回值：

---

### DragFloat()

 bool DragFloat(const char*label, float* v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragFloat2()

 bool DragFloat2(const char*label, float v[2], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragFloat3()

 bool DragFloat3(const char*label, float v[3], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragFloat4()

 bool DragFloat4(const char*label, float v[4], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragFloatRange2()

 bool DragFloatRange2(const char*label, float* v_current_min, float*v_current_max, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", const char* format_max = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragInt()

 bool DragInt(const char*label, int* v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragInt2()

 bool DragInt2(const char*label, int v[2], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragInt3()

 bool DragInt3(const char*label, int v[3], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragInt4()

 bool DragInt4(const char*label, int v[4], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragIntRange2()

 bool DragIntRange2(const char*label, int* v_current_min, int*v_current_max, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", const char* format_max = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragScalar()

 bool DragScalar(const char*label, ImGuiDataType data_type, void* p_data, float v_speed = 1.0f, const void*p_min = NULL, const void* p_max = NULL, const char* format = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### DragScalarN()

 bool DragScalarN(const char*label, ImGuiDataType data_type, void* p_data, int components, float v_speed = 1.0f, const void*p_min = NULL, const void* p_max = NULL, const char* format = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderFloat()

 bool SliderFloat(const char*label, float* v, float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderFloat2()

 bool SliderFloat2(const char*label, float v[2], float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderFloat3()

 bool SliderFloat3(const char*label, float v[3], float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderFloat4()

 bool SliderFloat4(const char*label, float v[4], float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderAngle()

 bool SliderAngle(const char*label, float* v_rad, float v_degrees_min = -360.0f, float v_degrees_max = +360.0f, const char* format = "%.0f deg", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderInt()

 bool SliderInt(const char*label, int* v, int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderInt2()

 bool SliderInt2(const char*label, int v[2], int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderInt3()

 bool SliderInt3(const char*label, int v[3], int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderInt4()

 bool SliderInt4(const char*label, int v[4], int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderScalar()

 bool SliderScalar(const char*label, ImGuiDataType data_type, void* p_data, const void*p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SliderScalarN()

 bool SliderScalarN(const char*label, ImGuiDataType data_type, void* p_data, int components, const void*p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### VSliderFloat()

 bool VSliderFloat(const char*label, const ImVec2& size, float* v, float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### VSliderInt()

 bool VSliderInt(const char*label, const ImVec2& size, int* v, int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### VSliderScalar()

 bool VSliderScalar(const char*label, const ImVec2& size, ImGuiDataType data_type, void* p_data, const void*p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputText()

 bool InputText(const char*label, char* buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiInputTextCallback callback = NULL, void* user_data = NULL)

- 功能：
- 参数：
- 返回值：

---

### InputTextMultiline()

 bool InputTextMultiline(const char*label, char* buf, size_t buf_size, const ImVec2& size = ImVec2(0, 0), ImGuiInputTextFlags flags = 0, ImGuiInputTextCallback callback = NULL, void* user_data = NULL)

- 功能：
- 参数：
- 返回值：

---

### InputTextWithHint()

 bool InputTextWithHint(const char*label, const char* hint, char*buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiInputTextCallback callback = NULL, void* user_data = NULL)

- 功能：
- 参数：
- 返回值：

---

### InputFloat()

 bool InputFloat(const char*label, float* v, float step = 0.0f, float step_fast = 0.0f, const char* format = "%.3f", ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputFloat2()

 bool InputFloat2(const char*label, float v[2], const char* format = "%.3f", ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputFloat3()

 bool InputFloat3(const char*label, float v[3], const char* format = "%.3f", ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputFloat4()

 bool InputFloat4(const char*label, float v[4], const char* format = "%.3f", ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputInt()

 bool InputInt(const char*label, int* v, int step = 1, int step_fast = 100, ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputInt2()

 bool InputInt2(const char* label, int v[2], ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputInt3()

 bool InputInt3(const char* label, int v[3], ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputInt4()

 bool InputInt4(const char* label, int v[4], ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputDouble()

 bool InputDouble(const char*label, double* v, double step = 0.0, double step_fast = 0.0, const char* format = "%.6f", ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputScalar()

 bool InputScalar(const char*label, ImGuiDataType data_type, void* p_data, const void*p_step = NULL, const void* p_step_fast = NULL, const char* format = NULL, ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### InputScalarN()

 bool InputScalarN(const char*label, ImGuiDataType data_type, void* p_data, int components, const void*p_step = NULL, const void* p_step_fast = NULL, const char* format = NULL, ImGuiInputTextFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### ColorEdit3()

 bool ColorEdit3(const char* label, float col[3], ImGuiColorEditFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### ColorEdit4()

 bool ColorEdit4(const char* label, float col[4], ImGuiColorEditFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### ColorPicker3()

 bool ColorPicker3(const char* label, float col[3], ImGuiColorEditFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### ColorPicker4()

 bool ColorPicker4(const char*label, float col[4], ImGuiColorEditFlags flags = 0, const float* ref_col = NULL)

- 功能：
- 参数：
- 返回值：

---

### ColorButton()

 bool ColorButton(const char* desc_id, const ImVec4& col, ImGuiColorEditFlags flags = 0, const ImVec2& size = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### SetColorEditOptions()

 void SetColorEditOptions(ImGuiColorEditFlags flags)

- 功能：
- 参数：
- 返回值：

---

### TreeNode()

 bool TreeNode(const char* label)

 bool TreeNode(const char*str_id, const char* fmt, ...) IM_FMTARGS(2)

 bool TreeNode(const void*ptr_id, const char* fmt, ...) IM_FMTARGS(2)

- 功能：
- 参数：
- 返回值：

---

### TreeNodeV()

 bool TreeNodeV(const char*str_id, const char* fmt, va_list args) IM_FMTLIST(2)

 bool TreeNodeV(const void*ptr_id, const char* fmt, va_list args) IM_FMTLIST(2)

- 功能：
- 参数：
- 返回值：

---

### TreeNodeEx()

 bool TreeNodeEx(const char* label, ImGuiTreeNodeFlags flags = 0)

 bool TreeNodeEx(const char*str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_FMTARGS(3)

 bool TreeNodeEx(const void*ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_FMTARGS(3)

- 功能：
- 参数：
- 返回值：

---

### TreeNodeExV()

 bool TreeNodeExV(const char*str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) IM_FMTLIST(3)
 bool TreeNodeExV(const void*ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) IM_FMTLIST(3)

- 功能：
- 参数：
- 返回值：

---

### TreePush()

 void TreePush(const char*str_id)
 void TreePush(const void* ptr_id)

- 功能：
- 参数：
- 返回值：

---

### TreePop()

 void TreePop()

- 功能：
- 参数：
- 返回值：

---

### GetTreeNodeToLabelSpacing()

 float GetTreeNodeToLabelSpacing()

- 功能：
- 参数：
- 返回值：

---

### CollapsingHeader()

 bool CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0)

 bool CollapsingHeader(const char*label, bool* p_visible, ImGuiTreeNodeFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SetNextItemOpen()

 void SetNextItemOpen(bool is_open, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### Selectable()

 bool Selectable(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0))
 bool Selectable(const char*label, bool* p_selected, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### BeginListBox()

 bool BeginListBox(const char* label, const ImVec2& size = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### EndListBox()

 void EndListBox()

- 功能：
- 参数：
- 返回值：

---

### ListBox()

 bool ListBox(const char*label, int* current_item, const char* const items[], int items_count, int height_in_items = -1)

 bool ListBox(const char*label, int* current_item, const char*(*getter)(void* user_data, int idx), void* user_data, int items_count, int height_in_items = -1)

- 功能：
- 参数：
- 返回值：

---

### PlotLines()

 void PlotLines(const char*label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0), int stride = sizeof(float))

 void PlotLines(const char*label, float(*values_getter)(void* data, int idx), void* data, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### PlotHistogram()

 void PlotHistogram(const char*label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0), int stride = sizeof(float))

 void PlotHistogram(const char*label, float (*values_getter)(void* data, int idx), void* data, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0))

- 功能：
- 参数：
- 返回值：

---

### Value()

 void Value(const char* prefix, bool b)
 void Value(const char*prefix, int v)
 void Value(const char* prefix, unsigned int v)
 void Value(const char*prefix, float v, const char* float_format = NULL)

- 功能：
- 参数：
- 返回值：

---

### BeginMenuBar()

 bool BeginMenuBar()

- 功能：
- 参数：
- 返回值：

---

### EndMenuBar()

 void EndMenuBar()

- 功能：
- 参数：
- 返回值：

---

### BeginMainMenuBar()

 bool BeginMainMenuBar()

- 功能：
- 参数：
- 返回值：

---

### EndMainMenuBar()

 void EndMainMenuBar()

- 功能：
- 参数：
- 返回值：

---

### BeginMenu()

 bool BeginMenu(const char* label, bool enabled = true)

- 功能：
- 参数：
- 返回值：

---

### EndMenu()

 void EndMenu()

- 功能：
- 参数：
- 返回值：

---

### MenuItem()

 bool MenuItem(const char*label, const char* shortcut = NULL, bool selected = false, bool enabled = true)

 bool MenuItem(const char*label, const char* shortcut, bool* p_selected, bool enabled = true)

- 功能：
- 参数：
- 返回值：

---

### BeginTooltip()

 bool BeginTooltip()

- 功能：
- 参数：
- 返回值：

---

### EndTooltip()

 void EndTooltip()

- 功能：
- 参数：
- 返回值：

---

### SetTooltip()

 void SetTooltip(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### SetTooltipV()

 void SetTooltipV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### BeginItemTooltip()

 bool BeginItemTooltip()

- 功能：
- 参数：
- 返回值：

---

### SetItemTooltip()

 void SetItemTooltip(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### SetItemTooltipV()

 void SetItemTooltipV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### BeginPopup()

 bool BeginPopup(const char* str_id, ImGuiWindowFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### BeginPopupModal()

 bool BeginPopupModal(const char*name, bool* p_open = NULL, ImGuiWindowFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### EndPopup()

 void EndPopup()

- 功能：
- 参数：
- 返回值：

---

### OpenPopup()

 void OpenPopup(const char* str_id, ImGuiPopupFlags popup_flags = 0)

 void OpenPopup(ImGuiID id, ImGuiPopupFlags popup_flags = 0)

- 功能：
- 参数：
- 返回值：

---

### OpenPopupOnItemClick()

 void OpenPopupOnItemClick(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)

- 功能：
- 参数：
- 返回值：

---

### CloseCurrentPopup()

 void CloseCurrentPopup()

- 功能：
- 参数：
- 返回值：

---

### BeginPopupContextItem()

 bool BeginPopupContextItem(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)

- 功能：
- 参数：
- 返回值：

---

### BeginPopupContextWindow()

 bool BeginPopupContextWindow(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)

- 功能：
- 参数：
- 返回值：

---

### BeginPopupContextVoid()

 bool BeginPopupContextVoid(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)

- 功能：
- 参数：
- 返回值：

---

### IsPopupOpen()

 bool IsPopupOpen(const char* str_id, ImGuiPopupFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### BeginTable()

 bool BeginTable(const char* str_id, int column, ImGuiTableFlags flags = 0, const ImVec2& outer_size = ImVec2(0.0f, 0.0f), float inner_width = 0.0f)

- 功能：
- 参数：
- 返回值：

---

### EndTable()

 void EndTable()

- 功能：
- 参数：
- 返回值：

---

### TableNextRow()

 void TableNextRow(ImGuiTableRowFlags row_flags = 0, float min_row_height = 0.0f)

- 功能：
- 参数：
- 返回值：

---

### TableNextColumn()

 bool TableNextColumn()

- 功能：
- 参数：
- 返回值：

---

### TableSetColumnIndex()

 bool TableSetColumnIndex(int column_n)

- 功能：
- 参数：
- 返回值：

---

### TableSetupColumn()

 void TableSetupColumn(const char* label, ImGuiTableColumnFlags flags = 0, float init_width_or_weight = 0.0f, ImGuiID user_id = 0)

- 功能：
- 参数：
- 返回值：

---

### TableSetupScrollFreeze()

 void TableSetupScrollFreeze(int cols, int rows)

- 功能：
- 参数：
- 返回值：

---

### TableHeader()

 void TableHeader(const char* label)

- 功能：
- 参数：
- 返回值：

---

### TableHeadersRow()

 void TableHeadersRow()

- 功能：
- 参数：
- 返回值：

---

### TableAngledHeadersRow()

 void TableAngledHeadersRow()

- 功能：
- 参数：
- 返回值：

---

### TableGetSortSpecs()

 ImGuiTableSortSpecs* TableGetSortSpecs()

- 功能：
- 参数：
- 返回值：

---

### TableGetColumnCount()

 int TableGetColumnCount()

- 功能：
- 参数：
- 返回值：

---

### TableGetColumnIndex()

 int TableGetColumnIndex()

- 功能：
- 参数：
- 返回值：

---

### TableGetRowIndex()

 int TableGetRowIndex()

- 功能：
- 参数：
- 返回值：

---

### TableGetColumnName()

 const char* TableGetColumnName(int column_n = -1)

- 功能：
- 参数：
- 返回值：

---

### TableGetColumnFlags()

 ImGuiTableColumnFlags TableGetColumnFlags(int column_n = -1)

- 功能：
- 参数：
- 返回值：

---

### TableSetColumnEnabled()

 void TableSetColumnEnabled(int column_n, bool v)

- 功能：
- 参数：
- 返回值：

---

### TableSetBgColor()

 void TableSetBgColor(ImGuiTableBgTarget target, ImU32 color, int column_n = -1)

- 功能：
- 参数：
- 返回值：

---

### Columns()

 void Columns(int count = 1, const char* id = NULL, bool border = true)

- 功能：
- 参数：
- 返回值：

---

### NextColumn()

 void NextColumn()

- 功能：
- 参数：
- 返回值：

---

### GetColumnIndex()

 int GetColumnIndex()

- 功能：
- 参数：
- 返回值：

---

### GetColumnWidth()

 float GetColumnWidth(int column_index = -1)

- 功能：
- 参数：
- 返回值：

---

### SetColumnWidth()

 void SetColumnWidth(int column_index, float width)

- 功能：
- 参数：
- 返回值：

---

### GetColumnOffset()

 float GetColumnOffset(int column_index = -1)

- 功能：
- 参数：
- 返回值：

---

### SetColumnOffset()

 void SetColumnOffset(int column_index, float offset_x)

- 功能：
- 参数：
- 返回值：

---

### GetColumnsCount()

 int GetColumnsCount()

- 功能：
- 参数：
- 返回值：

---

### BeginTabBar()

 bool BeginTabBar(const char* str_id, ImGuiTabBarFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### EndTabBar()

 void EndTabBar()

- 功能：
- 参数：
- 返回值：

---

### BeginTabItem()

 bool BeginTabItem(const char*label, bool* p_open = NULL, ImGuiTabItemFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### EndTabItem()

 void EndTabItem()

- 功能：
- 参数：
- 返回值：

---

### TabItemButton()

 bool TabItemButton(const char* label, ImGuiTabItemFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SetTabItemClosed()

 void SetTabItemClosed(const char* tab_or_docked_window_label)

- 功能：
- 参数：
- 返回值：

---

### LogToTTY()

 void LogToTTY(int auto_open_depth = -1)

- 功能：
- 参数：
- 返回值：

---

### LogToFile()

 void LogToFile(int auto_open_depth = -1, const char* filename = NULL)

- 功能：
- 参数：
- 返回值：

---

### LogToClipboard()

 void LogToClipboard(int auto_open_depth = -1)

- 功能：
- 参数：
- 返回值：

---

### LogFinish()

 void LogFinish()

- 功能：
- 参数：
- 返回值：

---

### LogButtons()

 void LogButtons()

- 功能：
- 参数：
- 返回值：

---

### LogText()

 void LogText(const char* fmt, ...) IM_FMTARGS(1)

- 功能：
- 参数：
- 返回值：

---

### LogTextV()

 void LogTextV(const char* fmt, va_list args) IM_FMTLIST(1)

- 功能：
- 参数：
- 返回值：

---

### BeginDragDropSource()

 bool BeginDragDropSource(ImGuiDragDropFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### SetDragDropPayload()

 bool SetDragDropPayload(const char*type, const void* data, size_t sz, ImGuiCond cond = 0)

- 功能：
- 参数：
- 返回值：

---

### EndDragDropSource()

 void EndDragDropSource()

- 功能：
- 参数：
- 返回值：

---

### BeginDragDropTarget()

 bool BeginDragDropTarget()

- 功能：
- 参数：
- 返回值：

---

### AcceptDragDropPayload()

 const ImGuiPayload*AcceptDragDropPayload(const char* type, ImGuiDragDropFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### EndDragDropTarget()

 void EndDragDropTarget()

- 功能：
- 参数：
- 返回值：

---

### GetDragDropPayload()

 const ImGuiPayload* GetDragDropPayload()

- 功能：
- 参数：
- 返回值：

---

### BeginDisabled()

 void BeginDisabled(bool disabled = true)

- 功能：
- 参数：
- 返回值：

---

### EndDisabled()

 void EndDisabled()

- 功能：
- 参数：
- 返回值：

---

### PushClipRect()

 void PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect)

- 功能：
- 参数：
- 返回值：

---

### PopClipRect()

 void PopClipRect()

- 功能：
- 参数：
- 返回值：

---

### SetItemDefaultFocus()

 void SetItemDefaultFocus()

- 功能：
- 参数：
- 返回值：

---

### SetKeyboardFocusHere()

 void SetKeyboardFocusHere(int offset = 0)

- 功能：
- 参数：
- 返回值：

---

### SetNextItemAllowOverlap()

 void SetNextItemAllowOverlap()

- 功能：
- 参数：
- 返回值：

---

### IsItemHovered()

 bool IsItemHovered(ImGuiHoveredFlags flags = 0)

- 功能：
- 参数：
- 返回值：

---

### IsItemActive()

 bool IsItemActive()

- 功能：
- 参数：
- 返回值：

---

### IsItemFocused()

 bool IsItemFocused()

- 功能：
- 参数：
- 返回值：

---

### IsItemClicked()

 bool IsItemClicked(ImGuiMouseButton mouse_button = 0)

- 功能：
- 参数：
- 返回值：

---

### IsItemVisible()

 bool IsItemVisible()

- 功能：
- 参数：
- 返回值：

---

### IsItemEdited()

 bool IsItemEdited()

- 功能：
- 参数：
- 返回值：

---

### IsItemActivated()

 bool IsItemActivated()

- 功能：
- 参数：
- 返回值：

---

### IsItemDeactivated()

 bool IsItemDeactivated()

- 功能：
- 参数：
- 返回值：

---

### IsItemDeactivatedAfterEdit()

 bool IsItemDeactivatedAfterEdit()

- 功能：
- 参数：
- 返回值：

---

### IsItemToggledOpen()

 bool IsItemToggledOpen()

- 功能：
- 参数：
- 返回值：

---

### IsAnyItemHovered()

 bool IsAnyItemHovered()

- 功能：
- 参数：
- 返回值：

---

### IsAnyItemActive()

 bool IsAnyItemActive()

- 功能：
- 参数：
- 返回值：

---

### IsAnyItemFocused()

 bool IsAnyItemFocused()

- 功能：
- 参数：
- 返回值：

---

### GetItemID()

 ImGuiID GetItemID()

- 功能：
- 参数：
- 返回值：

---

### GetItemRectMin()

 ImVec2 GetItemRectMin()

- 功能：
- 参数：
- 返回值：

---

### GetItemRectMax()

 ImVec2 GetItemRectMax()

- 功能：
- 参数：
- 返回值：

---

### GetItemRectSize()

 ImVec2 GetItemRectSize()

- 功能：
- 参数：
- 返回值：

---

### GetMainViewport()

 ImGuiViewport* GetMainViewport()

- 功能：
- 参数：
- 返回值：

---

### GetBackgroundDrawList()

 ImDrawList* GetBackgroundDrawList()

- 功能：
- 参数：
- 返回值：

---

### GetForegroundDrawList()

 ImDrawList* GetForegroundDrawList()

- 功能：
- 参数：
- 返回值：

---

### IsRectVisible()

 bool IsRectVisible(const ImVec2& size)

 bool IsRectVisible(const ImVec2& rect_min, const ImVec2& rect_max)

- 功能：
- 参数：
- 返回值：

---

### GetTime()

 double GetTime()

- 功能：
- 参数：
- 返回值：

---

### GetFrameCount()

 int GetFrameCount()

- 功能：
- 参数：
- 返回值：

---

### GetDrawListSharedData()

 ImDrawListSharedData* GetDrawListSharedData()

- 功能：
- 参数：
- 返回值：

---

### GetStyleColorName()

 const char* GetStyleColorName(ImGuiCol idx)

- 功能：
- 参数：
- 返回值：

---

### SetStateStorage()

 void SetStateStorage(ImGuiStorage* storage)

- 功能：
- 参数：
- 返回值：

---

### GetStateStorage()

 ImGuiStorage* GetStateStorage()

- 功能：
- 参数：
- 返回值：

---

### CalcTextSize()

 ImVec2 CalcTextSize(const char*text, const char* text_end = NULL, bool hide_text_after_double_hash = false, float wrap_width = -1.0f)

- 功能：
- 参数：
- 返回值：

---

### ColorConvertU32ToFloat4()

 ImVec4 ColorConvertU32ToFloat4(ImU32 in)

- 功能：
- 参数：
- 返回值：

---

### ColorConvertFloat4ToU32()

 ImU32 ColorConvertFloat4ToU32(const ImVec4& in)

- 功能：
- 参数：
- 返回值：

---

### ColorConvertRGBtoHSV()

 void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v)

- 功能：
- 参数：
- 返回值：

---

### ColorConvertHSVtoRGB()

 void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b)

- 功能：
- 参数：
- 返回值：

---

### IsKeyDown()

 bool IsKeyDown(ImGuiKey key)

- 功能：
- 参数：
- 返回值：

---

### IsKeyPressed()

 bool IsKeyPressed(ImGuiKey key, bool repeat = true)

- 功能：
- 参数：
- 返回值：

---

### IsKeyReleased()

 bool IsKeyReleased(ImGuiKey key)

- 功能：
- 参数：
- 返回值：

---

### IsKeyChordPressed()

 bool IsKeyChordPressed(ImGuiKeyChord key_chord)

- 功能：
- 参数：
- 返回值：

---

### GetKeyPressedAmount()

 int GetKeyPressedAmount(ImGuiKey key, float repeat_delay, float rate)

- 功能：
- 参数：
- 返回值：

---

### GetKeyName()

 const char* GetKeyName(ImGuiKey key)

- 功能：
- 参数：
- 返回值：

---

### SetNextFrameWantCaptureKeyboard()

 void SetNextFrameWantCaptureKeyboard(bool want_capture_keyboard)

- 功能：
- 参数：
- 返回值：

---

### IsMouseDown()

 bool IsMouseDown(ImGuiMouseButton button)

- 功能：
- 参数：
- 返回值：

---

### IsMouseClicked()

 bool IsMouseClicked(ImGuiMouseButton button, bool repeat = false)

- 功能：
- 参数：
- 返回值：

---

### IsMouseReleased()

 bool IsMouseReleased(ImGuiMouseButton button)

- 功能：
- 参数：
- 返回值：

---

### IsMouseDoubleClicked()

 bool IsMouseDoubleClicked(ImGuiMouseButton button)

- 功能：
- 参数：
- 返回值：

---

### GetMouseClickedCount()

 int GetMouseClickedCount(ImGuiMouseButton button)

- 功能：
- 参数：
- 返回值：

---

### IsMouseHoveringRect()

 bool IsMouseHoveringRect(const ImVec2& r_min, const ImVec2& r_max, bool clip = true)

- 功能：
- 参数：
- 返回值：

---

### IsMousePosValid()

 bool IsMousePosValid(const ImVec2* mouse_pos = NULL)

- 功能：
- 参数：
- 返回值：

---

### IsAnyMouseDown()

 bool IsAnyMouseDown()

- 功能：
- 参数：
- 返回值：

---

### GetMousePos()

 ImVec2 GetMousePos()

- 功能：
- 参数：
- 返回值：

---

### GetMousePosOnOpeningCurrentPopup()

 ImVec2 GetMousePosOnOpeningCurrentPopup()

- 功能：
- 参数：
- 返回值：

---

### IsMouseDragging()

 bool IsMouseDragging(ImGuiMouseButton button, float lock_threshold = -1.0f)

- 功能：
- 参数：
- 返回值：

---

### GetMouseDragDelta()

 ImVec2 GetMouseDragDelta(ImGuiMouseButton button = 0, float lock_threshold = -1.0f)

- 功能：
- 参数：
- 返回值：

---

### ResetMouseDragDelta()

 void ResetMouseDragDelta(ImGuiMouseButton button = 0)

- 功能：
- 参数：
- 返回值：

---

### ImGuiMouseCursor()

 ImGuiMouseCursor GetMouseCursor()

- 功能：
- 参数：
- 返回值：

---

### SetMouseCursor()

 void SetMouseCursor(ImGuiMouseCursor cursor_type)

- 功能：
- 参数：
- 返回值：

---

### SetNextFrameWantCaptureMouse()

 void SetNextFrameWantCaptureMouse(bool want_capture_mouse)

- 功能：
- 参数：
- 返回值：

---

### GetClipboardText()

 const char* GetClipboardText()

- 功能：
- 参数：
- 返回值：

---

### SetClipboardText()

 void SetClipboardText(const char* text)

- 功能：
- 参数：
- 返回值：

---

### LoadIniSettingsFromDisk()

 void LoadIniSettingsFromDisk(const char* ini_filename)

- 功能：
- 参数：
- 返回值：

---

### LoadIniSettingsFromMemory()

 void LoadIniSettingsFromMemory(const char* ini_data, size_t ini_size=0)

- 功能：
- 参数：
- 返回值：

---

### SaveIniSettingsToDisk()

 void SaveIniSettingsToDisk(const char* ini_filename)

- 功能：
- 参数：
- 返回值：

---

### SaveIniSettingsToMemory()

 const char*SaveIniSettingsToMemory(size_t* out_ini_size = NULL)

- 功能：
- 参数：
- 返回值：

---

### DebugTextEncoding()

 void DebugTextEncoding(const char* text)

- 功能：
- 参数：
- 返回值：

---

### DebugFlashStyleColor()

 void DebugFlashStyleColor(ImGuiCol idx)

- 功能：
- 参数：
- 返回值：

---

### DebugStartItemPicker()

 void DebugStartItemPicker()

- 功能：
- 参数：
- 返回值：

---

### DebugCheckVersionAndDataLayout()

 bool DebugCheckVersionAndDataLayout(const char* version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert, size_t sz_drawidx)

- 功能：
- 参数：
- 返回值：

---

### SetAllocatorFunctions()

 void SetAllocatorFunctions(ImGuiMemAllocFunc alloc_func, ImGuiMemFreeFunc free_func, void* user_data = NULL)

- 功能：
- 参数：
- 返回值：

---

### GetAllocatorFunctions()

 void GetAllocatorFunctions(ImGuiMemAllocFunc*p_alloc_func, ImGuiMemFreeFunc* p_free_func, void** p_user_data)

- 功能：
- 参数：
- 返回值：

---

### MemAlloc()

 void* MemAlloc(size_t size)

- 功能：
- 参数：
- 返回值：

---

### MemFree()

 void MemFree(void* ptr)

- 功能：
- 参数：
- 返回值：

---
