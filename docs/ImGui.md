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
  - [官方文档](#官方文档)
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

## 官方文档

```c++
namespace ImGui
{
    // Context creation and access
    // - Each context create its own ImFontAtlas by default. You may instance one yourself and pass it to CreateContext() to share a font atlas between contexts.
    // - DLL users: heaps and globals are not shared across DLL boundaries! You will need to call SetCurrentContext() + SetAllocatorFunctions()
    //   for each static/DLL boundary you are calling from. Read "Context and Memory Allocators" section of imgui.cpp for details.
    IMGUI_API ImGuiContext* CreateContext(ImFontAtlas* shared_font_atlas = NULL);
    IMGUI_API void          DestroyContext(ImGuiContext* ctx = NULL);   // NULL = destroy current context
    IMGUI_API ImGuiContext* GetCurrentContext();
    IMGUI_API void          SetCurrentContext(ImGuiContext* ctx);

    // Main
    IMGUI_API ImGuiIO&      GetIO();                                    // access the IO structure (mouse/keyboard/gamepad inputs, time, various configuration options/flags)
    IMGUI_API ImGuiStyle&   GetStyle();                                 // access the Style structure (colors, sizes). Always use PushStyleColor(), PushStyleVar() to modify style mid-frame!
    IMGUI_API void          NewFrame();                                 // start a new Dear ImGui frame, you can submit any command from this point until Render()/EndFrame().
    IMGUI_API void          EndFrame();                                 // ends the Dear ImGui frame. automatically called by Render(). If you don't need to render data (skipping rendering) you may call EndFrame() without Render()... but you'll have wasted CPU already! If you don't need to render, better to not create any windows and not call NewFrame() at all!
    IMGUI_API void          Render();                                   // ends the Dear ImGui frame, finalize the draw data. You can then get call GetDrawData().
    IMGUI_API ImDrawData*   GetDrawData();                              // valid after Render() and until the next call to NewFrame(). this is what you have to render.

    // Demo, Debug, Information
    IMGUI_API void          ShowDemoWindow(bool* p_open = NULL);        // create Demo window. demonstrate most ImGui features. call this to learn about the library! try to make it always available in your application!
    IMGUI_API void          ShowMetricsWindow(bool* p_open = NULL);     // create Metrics/Debugger window. display Dear ImGui internals: windows, draw commands, various internal state, etc.
    IMGUI_API void          ShowDebugLogWindow(bool* p_open = NULL);    // create Debug Log window. display a simplified log of important dear imgui events.
    IMGUI_API void          ShowIDStackToolWindow(bool* p_open = NULL); // create Stack Tool window. hover items with mouse to query information about the source of their unique ID.
    IMGUI_API void          ShowAboutWindow(bool* p_open = NULL);       // create About window. display Dear ImGui version, credits and build/system information.
    IMGUI_API void          ShowStyleEditor(ImGuiStyle* ref = NULL);    // add style editor block (not a window). you can pass in a reference ImGuiStyle structure to compare to, revert to and save to (else it uses the default style)
    IMGUI_API bool          ShowStyleSelector(const char* label);       // add style selector block (not a window), essentially a combo listing the default styles.
    IMGUI_API void          ShowFontSelector(const char* label);        // add font selector block (not a window), essentially a combo listing the loaded fonts.
    IMGUI_API void          ShowUserGuide();                            // add basic help/info block (not a window): how to manipulate ImGui as an end-user (mouse/keyboard controls).
    IMGUI_API const char*   GetVersion();                               // get the compiled version string e.g. "1.80 WIP" (essentially the value for IMGUI_VERSION from the compiled version of imgui.cpp)

    // Styles
    IMGUI_API void          StyleColorsDark(ImGuiStyle* dst = NULL);    // new, recommended style (default)
    IMGUI_API void          StyleColorsLight(ImGuiStyle* dst = NULL);   // best used with borders and a custom, thicker font
    IMGUI_API void          StyleColorsClassic(ImGuiStyle* dst = NULL); // classic imgui style

    // Windows
    // - Begin() = push window to the stack and start appending to it. End() = pop window from the stack.
    // - Passing 'bool* p_open != NULL' shows a window-closing widget in the upper-right corner of the window,
    //   which clicking will set the boolean to false when clicked.
    // - You may append multiple times to the same window during the same frame by calling Begin()/End() pairs multiple times.
    //   Some information such as 'flags' or 'p_open' will only be considered by the first call to Begin().
    // - Begin() return false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
    //   anything to the window. Always call a matching End() for each Begin() call, regardless of its return value!
    //   [Important: due to legacy reason, Begin/End and BeginChild/EndChild are inconsistent with all other functions
    //    such as BeginMenu/EndMenu, BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding
    //    BeginXXX function returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
    // - Note that the bottom of window stack always contains a window called "Debug".
    IMGUI_API bool          Begin(const char* name, bool* p_open = NULL, ImGuiWindowFlags flags = 0);
    IMGUI_API void          End();

    // Child Windows
    // - Use child windows to begin into a self-contained independent scrolling/clipping regions within a host window. Child windows can embed their own child.
    // - Before 1.90 (November 2023), the "ImGuiChildFlags child_flags = 0" parameter was "bool border = false".
    //   This API is backward compatible with old code, as we guarantee that ImGuiChildFlags_Border == true.
    //   Consider updating your old code:
    //      BeginChild("Name", size, false)   -> Begin("Name", size, 0); or Begin("Name", size, ImGuiChildFlags_None);
    //      BeginChild("Name", size, true)    -> Begin("Name", size, ImGuiChildFlags_Border);
    // - Manual sizing (each axis can use a different setting e.g. ImVec2(0.0f, 400.0f)):
    //     == 0.0f: use remaining parent window size for this axis.
    //      > 0.0f: use specified size for this axis.
    //      < 0.0f: right/bottom-align to specified distance from available content boundaries.
    // - Specifying ImGuiChildFlags_AutoResizeX or ImGuiChildFlags_AutoResizeY makes the sizing automatic based on child contents.
    //   Combining both ImGuiChildFlags_AutoResizeX _and_ ImGuiChildFlags_AutoResizeY defeats purpose of a scrolling region and is NOT recommended.
    // - BeginChild() returns false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
    //   anything to the window. Always call a matching EndChild() for each BeginChild() call, regardless of its return value.
    //   [Important: due to legacy reason, Begin/End and BeginChild/EndChild are inconsistent with all other functions
    //    such as BeginMenu/EndMenu, BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding
    //    BeginXXX function returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
    IMGUI_API bool          BeginChild(const char* str_id, const ImVec2& size = ImVec2(0, 0), ImGuiChildFlags child_flags = 0, ImGuiWindowFlags window_flags = 0);
    IMGUI_API bool          BeginChild(ImGuiID id, const ImVec2& size = ImVec2(0, 0), ImGuiChildFlags child_flags = 0, ImGuiWindowFlags window_flags = 0);
    IMGUI_API void          EndChild();

    // Windows Utilities
    // - 'current window' = the window we are appending into while inside a Begin()/End() block. 'next window' = next window we will Begin() into.
    IMGUI_API bool          IsWindowAppearing();
    IMGUI_API bool          IsWindowCollapsed();
    IMGUI_API bool          IsWindowFocused(ImGuiFocusedFlags flags=0); // is current window focused? or its root/child, depending on flags. see flags for options.
    IMGUI_API bool          IsWindowHovered(ImGuiHoveredFlags flags=0); // is current window hovered and hoverable (e.g. not blocked by a popup/modal)? See ImGuiHoveredFlags_ for options. IMPORTANT: If you are trying to check whether your mouse should be dispatched to Dear ImGui or to your underlying app, you should not use this function! Use the 'io.WantCaptureMouse' boolean for that! Refer to FAQ entry "How can I tell whether to dispatch mouse/keyboard to Dear ImGui or my application?" for details.
    IMGUI_API ImDrawList*   GetWindowDrawList();                        // get draw list associated to the current window, to append your own drawing primitives
    IMGUI_API ImVec2        GetWindowPos();                             // get current window position in screen space (note: it is unlikely you need to use this. Consider using current layout pos instead, GetCursorScreenPos())
    IMGUI_API ImVec2        GetWindowSize();                            // get current window size (note: it is unlikely you need to use this. Consider using GetCursorScreenPos() and e.g. GetContentRegionAvail() instead)
    IMGUI_API float         GetWindowWidth();                           // get current window width (shortcut for GetWindowSize().x)
    IMGUI_API float         GetWindowHeight();                          // get current window height (shortcut for GetWindowSize().y)

    // Window manipulation
    // - Prefer using SetNextXXX functions (before Begin) rather that SetXXX functions (after Begin).
    IMGUI_API void          SetNextWindowPos(const ImVec2& pos, ImGuiCond cond = 0, const ImVec2& pivot = ImVec2(0, 0)); // set next window position. call before Begin(). use pivot=(0.5f,0.5f) to center on given point, etc.
    IMGUI_API void          SetNextWindowSize(const ImVec2& size, ImGuiCond cond = 0);                  // set next window size. set axis to 0.0f to force an auto-fit on this axis. call before Begin()
    IMGUI_API void          SetNextWindowSizeConstraints(const ImVec2& size_min, const ImVec2& size_max, ImGuiSizeCallback custom_callback = NULL, void* custom_callback_data = NULL); // set next window size limits. use 0.0f or FLT_MAX if you don't want limits. Use -1 for both min and max of same axis to preserve current size (which itself is a constraint). Use callback to apply non-trivial programmatic constraints.
    IMGUI_API void          SetNextWindowContentSize(const ImVec2& size);                               // set next window content size (~ scrollable client area, which enforce the range of scrollbars). Not including window decorations (title bar, menu bar, etc.) nor WindowPadding. set an axis to 0.0f to leave it automatic. call before Begin()
    IMGUI_API void          SetNextWindowCollapsed(bool collapsed, ImGuiCond cond = 0);                 // set next window collapsed state. call before Begin()
    IMGUI_API void          SetNextWindowFocus();                                                       // set next window to be focused / top-most. call before Begin()
    IMGUI_API void          SetNextWindowScroll(const ImVec2& scroll);                                  // set next window scrolling value (use < 0.0f to not affect a given axis).
    IMGUI_API void          SetNextWindowBgAlpha(float alpha);                                          // set next window background color alpha. helper to easily override the Alpha component of ImGuiCol_WindowBg/ChildBg/PopupBg. you may also use ImGuiWindowFlags_NoBackground.
    IMGUI_API void          SetWindowPos(const ImVec2& pos, ImGuiCond cond = 0);                        // (not recommended) set current window position - call within Begin()/End(). prefer using SetNextWindowPos(), as this may incur tearing and side-effects.
    IMGUI_API void          SetWindowSize(const ImVec2& size, ImGuiCond cond = 0);                      // (not recommended) set current window size - call within Begin()/End(). set to ImVec2(0, 0) to force an auto-fit. prefer using SetNextWindowSize(), as this may incur tearing and minor side-effects.
    IMGUI_API void          SetWindowCollapsed(bool collapsed, ImGuiCond cond = 0);                     // (not recommended) set current window collapsed state. prefer using SetNextWindowCollapsed().
    IMGUI_API void          SetWindowFocus();                                                           // (not recommended) set current window to be focused / top-most. prefer using SetNextWindowFocus().
    IMGUI_API void          SetWindowFontScale(float scale);                                            // [OBSOLETE] set font scale. Adjust IO.FontGlobalScale if you want to scale all windows. This is an old API! For correct scaling, prefer to reload font + rebuild ImFontAtlas + call style.ScaleAllSizes().
    IMGUI_API void          SetWindowPos(const char* name, const ImVec2& pos, ImGuiCond cond = 0);      // set named window position.
    IMGUI_API void          SetWindowSize(const char* name, const ImVec2& size, ImGuiCond cond = 0);    // set named window size. set axis to 0.0f to force an auto-fit on this axis.
    IMGUI_API void          SetWindowCollapsed(const char* name, bool collapsed, ImGuiCond cond = 0);   // set named window collapsed state
    IMGUI_API void          SetWindowFocus(const char* name);                                           // set named window to be focused / top-most. use NULL to remove focus.

    // Content region
    // - Retrieve available space from a given point. GetContentRegionAvail() is frequently useful.
    // - Those functions are bound to be redesigned (they are confusing, incomplete and the Min/Max return values are in local window coordinates which increases confusion)
    IMGUI_API ImVec2        GetContentRegionAvail();                                        // == GetContentRegionMax() - GetCursorPos()
    IMGUI_API ImVec2        GetContentRegionMax();                                          // current content boundaries (typically window boundaries including scrolling, or current column boundaries), in windows coordinates
    IMGUI_API ImVec2        GetWindowContentRegionMin();                                    // content boundaries min for the full window (roughly (0,0)-Scroll), in window coordinates
    IMGUI_API ImVec2        GetWindowContentRegionMax();                                    // content boundaries max for the full window (roughly (0,0)+Size-Scroll) where Size can be overridden with SetNextWindowContentSize(), in window coordinates

    // Windows Scrolling
    // - Any change of Scroll will be applied at the beginning of next frame in the first call to Begin().
    // - You may instead use SetNextWindowScroll() prior to calling Begin() to avoid this delay, as an alternative to using SetScrollX()/SetScrollY().
    IMGUI_API float         GetScrollX();                                                   // get scrolling amount [0 .. GetScrollMaxX()]
    IMGUI_API float         GetScrollY();                                                   // get scrolling amount [0 .. GetScrollMaxY()]
    IMGUI_API void          SetScrollX(float scroll_x);                                     // set scrolling amount [0 .. GetScrollMaxX()]
    IMGUI_API void          SetScrollY(float scroll_y);                                     // set scrolling amount [0 .. GetScrollMaxY()]
    IMGUI_API float         GetScrollMaxX();                                                // get maximum scrolling amount ~~ ContentSize.x - WindowSize.x - DecorationsSize.x
    IMGUI_API float         GetScrollMaxY();                                                // get maximum scrolling amount ~~ ContentSize.y - WindowSize.y - DecorationsSize.y
    IMGUI_API void          SetScrollHereX(float center_x_ratio = 0.5f);                    // adjust scrolling amount to make current cursor position visible. center_x_ratio=0.0: left, 0.5: center, 1.0: right. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
    IMGUI_API void          SetScrollHereY(float center_y_ratio = 0.5f);                    // adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
    IMGUI_API void          SetScrollFromPosX(float local_x, float center_x_ratio = 0.5f);  // adjust scrolling amount to make given position visible. Generally GetCursorStartPos() + offset to compute a valid position.
    IMGUI_API void          SetScrollFromPosY(float local_y, float center_y_ratio = 0.5f);  // adjust scrolling amount to make given position visible. Generally GetCursorStartPos() + offset to compute a valid position.

    // Parameters stacks (shared)
    IMGUI_API void          PushFont(ImFont* font);                                         // use NULL as a shortcut to push default font
    IMGUI_API void          PopFont();
    IMGUI_API void          PushStyleColor(ImGuiCol idx, ImU32 col);                        // modify a style color. always use this if you modify the style after NewFrame().
    IMGUI_API void          PushStyleColor(ImGuiCol idx, const ImVec4& col);
    IMGUI_API void          PopStyleColor(int count = 1);
    IMGUI_API void          PushStyleVar(ImGuiStyleVar idx, float val);                     // modify a style float variable. always use this if you modify the style after NewFrame().
    IMGUI_API void          PushStyleVar(ImGuiStyleVar idx, const ImVec2& val);             // modify a style ImVec2 variable. always use this if you modify the style after NewFrame().
    IMGUI_API void          PopStyleVar(int count = 1);
    IMGUI_API void          PushTabStop(bool tab_stop);                                     // == tab stop enable. Allow focusing using TAB/Shift-TAB, enabled by default but you can disable it for certain widgets
    IMGUI_API void          PopTabStop();
    IMGUI_API void          PushButtonRepeat(bool repeat);                                  // in 'repeat' mode, Button*() functions return repeated true in a typematic manner (using io.KeyRepeatDelay/io.KeyRepeatRate setting). Note that you can call IsItemActive() after any Button() to tell if the button is held in the current frame.
    IMGUI_API void          PopButtonRepeat();

    // Parameters stacks (current window)
    IMGUI_API void          PushItemWidth(float item_width);                                // push width of items for common large "item+label" widgets. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -FLT_MIN always align width to the right side).
    IMGUI_API void          PopItemWidth();
    IMGUI_API void          SetNextItemWidth(float item_width);                             // set width of the _next_ common large "item+label" widget. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -FLT_MIN always align width to the right side)
    IMGUI_API float         CalcItemWidth();                                                // width of item given pushed settings and current cursor position. NOT necessarily the width of last item unlike most 'Item' functions.
    IMGUI_API void          PushTextWrapPos(float wrap_local_pos_x = 0.0f);                 // push word-wrapping position for Text*() commands. < 0.0f: no wrapping; 0.0f: wrap to end of window (or column); > 0.0f: wrap at 'wrap_pos_x' position in window local space
    IMGUI_API void          PopTextWrapPos();

    // Style read access
    // - Use the ShowStyleEditor() function to interactively see/edit the colors.
    IMGUI_API ImFont*       GetFont();                                                      // get current font
    IMGUI_API float         GetFontSize();                                                  // get current font size (= height in pixels) of current font with current scale applied
    IMGUI_API ImVec2        GetFontTexUvWhitePixel();                                       // get UV coordinate for a while pixel, useful to draw custom shapes via the ImDrawList API
    IMGUI_API ImU32         GetColorU32(ImGuiCol idx, float alpha_mul = 1.0f);              // retrieve given style color with style alpha applied and optional extra alpha multiplier, packed as a 32-bit value suitable for ImDrawList
    IMGUI_API ImU32         GetColorU32(const ImVec4& col);                                 // retrieve given color with style alpha applied, packed as a 32-bit value suitable for ImDrawList
    IMGUI_API ImU32         GetColorU32(ImU32 col, float alpha_mul = 1.0f);                 // retrieve given color with style alpha applied, packed as a 32-bit value suitable for ImDrawList
    IMGUI_API const ImVec4& GetStyleColorVec4(ImGuiCol idx);                                // retrieve style color as stored in ImGuiStyle structure. use to feed back into PushStyleColor(), otherwise use GetColorU32() to get style color with style alpha baked in.

    // Layout cursor positioning
    // - By "cursor" we mean the current output position.
    // - The typical widget behavior is to output themselves at the current cursor position, then move the cursor one line down.
    // - You can call SameLine() between widgets to undo the last carriage return and output at the right of the preceding widget.
    // - Attention! We currently have inconsistencies between window-local and absolute positions we will aim to fix with future API:
    //    - Absolute coordinate:        GetCursorScreenPos(), SetCursorScreenPos(), all ImDrawList:: functions. -> this is the preferred way forward.
    //    - Window-local coordinates:   SameLine(), GetCursorPos(), SetCursorPos(), GetCursorStartPos(), GetContentRegionMax(), GetWindowContentRegion*(), PushTextWrapPos()
    // - GetCursorScreenPos() = GetCursorPos() + GetWindowPos(). GetWindowPos() is almost only ever useful to convert from window-local to absolute coordinates.
    IMGUI_API ImVec2        GetCursorScreenPos();                                           // cursor position in absolute coordinates (prefer using this, also more useful to work with ImDrawList API).
    IMGUI_API void          SetCursorScreenPos(const ImVec2& pos);                          // cursor position in absolute coordinates
    IMGUI_API ImVec2        GetCursorPos();                                                 // [window-local] cursor position in window coordinates (relative to window position)
    IMGUI_API float         GetCursorPosX();                                                // [window-local] "
    IMGUI_API float         GetCursorPosY();                                                // [window-local] "
    IMGUI_API void          SetCursorPos(const ImVec2& local_pos);                          // [window-local] "
    IMGUI_API void          SetCursorPosX(float local_x);                                   // [window-local] "
    IMGUI_API void          SetCursorPosY(float local_y);                                   // [window-local] "
    IMGUI_API ImVec2        GetCursorStartPos();                                            // [window-local] initial cursor position, in window coordinates

    // Other layout functions
    IMGUI_API void          Separator();                                                    // separator, generally horizontal. inside a menu bar or in horizontal layout mode, this becomes a vertical separator.
    IMGUI_API void          SameLine(float offset_from_start_x=0.0f, float spacing=-1.0f);  // call between widgets or groups to layout them horizontally. X position given in window coordinates.
    IMGUI_API void          NewLine();                                                      // undo a SameLine() or force a new line when in a horizontal-layout context.
    IMGUI_API void          Spacing();                                                      // add vertical spacing.
    IMGUI_API void          Dummy(const ImVec2& size);                                      // add a dummy item of given size. unlike InvisibleButton(), Dummy() won't take the mouse click or be navigable into.
    IMGUI_API void          Indent(float indent_w = 0.0f);                                  // move content position toward the right, by indent_w, or style.IndentSpacing if indent_w <= 0
    IMGUI_API void          Unindent(float indent_w = 0.0f);                                // move content position back to the left, by indent_w, or style.IndentSpacing if indent_w <= 0
    IMGUI_API void          BeginGroup();                                                   // lock horizontal starting position
    IMGUI_API void          EndGroup();                                                     // unlock horizontal starting position + capture the whole group bounding box into one "item" (so you can use IsItemHovered() or layout primitives such as SameLine() on whole group, etc.)
    IMGUI_API void          AlignTextToFramePadding();                                      // vertically align upcoming text baseline to FramePadding.y so that it will align properly to regularly framed items (call if you have text on a line before a framed item)
    IMGUI_API float         GetTextLineHeight();                                            // ~ FontSize
    IMGUI_API float         GetTextLineHeightWithSpacing();                                 // ~ FontSize + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of text)
    IMGUI_API float         GetFrameHeight();                                               // ~ FontSize + style.FramePadding.y * 2
    IMGUI_API float         GetFrameHeightWithSpacing();                                    // ~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of framed widgets)

    // ID stack/scopes
    // Read the FAQ (docs/FAQ.md or http://dearimgui.com/faq) for more details about how ID are handled in dear imgui.
    // - Those questions are answered and impacted by understanding of the ID stack system:
    //   - "Q: Why is my widget not reacting when I click on it?"
    //   - "Q: How can I have widgets with an empty label?"
    //   - "Q: How can I have multiple widgets with the same label?"
    // - Short version: ID are hashes of the entire ID stack. If you are creating widgets in a loop you most likely
    //   want to push a unique identifier (e.g. object pointer, loop index) to uniquely differentiate them.
    // - You can also use the "Label##foobar" syntax within widget label to distinguish them from each others.
    // - In this header file we use the "label"/"name" terminology to denote a string that will be displayed + used as an ID,
    //   whereas "str_id" denote a string that is only used as an ID and not normally displayed.
    IMGUI_API void          PushID(const char* str_id);                                     // push string into the ID stack (will hash string).
    IMGUI_API void          PushID(const char* str_id_begin, const char* str_id_end);       // push string into the ID stack (will hash string).
    IMGUI_API void          PushID(const void* ptr_id);                                     // push pointer into the ID stack (will hash pointer).
    IMGUI_API void          PushID(int int_id);                                             // push integer into the ID stack (will hash integer).
    IMGUI_API void          PopID();                                                        // pop from the ID stack.
    IMGUI_API ImGuiID       GetID(const char* str_id);                                      // calculate unique ID (hash of whole ID stack + given parameter). e.g. if you want to query into ImGuiStorage yourself
    IMGUI_API ImGuiID       GetID(const char* str_id_begin, const char* str_id_end);
    IMGUI_API ImGuiID       GetID(const void* ptr_id);

    // Widgets: Text
    IMGUI_API void          TextUnformatted(const char* text, const char* text_end = NULL); // raw text without formatting. Roughly equivalent to Text("%s", text) but: A) doesn't require null terminated string if 'text_end' is specified, B) it's faster, no memory copy is done, no buffer size limits, recommended for long chunks of text.
    IMGUI_API void          Text(const char* fmt, ...)                                      IM_FMTARGS(1); // formatted text
    IMGUI_API void          TextV(const char* fmt, va_list args)                            IM_FMTLIST(1);
    IMGUI_API void          TextColored(const ImVec4& col, const char* fmt, ...)            IM_FMTARGS(2); // shortcut for PushStyleColor(ImGuiCol_Text, col); Text(fmt, ...); PopStyleColor();
    IMGUI_API void          TextColoredV(const ImVec4& col, const char* fmt, va_list args)  IM_FMTLIST(2);
    IMGUI_API void          TextDisabled(const char* fmt, ...)                              IM_FMTARGS(1); // shortcut for PushStyleColor(ImGuiCol_Text, style.Colors[ImGuiCol_TextDisabled]); Text(fmt, ...); PopStyleColor();
    IMGUI_API void          TextDisabledV(const char* fmt, va_list args)                    IM_FMTLIST(1);
    IMGUI_API void          TextWrapped(const char* fmt, ...)                               IM_FMTARGS(1); // shortcut for PushTextWrapPos(0.0f); Text(fmt, ...); PopTextWrapPos();. Note that this won't work on an auto-resizing window if there's no other widgets to extend the window width, yoy may need to set a size using SetNextWindowSize().
    IMGUI_API void          TextWrappedV(const char* fmt, va_list args)                     IM_FMTLIST(1);
    IMGUI_API void          LabelText(const char* label, const char* fmt, ...)              IM_FMTARGS(2); // display text+label aligned the same way as value+label widgets
    IMGUI_API void          LabelTextV(const char* label, const char* fmt, va_list args)    IM_FMTLIST(2);
    IMGUI_API void          BulletText(const char* fmt, ...)                                IM_FMTARGS(1); // shortcut for Bullet()+Text()
    IMGUI_API void          BulletTextV(const char* fmt, va_list args)                      IM_FMTLIST(1);
    IMGUI_API void          SeparatorText(const char* label);                               // currently: formatted text with an horizontal line

    // Widgets: Main
    // - Most widgets return true when the value has been changed or when pressed/selected
    // - You may also use one of the many IsItemXXX functions (e.g. IsItemActive, IsItemHovered, etc.) to query widget state.
    IMGUI_API bool          Button(const char* label, const ImVec2& size = ImVec2(0, 0));   // button
    IMGUI_API bool          SmallButton(const char* label);                                 // button with (FramePadding.y == 0) to easily embed within text
    IMGUI_API bool          InvisibleButton(const char* str_id, const ImVec2& size, ImGuiButtonFlags flags = 0); // flexible button behavior without the visuals, frequently useful to build custom behaviors using the public api (along with IsItemActive, IsItemHovered, etc.)
    IMGUI_API bool          ArrowButton(const char* str_id, ImGuiDir dir);                  // square button with an arrow shape
    IMGUI_API bool          Checkbox(const char* label, bool* v);
    IMGUI_API bool          CheckboxFlags(const char* label, int* flags, int flags_value);
    IMGUI_API bool          CheckboxFlags(const char* label, unsigned int* flags, unsigned int flags_value);
    IMGUI_API bool          RadioButton(const char* label, bool active);                    // use with e.g. if (RadioButton("one", my_value==1)) { my_value = 1; }
    IMGUI_API bool          RadioButton(const char* label, int* v, int v_button);           // shortcut to handle the above pattern when value is an integer
    IMGUI_API void          ProgressBar(float fraction, const ImVec2& size_arg = ImVec2(-FLT_MIN, 0), const char* overlay = NULL);
    IMGUI_API void          Bullet();                                                       // draw a small circle + keep the cursor on the same line. advance cursor x position by GetTreeNodeToLabelSpacing(), same distance that TreeNode() uses

    // Widgets: Images
    // - Read about ImTextureID here: https://github.com/ocornut/imgui/wiki/Image-Loading-and-Displaying-Examples
    // - 'uv0' and 'uv1' are texture coordinates. Read about them from the same link above.
    // - Note that Image() may add +2.0f to provided size if a border is visible, ImageButton() adds style.FramePadding*2.0f to provided size.
    IMGUI_API void          Image(ImTextureID user_texture_id, const ImVec2& image_size, const ImVec2& uv0 = ImVec2(0, 0), const ImVec2& uv1 = ImVec2(1, 1), const ImVec4& tint_col = ImVec4(1, 1, 1, 1), const ImVec4& border_col = ImVec4(0, 0, 0, 0));
    IMGUI_API bool          ImageButton(const char* str_id, ImTextureID user_texture_id, const ImVec2& image_size, const ImVec2& uv0 = ImVec2(0, 0), const ImVec2& uv1 = ImVec2(1, 1), const ImVec4& bg_col = ImVec4(0, 0, 0, 0), const ImVec4& tint_col = ImVec4(1, 1, 1, 1));

    // Widgets: Combo Box (Dropdown)
    // - The BeginCombo()/EndCombo() api allows you to manage your contents and selection state however you want it, by creating e.g. Selectable() items.
    // - The old Combo() api are helpers over BeginCombo()/EndCombo() which are kept available for convenience purpose. This is analogous to how ListBox are created.
    IMGUI_API bool          BeginCombo(const char* label, const char* preview_value, ImGuiComboFlags flags = 0);
    IMGUI_API void          EndCombo(); // only call EndCombo() if BeginCombo() returns true!
    IMGUI_API bool          Combo(const char* label, int* current_item, const char* const items[], int items_count, int popup_max_height_in_items = -1);
    IMGUI_API bool          Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int popup_max_height_in_items = -1);      // Separate items with \0 within a string, end item-list with \0\0. e.g. "One\0Two\0Three\0"
    IMGUI_API bool          Combo(const char* label, int* current_item, const char* (*getter)(void* user_data, int idx), void* user_data, int items_count, int popup_max_height_in_items = -1);

    // Widgets: Drag Sliders
    // - CTRL+Click on any drag box to turn them into an input box. Manually input values aren't clamped by default and can go off-bounds. Use ImGuiSliderFlags_AlwaysClamp to always clamp.
    // - For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every function, note that a 'float v[X]' function argument is the same as 'float* v',
    //   the array syntax is just a way to document the number of elements that are expected to be accessible. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
    // - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
    // - Format string may also be set to NULL or use the default format ("%f" or "%d").
    // - Speed are per-pixel of mouse movement (v_speed=0.2f: mouse needs to move by 5 pixels to increase value by 1). For gamepad/keyboard navigation, minimum speed is Max(v_speed, minimum_step_at_given_precision).
    // - Use v_min < v_max to clamp edits to given limits. Note that CTRL+Click manual input can override those limits if ImGuiSliderFlags_AlwaysClamp is not used.
    // - Use v_max = FLT_MAX / INT_MAX etc to avoid clamping to a maximum, same with v_min = -FLT_MAX / INT_MIN to avoid clamping to a minimum.
    // - We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
    // - Legacy: Pre-1.78 there are DragXXX() function signatures that take a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
    //   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
    IMGUI_API bool          DragFloat(const char* label, float* v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0);     // If v_min >= v_max we have no bound
    IMGUI_API bool          DragFloat2(const char* label, float v[2], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragFloat3(const char* label, float v[3], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragFloat4(const char* label, float v[4], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragFloatRange2(const char* label, float* v_current_min, float* v_current_max, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* format = "%.3f", const char* format_max = NULL, ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragInt(const char* label, int* v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0);  // If v_min >= v_max we have no bound
    IMGUI_API bool          DragInt2(const char* label, int v[2], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragInt3(const char* label, int v[3], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragInt4(const char* label, int v[4], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragIntRange2(const char* label, int* v_current_min, int* v_current_max, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* format = "%d", const char* format_max = NULL, ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragScalar(const char* label, ImGuiDataType data_type, void* p_data, float v_speed = 1.0f, const void* p_min = NULL, const void* p_max = NULL, const char* format = NULL, ImGuiSliderFlags flags = 0);
    IMGUI_API bool          DragScalarN(const char* label, ImGuiDataType data_type, void* p_data, int components, float v_speed = 1.0f, const void* p_min = NULL, const void* p_max = NULL, const char* format = NULL, ImGuiSliderFlags flags = 0);

    // Widgets: Regular Sliders
    // - CTRL+Click on any slider to turn them into an input box. Manually input values aren't clamped by default and can go off-bounds. Use ImGuiSliderFlags_AlwaysClamp to always clamp.
    // - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
    // - Format string may also be set to NULL or use the default format ("%f" or "%d").
    // - Legacy: Pre-1.78 there are SliderXXX() function signatures that take a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
    //   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
    IMGUI_API bool          SliderFloat(const char* label, float* v, float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0);     // adjust format to decorate the value with a prefix or a suffix for in-slider labels or unit display.
    IMGUI_API bool          SliderFloat2(const char* label, float v[2], float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderFloat3(const char* label, float v[3], float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderFloat4(const char* label, float v[4], float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderAngle(const char* label, float* v_rad, float v_degrees_min = -360.0f, float v_degrees_max = +360.0f, const char* format = "%.0f deg", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderInt(const char* label, int* v, int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderInt2(const char* label, int v[2], int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderInt3(const char* label, int v[3], int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderInt4(const char* label, int v[4], int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderScalar(const char* label, ImGuiDataType data_type, void* p_data, const void* p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0);
    IMGUI_API bool          SliderScalarN(const char* label, ImGuiDataType data_type, void* p_data, int components, const void* p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0);
    IMGUI_API bool          VSliderFloat(const char* label, const ImVec2& size, float* v, float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          VSliderInt(const char* label, const ImVec2& size, int* v, int v_min, int v_max, const char* format = "%d", ImGuiSliderFlags flags = 0);
    IMGUI_API bool          VSliderScalar(const char* label, const ImVec2& size, ImGuiDataType data_type, void* p_data, const void* p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0);

    // Widgets: Input with Keyboard
    // - If you want to use InputText() with std::string or any custom dynamic string type, see misc/cpp/imgui_stdlib.h and comments in imgui_demo.cpp.
    // - Most of the ImGuiInputTextFlags flags are only useful for InputText() and not for InputFloatX, InputIntX, InputDouble etc.
    IMGUI_API bool          InputText(const char* label, char* buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiInputTextCallback callback = NULL, void* user_data = NULL);
    IMGUI_API bool          InputTextMultiline(const char* label, char* buf, size_t buf_size, const ImVec2& size = ImVec2(0, 0), ImGuiInputTextFlags flags = 0, ImGuiInputTextCallback callback = NULL, void* user_data = NULL);
    IMGUI_API bool          InputTextWithHint(const char* label, const char* hint, char* buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiInputTextCallback callback = NULL, void* user_data = NULL);
    IMGUI_API bool          InputFloat(const char* label, float* v, float step = 0.0f, float step_fast = 0.0f, const char* format = "%.3f", ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputFloat2(const char* label, float v[2], const char* format = "%.3f", ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputFloat3(const char* label, float v[3], const char* format = "%.3f", ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputFloat4(const char* label, float v[4], const char* format = "%.3f", ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputInt(const char* label, int* v, int step = 1, int step_fast = 100, ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputInt2(const char* label, int v[2], ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputInt3(const char* label, int v[3], ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputInt4(const char* label, int v[4], ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputDouble(const char* label, double* v, double step = 0.0, double step_fast = 0.0, const char* format = "%.6f", ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputScalar(const char* label, ImGuiDataType data_type, void* p_data, const void* p_step = NULL, const void* p_step_fast = NULL, const char* format = NULL, ImGuiInputTextFlags flags = 0);
    IMGUI_API bool          InputScalarN(const char* label, ImGuiDataType data_type, void* p_data, int components, const void* p_step = NULL, const void* p_step_fast = NULL, const char* format = NULL, ImGuiInputTextFlags flags = 0);

    // Widgets: Color Editor/Picker (tip: the ColorEdit* functions have a little color square that can be left-clicked to open a picker, and right-clicked to open an option menu.)
    // - Note that in C++ a 'float v[X]' function argument is the _same_ as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible.
    // - You can pass the address of a first float element out of a contiguous structure, e.g. &myvector.x
    IMGUI_API bool          ColorEdit3(const char* label, float col[3], ImGuiColorEditFlags flags = 0);
    IMGUI_API bool          ColorEdit4(const char* label, float col[4], ImGuiColorEditFlags flags = 0);
    IMGUI_API bool          ColorPicker3(const char* label, float col[3], ImGuiColorEditFlags flags = 0);
    IMGUI_API bool          ColorPicker4(const char* label, float col[4], ImGuiColorEditFlags flags = 0, const float* ref_col = NULL);
    IMGUI_API bool          ColorButton(const char* desc_id, const ImVec4& col, ImGuiColorEditFlags flags = 0, const ImVec2& size = ImVec2(0, 0)); // display a color square/button, hover for details, return true when pressed.
    IMGUI_API void          SetColorEditOptions(ImGuiColorEditFlags flags);                     // initialize current options (generally on application startup) if you want to select a default format, picker type, etc. User will be able to change many settings, unless you pass the _NoOptions flag to your calls.

    // Widgets: Trees
    // - TreeNode functions return true when the node is open, in which case you need to also call TreePop() when you are finished displaying the tree node contents.
    IMGUI_API bool          TreeNode(const char* label);
    IMGUI_API bool          TreeNode(const char* str_id, const char* fmt, ...) IM_FMTARGS(2);   // helper variation to easily decorelate the id from the displayed string. Read the FAQ about why and how to use ID. to align arbitrary text at the same level as a TreeNode() you can use Bullet().
    IMGUI_API bool          TreeNode(const void* ptr_id, const char* fmt, ...) IM_FMTARGS(2);   // "
    IMGUI_API bool          TreeNodeV(const char* str_id, const char* fmt, va_list args) IM_FMTLIST(2);
    IMGUI_API bool          TreeNodeV(const void* ptr_id, const char* fmt, va_list args) IM_FMTLIST(2);
    IMGUI_API bool          TreeNodeEx(const char* label, ImGuiTreeNodeFlags flags = 0);
    IMGUI_API bool          TreeNodeEx(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_FMTARGS(3);
    IMGUI_API bool          TreeNodeEx(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_FMTARGS(3);
    IMGUI_API bool          TreeNodeExV(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) IM_FMTLIST(3);
    IMGUI_API bool          TreeNodeExV(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) IM_FMTLIST(3);
    IMGUI_API void          TreePush(const char* str_id);                                       // ~ Indent()+PushID(). Already called by TreeNode() when returning true, but you can call TreePush/TreePop yourself if desired.
    IMGUI_API void          TreePush(const void* ptr_id);                                       // "
    IMGUI_API void          TreePop();                                                          // ~ Unindent()+PopID()
    IMGUI_API float         GetTreeNodeToLabelSpacing();                                        // horizontal distance preceding label when using TreeNode*() or Bullet() == (g.FontSize + style.FramePadding.x*2) for a regular unframed TreeNode
    IMGUI_API bool          CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0);  // if returning 'true' the header is open. doesn't indent nor push on ID stack. user doesn't have to call TreePop().
    IMGUI_API bool          CollapsingHeader(const char* label, bool* p_visible, ImGuiTreeNodeFlags flags = 0); // when 'p_visible != NULL': if '*p_visible==true' display an additional small close button on upper right of the header which will set the bool to false when clicked, if '*p_visible==false' don't display the header.
    IMGUI_API void          SetNextItemOpen(bool is_open, ImGuiCond cond = 0);                  // set next TreeNode/CollapsingHeader open state.

    // Widgets: Selectables
    // - A selectable highlights when hovered, and can display another color when selected.
    // - Neighbors selectable extend their highlight bounds in order to leave no gap between them. This is so a series of selected Selectable appear contiguous.
    IMGUI_API bool          Selectable(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0)); // "bool selected" carry the selection state (read-only). Selectable() is clicked is returns true so you can modify your selection state. size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
    IMGUI_API bool          Selectable(const char* label, bool* p_selected, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0));      // "bool* p_selected" point to the selection state (read-write), as a convenient helper.

    // Widgets: List Boxes
    // - This is essentially a thin wrapper to using BeginChild/EndChild with the ImGuiChildFlags_FrameStyle flag for stylistic changes + displaying a label.
    // - You can submit contents and manage your selection state however you want it, by creating e.g. Selectable() or any other items.
    // - The simplified/old ListBox() api are helpers over BeginListBox()/EndListBox() which are kept available for convenience purpose. This is analoguous to how Combos are created.
    // - Choose frame width:   size.x > 0.0f: custom  /  size.x < 0.0f or -FLT_MIN: right-align   /  size.x = 0.0f (default): use current ItemWidth
    // - Choose frame height:  size.y > 0.0f: custom  /  size.y < 0.0f or -FLT_MIN: bottom-align  /  size.y = 0.0f (default): arbitrary default height which can fit ~7 items
    IMGUI_API bool          BeginListBox(const char* label, const ImVec2& size = ImVec2(0, 0)); // open a framed scrolling region
    IMGUI_API void          EndListBox();                                                       // only call EndListBox() if BeginListBox() returned true!
    IMGUI_API bool          ListBox(const char* label, int* current_item, const char* const items[], int items_count, int height_in_items = -1);
    IMGUI_API bool          ListBox(const char* label, int* current_item, const char* (*getter)(void* user_data, int idx), void* user_data, int items_count, int height_in_items = -1);

    // Widgets: Data Plotting
    // - Consider using ImPlot (https://github.com/epezent/implot) which is much better!
    IMGUI_API void          PlotLines(const char* label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0), int stride = sizeof(float));
    IMGUI_API void          PlotLines(const char* label, float(*values_getter)(void* data, int idx), void* data, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0));
    IMGUI_API void          PlotHistogram(const char* label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0), int stride = sizeof(float));
    IMGUI_API void          PlotHistogram(const char* label, float (*values_getter)(void* data, int idx), void* data, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0, 0));

    // Widgets: Value() Helpers.
    // - Those are merely shortcut to calling Text() with a format string. Output single value in "name: value" format (tip: freely declare more in your code to handle your types. you can add functions to the ImGui namespace)
    IMGUI_API void          Value(const char* prefix, bool b);
    IMGUI_API void          Value(const char* prefix, int v);
    IMGUI_API void          Value(const char* prefix, unsigned int v);
    IMGUI_API void          Value(const char* prefix, float v, const char* float_format = NULL);

    // Widgets: Menus
    // - Use BeginMenuBar() on a window ImGuiWindowFlags_MenuBar to append to its menu bar.
    // - Use BeginMainMenuBar() to create a menu bar at the top of the screen and append to it.
    // - Use BeginMenu() to create a menu. You can call BeginMenu() multiple time with the same identifier to append more items to it.
    // - Not that MenuItem() keyboardshortcuts are displayed as a convenience but _not processed_ by Dear ImGui at the moment.
    IMGUI_API bool          BeginMenuBar();                                                     // append to menu-bar of current window (requires ImGuiWindowFlags_MenuBar flag set on parent window).
    IMGUI_API void          EndMenuBar();                                                       // only call EndMenuBar() if BeginMenuBar() returns true!
    IMGUI_API bool          BeginMainMenuBar();                                                 // create and append to a full screen menu-bar.
    IMGUI_API void          EndMainMenuBar();                                                   // only call EndMainMenuBar() if BeginMainMenuBar() returns true!
    IMGUI_API bool          BeginMenu(const char* label, bool enabled = true);                  // create a sub-menu entry. only call EndMenu() if this returns true!
    IMGUI_API void          EndMenu();                                                          // only call EndMenu() if BeginMenu() returns true!
    IMGUI_API bool          MenuItem(const char* label, const char* shortcut = NULL, bool selected = false, bool enabled = true);  // return true when activated.
    IMGUI_API bool          MenuItem(const char* label, const char* shortcut, bool* p_selected, bool enabled = true);              // return true when activated + toggle (*p_selected) if p_selected != NULL

    // Tooltips
    // - Tooltips are windows following the mouse. They do not take focus away.
    // - A tooltip window can contain items of any types. SetTooltip() is a shortcut for the 'if (BeginTooltip()) { Text(...); EndTooltip(); }' idiom.
    IMGUI_API bool          BeginTooltip();                                                     // begin/append a tooltip window.
    IMGUI_API void          EndTooltip();                                                       // only call EndTooltip() if BeginTooltip()/BeginItemTooltip() returns true!
    IMGUI_API void          SetTooltip(const char* fmt, ...) IM_FMTARGS(1);                     // set a text-only tooltip. Often used after a ImGui::IsItemHovered() check. Override any previous call to SetTooltip().
    IMGUI_API void          SetTooltipV(const char* fmt, va_list args) IM_FMTLIST(1);

    // Tooltips: helpers for showing a tooltip when hovering an item
    // - BeginItemTooltip() is a shortcut for the 'if (IsItemHovered(ImGuiHoveredFlags_ForTooltip) && BeginTooltip())' idiom.
    // - SetItemTooltip() is a shortcut for the 'if (IsItemHovered(ImGuiHoveredFlags_ForTooltip)) { SetTooltip(...); }' idiom.
    // - Where 'ImGuiHoveredFlags_ForTooltip' itself is a shortcut to use 'style.HoverFlagsForTooltipMouse' or 'style.HoverFlagsForTooltipNav' depending on active input type. For mouse it defaults to 'ImGuiHoveredFlags_Stationary | ImGuiHoveredFlags_DelayShort'.
    IMGUI_API bool          BeginItemTooltip();                                                 // begin/append a tooltip window if preceding item was hovered.
    IMGUI_API void          SetItemTooltip(const char* fmt, ...) IM_FMTARGS(1);                 // set a text-only tooltip if preceeding item was hovered. override any previous call to SetTooltip().
    IMGUI_API void          SetItemTooltipV(const char* fmt, va_list args) IM_FMTLIST(1);

    // Popups, Modals
    //  - They block normal mouse hovering detection (and therefore most mouse interactions) behind them.
    //  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
    //  - Their visibility state (~bool) is held internally instead of being held by the programmer as we are used to with regular Begin*() calls.
    //  - The 3 properties above are related: we need to retain popup visibility state in the library because popups may be closed as any time.
    //  - You can bypass the hovering restriction by using ImGuiHoveredFlags_AllowWhenBlockedByPopup when calling IsItemHovered() or IsWindowHovered().
    //  - IMPORTANT: Popup identifiers are relative to the current ID stack, so OpenPopup and BeginPopup generally needs to be at the same level of the stack.
    //    This is sometimes leading to confusing mistakes. May rework this in the future.
    //  - BeginPopup(): query popup state, if open start appending into the window. Call EndPopup() afterwards if returned true. ImGuiWindowFlags are forwarded to the window.
    //  - BeginPopupModal(): block every interaction behind the window, cannot be closed by user, add a dimming background, has a title bar.
    IMGUI_API bool          BeginPopup(const char* str_id, ImGuiWindowFlags flags = 0);                         // return true if the popup is open, and you can start outputting to it.
    IMGUI_API bool          BeginPopupModal(const char* name, bool* p_open = NULL, ImGuiWindowFlags flags = 0); // return true if the modal is open, and you can start outputting to it.
    IMGUI_API void          EndPopup();                                                                         // only call EndPopup() if BeginPopupXXX() returns true!

    // Popups: open/close functions
    //  - OpenPopup(): set popup state to open. ImGuiPopupFlags are available for opening options.
    //  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
    //  - CloseCurrentPopup(): use inside the BeginPopup()/EndPopup() scope to close manually.
    //  - CloseCurrentPopup() is called by default by Selectable()/MenuItem() when activated (FIXME: need some options).
    //  - Use ImGuiPopupFlags_NoOpenOverExistingPopup to avoid opening a popup if there's already one at the same level. This is equivalent to e.g. testing for !IsAnyPopupOpen() prior to OpenPopup().
    //  - Use IsWindowAppearing() after BeginPopup() to tell if a window just opened.
    //  - IMPORTANT: Notice that for OpenPopupOnItemClick() we exceptionally default flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter
    IMGUI_API void          OpenPopup(const char* str_id, ImGuiPopupFlags popup_flags = 0);                     // call to mark popup as open (don't call every frame!).
    IMGUI_API void          OpenPopup(ImGuiID id, ImGuiPopupFlags popup_flags = 0);                             // id overload to facilitate calling from nested stacks
    IMGUI_API void          OpenPopupOnItemClick(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1);   // helper to open popup when clicked on last item. Default to ImGuiPopupFlags_MouseButtonRight == 1. (note: actually triggers on the mouse _released_ event to be consistent with popup behaviors)
    IMGUI_API void          CloseCurrentPopup();                                                                // manually close the popup we have begin-ed into.

    // Popups: open+begin combined functions helpers
    //  - Helpers to do OpenPopup+BeginPopup where the Open action is triggered by e.g. hovering an item and right-clicking.
    //  - They are convenient to easily create context menus, hence the name.
    //  - IMPORTANT: Notice that BeginPopupContextXXX takes ImGuiPopupFlags just like OpenPopup() and unlike BeginPopup(). For full consistency, we may add ImGuiWindowFlags to the BeginPopupContextXXX functions in the future.
    //  - IMPORTANT: Notice that we exceptionally default their flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter, so if you add other flags remember to re-add the ImGuiPopupFlags_MouseButtonRight.
    IMGUI_API bool          BeginPopupContextItem(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1);  // open+begin popup when clicked on last item. Use str_id==NULL to associate the popup to previous item. If you want to use that on a non-interactive item such as Text() you need to pass in an explicit ID here. read comments in .cpp!
    IMGUI_API bool          BeginPopupContextWindow(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1);// open+begin popup when clicked on current window.
    IMGUI_API bool          BeginPopupContextVoid(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1);  // open+begin popup when clicked in void (where there are no windows).

    // Popups: query functions
    //  - IsPopupOpen(): return true if the popup is open at the current BeginPopup() level of the popup stack.
    //  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId: return true if any popup is open at the current BeginPopup() level of the popup stack.
    //  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId + ImGuiPopupFlags_AnyPopupLevel: return true if any popup is open.
    IMGUI_API bool          IsPopupOpen(const char* str_id, ImGuiPopupFlags flags = 0);                         // return true if the popup is open.

    // Tables
    // - Full-featured replacement for old Columns API.
    // - See Demo->Tables for demo code. See top of imgui_tables.cpp for general commentary.
    // - See ImGuiTableFlags_ and ImGuiTableColumnFlags_ enums for a description of available flags.
    // The typical call flow is:
    // - 1. Call BeginTable(), early out if returning false.
    // - 2. Optionally call TableSetupColumn() to submit column name/flags/defaults.
    // - 3. Optionally call TableSetupScrollFreeze() to request scroll freezing of columns/rows.
    // - 4. Optionally call TableHeadersRow() to submit a header row. Names are pulled from TableSetupColumn() data.
    // - 5. Populate contents:
    //    - In most situations you can use TableNextRow() + TableSetColumnIndex(N) to start appending into a column.
    //    - If you are using tables as a sort of grid, where every column is holding the same type of contents,
    //      you may prefer using TableNextColumn() instead of TableNextRow() + TableSetColumnIndex().
    //      TableNextColumn() will automatically wrap-around into the next row if needed.
    //    - IMPORTANT: Comparatively to the old Columns() API, we need to call TableNextColumn() for the first column!
    //    - Summary of possible call flow:
    //        - TableNextRow() -> TableSetColumnIndex(0) -> Text("Hello 0") -> TableSetColumnIndex(1) -> Text("Hello 1")  // OK
    //        - TableNextRow() -> TableNextColumn()      -> Text("Hello 0") -> TableNextColumn()      -> Text("Hello 1")  // OK
    //        -                   TableNextColumn()      -> Text("Hello 0") -> TableNextColumn()      -> Text("Hello 1")  // OK: TableNextColumn() automatically gets to next row!
    //        - TableNextRow()                           -> Text("Hello 0")                                               // Not OK! Missing TableSetColumnIndex() or TableNextColumn()! Text will not appear!
    // - 5. Call EndTable()
    IMGUI_API bool          BeginTable(const char* str_id, int column, ImGuiTableFlags flags = 0, const ImVec2& outer_size = ImVec2(0.0f, 0.0f), float inner_width = 0.0f);
    IMGUI_API void          EndTable();                                         // only call EndTable() if BeginTable() returns true!
    IMGUI_API void          TableNextRow(ImGuiTableRowFlags row_flags = 0, float min_row_height = 0.0f); // append into the first cell of a new row.
    IMGUI_API bool          TableNextColumn();                                  // append into the next column (or first column of next row if currently in last column). Return true when column is visible.
    IMGUI_API bool          TableSetColumnIndex(int column_n);                  // append into the specified column. Return true when column is visible.

    // Tables: Headers & Columns declaration
    // - Use TableSetupColumn() to specify label, resizing policy, default width/weight, id, various other flags etc.
    // - Use TableHeadersRow() to create a header row and automatically submit a TableHeader() for each column.
    //   Headers are required to perform: reordering, sorting, and opening the context menu.
    //   The context menu can also be made available in columns body using ImGuiTableFlags_ContextMenuInBody.
    // - You may manually submit headers using TableNextRow() + TableHeader() calls, but this is only useful in
    //   some advanced use cases (e.g. adding custom widgets in header row).
    // - Use TableSetupScrollFreeze() to lock columns/rows so they stay visible when scrolled.
    IMGUI_API void          TableSetupColumn(const char* label, ImGuiTableColumnFlags flags = 0, float init_width_or_weight = 0.0f, ImGuiID user_id = 0);
    IMGUI_API void          TableSetupScrollFreeze(int cols, int rows);         // lock columns/rows so they stay visible when scrolled.
    IMGUI_API void          TableHeader(const char* label);                     // submit one header cell manually (rarely used)
    IMGUI_API void          TableHeadersRow();                                  // submit a row with headers cells based on data provided to TableSetupColumn() + submit context menu
    IMGUI_API void          TableAngledHeadersRow();                            // submit a row with angled headers for every column with the ImGuiTableColumnFlags_AngledHeader flag. MUST BE FIRST ROW.

    // Tables: Sorting & Miscellaneous functions
    // - Sorting: call TableGetSortSpecs() to retrieve latest sort specs for the table. NULL when not sorting.
    //   When 'sort_specs->SpecsDirty == true' you should sort your data. It will be true when sorting specs have
    //   changed since last call, or the first time. Make sure to set 'SpecsDirty = false' after sorting,
    //   else you may wastefully sort your data every frame!
    // - Functions args 'int column_n' treat the default value of -1 as the same as passing the current column index.
    IMGUI_API ImGuiTableSortSpecs*  TableGetSortSpecs();                        // get latest sort specs for the table (NULL if not sorting).  Lifetime: don't hold on this pointer over multiple frames or past any subsequent call to BeginTable().
    IMGUI_API int                   TableGetColumnCount();                      // return number of columns (value passed to BeginTable)
    IMGUI_API int                   TableGetColumnIndex();                      // return current column index.
    IMGUI_API int                   TableGetRowIndex();                         // return current row index.
    IMGUI_API const char*           TableGetColumnName(int column_n = -1);      // return "" if column didn't have a name declared by TableSetupColumn(). Pass -1 to use current column.
    IMGUI_API ImGuiTableColumnFlags TableGetColumnFlags(int column_n = -1);     // return column flags so you can query their Enabled/Visible/Sorted/Hovered status flags. Pass -1 to use current column.
    IMGUI_API void                  TableSetColumnEnabled(int column_n, bool v);// change user accessible enabled/disabled state of a column. Set to false to hide the column. User can use the context menu to change this themselves (right-click in headers, or right-click in columns body with ImGuiTableFlags_ContextMenuInBody)
    IMGUI_API void                  TableSetBgColor(ImGuiTableBgTarget target, ImU32 color, int column_n = -1);  // change the color of a cell, row, or column. See ImGuiTableBgTarget_ flags for details.

    // Legacy Columns API (prefer using Tables!)
    // - You can also use SameLine(pos_x) to mimic simplified columns.
    IMGUI_API void          Columns(int count = 1, const char* id = NULL, bool border = true);
    IMGUI_API void          NextColumn();                                                       // next column, defaults to current row or next row if the current row is finished
    IMGUI_API int           GetColumnIndex();                                                   // get current column index
    IMGUI_API float         GetColumnWidth(int column_index = -1);                              // get column width (in pixels). pass -1 to use current column
    IMGUI_API void          SetColumnWidth(int column_index, float width);                      // set column width (in pixels). pass -1 to use current column
    IMGUI_API float         GetColumnOffset(int column_index = -1);                             // get position of column line (in pixels, from the left side of the contents region). pass -1 to use current column, otherwise 0..GetColumnsCount() inclusive. column 0 is typically 0.0f
    IMGUI_API void          SetColumnOffset(int column_index, float offset_x);                  // set position of column line (in pixels, from the left side of the contents region). pass -1 to use current column
    IMGUI_API int           GetColumnsCount();

    // Tab Bars, Tabs
    // - Note: Tabs are automatically created by the docking system (when in 'docking' branch). Use this to create tab bars/tabs yourself.
    IMGUI_API bool          BeginTabBar(const char* str_id, ImGuiTabBarFlags flags = 0);        // create and append into a TabBar
    IMGUI_API void          EndTabBar();                                                        // only call EndTabBar() if BeginTabBar() returns true!
    IMGUI_API bool          BeginTabItem(const char* label, bool* p_open = NULL, ImGuiTabItemFlags flags = 0); // create a Tab. Returns true if the Tab is selected.
    IMGUI_API void          EndTabItem();                                                       // only call EndTabItem() if BeginTabItem() returns true!
    IMGUI_API bool          TabItemButton(const char* label, ImGuiTabItemFlags flags = 0);      // create a Tab behaving like a button. return true when clicked. cannot be selected in the tab bar.
    IMGUI_API void          SetTabItemClosed(const char* tab_or_docked_window_label);           // notify TabBar or Docking system of a closed tab/window ahead (useful to reduce visual flicker on reorderable tab bars). For tab-bar: call after BeginTabBar() and before Tab submissions. Otherwise call with a window name.

    // Logging/Capture
    // - All text output from the interface can be captured into tty/file/clipboard. By default, tree nodes are automatically opened during logging.
    IMGUI_API void          LogToTTY(int auto_open_depth = -1);                                 // start logging to tty (stdout)
    IMGUI_API void          LogToFile(int auto_open_depth = -1, const char* filename = NULL);   // start logging to file
    IMGUI_API void          LogToClipboard(int auto_open_depth = -1);                           // start logging to OS clipboard
    IMGUI_API void          LogFinish();                                                        // stop logging (close file, etc.)
    IMGUI_API void          LogButtons();                                                       // helper to display buttons for logging to tty/file/clipboard
    IMGUI_API void          LogText(const char* fmt, ...) IM_FMTARGS(1);                        // pass text data straight to log (without being displayed)
    IMGUI_API void          LogTextV(const char* fmt, va_list args) IM_FMTLIST(1);

    // Drag and Drop
    // - On source items, call BeginDragDropSource(), if it returns true also call SetDragDropPayload() + EndDragDropSource().
    // - On target candidates, call BeginDragDropTarget(), if it returns true also call AcceptDragDropPayload() + EndDragDropTarget().
    // - If you stop calling BeginDragDropSource() the payload is preserved however it won't have a preview tooltip (we currently display a fallback "..." tooltip, see #1725)
    // - An item can be both drag source and drop target.
    IMGUI_API bool          BeginDragDropSource(ImGuiDragDropFlags flags = 0);                                      // call after submitting an item which may be dragged. when this return true, you can call SetDragDropPayload() + EndDragDropSource()
    IMGUI_API bool          SetDragDropPayload(const char* type, const void* data, size_t sz, ImGuiCond cond = 0);  // type is a user defined string of maximum 32 characters. Strings starting with '_' are reserved for dear imgui internal types. Data is copied and held by imgui. Return true when payload has been accepted.
    IMGUI_API void          EndDragDropSource();                                                                    // only call EndDragDropSource() if BeginDragDropSource() returns true!
    IMGUI_API bool                  BeginDragDropTarget();                                                          // call after submitting an item that may receive a payload. If this returns true, you can call AcceptDragDropPayload() + EndDragDropTarget()
    IMGUI_API const ImGuiPayload*   AcceptDragDropPayload(const char* type, ImGuiDragDropFlags flags = 0);          // accept contents of a given type. If ImGuiDragDropFlags_AcceptBeforeDelivery is set you can peek into the payload before the mouse button is released.
    IMGUI_API void                  EndDragDropTarget();                                                            // only call EndDragDropTarget() if BeginDragDropTarget() returns true!
    IMGUI_API const ImGuiPayload*   GetDragDropPayload();                                                           // peek directly into the current payload from anywhere. returns NULL when drag and drop is finished or inactive. use ImGuiPayload::IsDataType() to test for the payload type.

    // Disabling [BETA API]
    // - Disable all user interactions and dim items visuals (applying style.DisabledAlpha over current colors)
    // - Those can be nested but it cannot be used to enable an already disabled section (a single BeginDisabled(true) in the stack is enough to keep everything disabled)
    // - BeginDisabled(false) essentially does nothing useful but is provided to facilitate use of boolean expressions. If you can avoid calling BeginDisabled(False)/EndDisabled() best to avoid it.
    IMGUI_API void          BeginDisabled(bool disabled = true);
    IMGUI_API void          EndDisabled();

    // Clipping
    // - Mouse hovering is affected by ImGui::PushClipRect() calls, unlike direct calls to ImDrawList::PushClipRect() which are render only.
    IMGUI_API void          PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect);
    IMGUI_API void          PopClipRect();

    // Focus, Activation
    // - Prefer using "SetItemDefaultFocus()" over "if (IsWindowAppearing()) SetScrollHereY()" when applicable to signify "this is the default item"
    IMGUI_API void          SetItemDefaultFocus();                                              // make last item the default focused item of a window.
    IMGUI_API void          SetKeyboardFocusHere(int offset = 0);                               // focus keyboard on the next widget. Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.

    // Overlapping mode
    IMGUI_API void          SetNextItemAllowOverlap();                                          // allow next item to be overlapped by a subsequent item. Useful with invisible buttons, selectable, treenode covering an area where subsequent items may need to be added. Note that both Selectable() and TreeNode() have dedicated flags doing this.

    // Item/Widgets Utilities and Query Functions
    // - Most of the functions are referring to the previous Item that has been submitted.
    // - See Demo Window under "Widgets->Querying Status" for an interactive visualization of most of those functions.
    IMGUI_API bool          IsItemHovered(ImGuiHoveredFlags flags = 0);                         // is the last item hovered? (and usable, aka not blocked by a popup, etc.). See ImGuiHoveredFlags for more options.
    IMGUI_API bool          IsItemActive();                                                     // is the last item active? (e.g. button being held, text field being edited. This will continuously return true while holding mouse button on an item. Items that don't interact will always return false)
    IMGUI_API bool          IsItemFocused();                                                    // is the last item focused for keyboard/gamepad navigation?
    IMGUI_API bool          IsItemClicked(ImGuiMouseButton mouse_button = 0);                   // is the last item hovered and mouse clicked on? (**)  == IsMouseClicked(mouse_button) && IsItemHovered()Important. (**) this is NOT equivalent to the behavior of e.g. Button(). Read comments in function definition.
    IMGUI_API bool          IsItemVisible();                                                    // is the last item visible? (items may be out of sight because of clipping/scrolling)
    IMGUI_API bool          IsItemEdited();                                                     // did the last item modify its underlying value this frame? or was pressed? This is generally the same as the "bool" return value of many widgets.
    IMGUI_API bool          IsItemActivated();                                                  // was the last item just made active (item was previously inactive).
    IMGUI_API bool          IsItemDeactivated();                                                // was the last item just made inactive (item was previously active). Useful for Undo/Redo patterns with widgets that require continuous editing.
    IMGUI_API bool          IsItemDeactivatedAfterEdit();                                       // was the last item just made inactive and made a value change when it was active? (e.g. Slider/Drag moved). Useful for Undo/Redo patterns with widgets that require continuous editing. Note that you may get false positives (some widgets such as Combo()/ListBox()/Selectable() will return true even when clicking an already selected item).
    IMGUI_API bool          IsItemToggledOpen();                                                // was the last item open state toggled? set by TreeNode().
    IMGUI_API bool          IsAnyItemHovered();                                                 // is any item hovered?
    IMGUI_API bool          IsAnyItemActive();                                                  // is any item active?
    IMGUI_API bool          IsAnyItemFocused();                                                 // is any item focused?
    IMGUI_API ImGuiID       GetItemID();                                                        // get ID of last item (~~ often same ImGui::GetID(label) beforehand)
    IMGUI_API ImVec2        GetItemRectMin();                                                   // get upper-left bounding rectangle of the last item (screen space)
    IMGUI_API ImVec2        GetItemRectMax();                                                   // get lower-right bounding rectangle of the last item (screen space)
    IMGUI_API ImVec2        GetItemRectSize();                                                  // get size of last item

    // Viewports
    // - Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
    // - In 'docking' branch with multi-viewport enabled, we extend this concept to have multiple active viewports.
    // - In the future we will extend this concept further to also represent Platform Monitor and support a "no main platform window" operation mode.
    IMGUI_API ImGuiViewport* GetMainViewport();                                                 // return primary/default viewport. This can never be NULL.

    // Background/Foreground Draw Lists
    IMGUI_API ImDrawList*   GetBackgroundDrawList();                                            // this draw list will be the first rendered one. Useful to quickly draw shapes/text behind dear imgui contents.
    IMGUI_API ImDrawList*   GetForegroundDrawList();                                            // this draw list will be the last rendered one. Useful to quickly draw shapes/text over dear imgui contents.

    // Miscellaneous Utilities
    IMGUI_API bool          IsRectVisible(const ImVec2& size);                                  // test if rectangle (of given size, starting from cursor position) is visible / not clipped.
    IMGUI_API bool          IsRectVisible(const ImVec2& rect_min, const ImVec2& rect_max);      // test if rectangle (in screen space) is visible / not clipped. to perform coarse clipping on user's side.
    IMGUI_API double        GetTime();                                                          // get global imgui time. incremented by io.DeltaTime every frame.
    IMGUI_API int           GetFrameCount();                                                    // get global imgui frame count. incremented by 1 every frame.
    IMGUI_API ImDrawListSharedData* GetDrawListSharedData();                                    // you may use this when creating your own ImDrawList instances.
    IMGUI_API const char*   GetStyleColorName(ImGuiCol idx);                                    // get a string corresponding to the enum value (for display, saving, etc.).
    IMGUI_API void          SetStateStorage(ImGuiStorage* storage);                             // replace current window storage with our own (if you want to manipulate it yourself, typically clear subsection of it)
    IMGUI_API ImGuiStorage* GetStateStorage();

    // Text Utilities
    IMGUI_API ImVec2        CalcTextSize(const char* text, const char* text_end = NULL, bool hide_text_after_double_hash = false, float wrap_width = -1.0f);

    // Color Utilities
    IMGUI_API ImVec4        ColorConvertU32ToFloat4(ImU32 in);
    IMGUI_API ImU32         ColorConvertFloat4ToU32(const ImVec4& in);
    IMGUI_API void          ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v);
    IMGUI_API void          ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b);

    // Inputs Utilities: Keyboard/Mouse/Gamepad
    // - the ImGuiKey enum contains all possible keyboard, mouse and gamepad inputs (e.g. ImGuiKey_A, ImGuiKey_MouseLeft, ImGuiKey_GamepadDpadUp...).
    // - before v1.87, we used ImGuiKey to carry native/user indices as defined by each backends. About use of those legacy ImGuiKey values:
    //  - without IMGUI_DISABLE_OBSOLETE_KEYIO (legacy support): you can still use your legacy native/user indices (< 512) according to how your backend/engine stored them in io.KeysDown[], but need to cast them to ImGuiKey.
    //  - with    IMGUI_DISABLE_OBSOLETE_KEYIO (this is the way forward): any use of ImGuiKey will assert with key < 512. GetKeyIndex() is pass-through and therefore deprecated (gone if IMGUI_DISABLE_OBSOLETE_KEYIO is defined).
    IMGUI_API bool          IsKeyDown(ImGuiKey key);                                            // is key being held.
    IMGUI_API bool          IsKeyPressed(ImGuiKey key, bool repeat = true);                     // was key pressed (went from !Down to Down)? if repeat=true, uses io.KeyRepeatDelay / KeyRepeatRate
    IMGUI_API bool          IsKeyReleased(ImGuiKey key);                                        // was key released (went from Down to !Down)?
    IMGUI_API bool          IsKeyChordPressed(ImGuiKeyChord key_chord);                         // was key chord (mods + key) pressed, e.g. you can pass 'ImGuiMod_Ctrl | ImGuiKey_S' as a key-chord. This doesn't do any routing or focus check, please consider using Shortcut() function instead.
    IMGUI_API int           GetKeyPressedAmount(ImGuiKey key, float repeat_delay, float rate);  // uses provided repeat rate/delay. return a count, most often 0 or 1 but might be >1 if RepeatRate is small enough that DeltaTime > RepeatRate
    IMGUI_API const char*   GetKeyName(ImGuiKey key);                                           // [DEBUG] returns English name of the key. Those names a provided for debugging purpose and are not meant to be saved persistently not compared.
    IMGUI_API void          SetNextFrameWantCaptureKeyboard(bool want_capture_keyboard);        // Override io.WantCaptureKeyboard flag next frame (said flag is left for your application to handle, typically when true it instructs your app to ignore inputs). e.g. force capture keyboard when your widget is being hovered. This is equivalent to setting "io.WantCaptureKeyboard = want_capture_keyboard"; after the next NewFrame() call.

    // Inputs Utilities: Mouse specific
    // - To refer to a mouse button, you may use named enums in your code e.g. ImGuiMouseButton_Left, ImGuiMouseButton_Right.
    // - You can also use regular integer: it is forever guaranteed that 0=Left, 1=Right, 2=Middle.
    // - Dragging operations are only reported after mouse has moved a certain distance away from the initial clicking position (see 'lock_threshold' and 'io.MouseDraggingThreshold')
    IMGUI_API bool          IsMouseDown(ImGuiMouseButton button);                               // is mouse button held?
    IMGUI_API bool          IsMouseClicked(ImGuiMouseButton button, bool repeat = false);       // did mouse button clicked? (went from !Down to Down). Same as GetMouseClickedCount() == 1.
    IMGUI_API bool          IsMouseReleased(ImGuiMouseButton button);                           // did mouse button released? (went from Down to !Down)
    IMGUI_API bool          IsMouseDoubleClicked(ImGuiMouseButton button);                      // did mouse button double-clicked? Same as GetMouseClickedCount() == 2. (note that a double-click will also report IsMouseClicked() == true)
    IMGUI_API int           GetMouseClickedCount(ImGuiMouseButton button);                      // return the number of successive mouse-clicks at the time where a click happen (otherwise 0).
    IMGUI_API bool          IsMouseHoveringRect(const ImVec2& r_min, const ImVec2& r_max, bool clip = true);// is mouse hovering given bounding rect (in screen space). clipped by current clipping settings, but disregarding of other consideration of focus/window ordering/popup-block.
    IMGUI_API bool          IsMousePosValid(const ImVec2* mouse_pos = NULL);                    // by convention we use (-FLT_MAX,-FLT_MAX) to denote that there is no mouse available
    IMGUI_API bool          IsAnyMouseDown();                                                   // [WILL OBSOLETE] is any mouse button held? This was designed for backends, but prefer having backend maintain a mask of held mouse buttons, because upcoming input queue system will make this invalid.
    IMGUI_API ImVec2        GetMousePos();                                                      // shortcut to ImGui::GetIO().MousePos provided by user, to be consistent with other calls
    IMGUI_API ImVec2        GetMousePosOnOpeningCurrentPopup();                                 // retrieve mouse position at the time of opening popup we have BeginPopup() into (helper to avoid user backing that value themselves)
    IMGUI_API bool          IsMouseDragging(ImGuiMouseButton button, float lock_threshold = -1.0f);         // is mouse dragging? (if lock_threshold < -1.0f, uses io.MouseDraggingThreshold)
    IMGUI_API ImVec2        GetMouseDragDelta(ImGuiMouseButton button = 0, float lock_threshold = -1.0f);   // return the delta from the initial clicking position while the mouse button is pressed or was just released. This is locked and return 0.0f until the mouse moves past a distance threshold at least once (if lock_threshold < -1.0f, uses io.MouseDraggingThreshold)
    IMGUI_API void          ResetMouseDragDelta(ImGuiMouseButton button = 0);                   //
    IMGUI_API ImGuiMouseCursor GetMouseCursor();                                                // get desired mouse cursor shape. Important: reset in ImGui::NewFrame(), this is updated during the frame. valid before Render(). If you use software rendering by setting io.MouseDrawCursor ImGui will render those for you
    IMGUI_API void          SetMouseCursor(ImGuiMouseCursor cursor_type);                       // set desired mouse cursor shape
    IMGUI_API void          SetNextFrameWantCaptureMouse(bool want_capture_mouse);              // Override io.WantCaptureMouse flag next frame (said flag is left for your application to handle, typical when true it instucts your app to ignore inputs). This is equivalent to setting "io.WantCaptureMouse = want_capture_mouse;" after the next NewFrame() call.

    // Clipboard Utilities
    // - Also see the LogToClipboard() function to capture GUI into clipboard, or easily output text data to the clipboard.
    IMGUI_API const char*   GetClipboardText();
    IMGUI_API void          SetClipboardText(const char* text);

    // Settings/.Ini Utilities
    // - The disk functions are automatically called if io.IniFilename != NULL (default is "imgui.ini").
    // - Set io.IniFilename to NULL to load/save manually. Read io.WantSaveIniSettings description about handling .ini saving manually.
    // - Important: default value "imgui.ini" is relative to current working dir! Most apps will want to lock this to an absolute path (e.g. same path as executables).
    IMGUI_API void          LoadIniSettingsFromDisk(const char* ini_filename);                  // call after CreateContext() and before the first call to NewFrame(). NewFrame() automatically calls LoadIniSettingsFromDisk(io.IniFilename).
    IMGUI_API void          LoadIniSettingsFromMemory(const char* ini_data, size_t ini_size=0); // call after CreateContext() and before the first call to NewFrame() to provide .ini data from your own data source.
    IMGUI_API void          SaveIniSettingsToDisk(const char* ini_filename);                    // this is automatically called (if io.IniFilename is not empty) a few seconds after any modification that should be reflected in the .ini file (and also by DestroyContext).
    IMGUI_API const char*   SaveIniSettingsToMemory(size_t* out_ini_size = NULL);               // return a zero-terminated string with the .ini data which you can save by your own mean. call when io.WantSaveIniSettings is set, then save data by your own mean and clear io.WantSaveIniSettings.

    // Debug Utilities
    // - Your main debugging friend is the ShowMetricsWindow() function, which is also accessible from Demo->Tools->Metrics Debugger
    IMGUI_API void          DebugTextEncoding(const char* text);
    IMGUI_API void          DebugFlashStyleColor(ImGuiCol idx);
    IMGUI_API void          DebugStartItemPicker();
    IMGUI_API bool          DebugCheckVersionAndDataLayout(const char* version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert, size_t sz_drawidx); // This is called by IMGUI_CHECKVERSION() macro.

    // Memory Allocators
    // - Those functions are not reliant on the current context.
    // - DLL users: heaps and globals are not shared across DLL boundaries! You will need to call SetCurrentContext() + SetAllocatorFunctions()
    //   for each static/DLL boundary you are calling from. Read "Context and Memory Allocators" section of imgui.cpp for more details.
    IMGUI_API void          SetAllocatorFunctions(ImGuiMemAllocFunc alloc_func, ImGuiMemFreeFunc free_func, void* user_data = NULL);
    IMGUI_API void          GetAllocatorFunctions(ImGuiMemAllocFunc* p_alloc_func, ImGuiMemFreeFunc* p_free_func, void** p_user_data);
    IMGUI_API void*         MemAlloc(size_t size);
    IMGUI_API void          MemFree(void* ptr);

} // namespace ImGui
```

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
