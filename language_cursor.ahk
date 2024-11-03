#Requires AutoHotkey v2.0
TrayTip "Running", "Language Mouse Indicator"
A_IconTip := "Language Mouse Indicator Script Active"
A_TrayMenu.Rename("1&", "Language Mouse Indicator")  ; Changes default first menu item

; Global declarations first
global  letterMap := Map(
    "0409", "E",  ; English
    "0419", "R",  ; Russian
    "0401", "A",  ; Arabic
    "040d", "H",  ; Hebrew
)
global layoutColors := Map()  ; Will be accessible everywhere
global  colors := ["009900", "a300cc", "0000CC", "FF9900"]

Main()
; Keep script running
SetWinDelay -1
ProcessSetPriority "High"

Main() {
    InitLanguageSystem()
    global cursorGui := InitGui()

    SetTimer(UpdatePosition, 10)
    SetTimer(() => UpdateDotColor(cursorGui), 500)  ; Check language every 500ms
}


InitGui() {
    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    currentLang := GetCurrentLayout()
    dotColor := GetLayoutColor(currentLang)
    
    myGui.SetFont("s8 bold q3", "Arial")
    myGui.BackColor := "FFFFFF"
    myGui.textControl := myGui.Add("Text", "c" dotColor " Center w10 h12 x5 y5", GetLanguageLetter(currentLang)) 
    myGui.Show("AutoSize NoActivate")
    
    WinSetTransColor("FFFFFF", myGui)
    return myGui
}

UpdateDotColor(guiObj) {
    currentLang := GetCurrentLayout()
    dotColor := GetLayoutColor(currentLang)
    guiObj.textControl.Text := GetLanguageLetter(currentLang)
    guiObj.textControl.Opt("c0x" dotColor)
}

InitLanguageSystem() {


    layouts := GetInstalledLayouts()
    loop layouts.Length {
        if (A_Index > colors.Length)
            break
        layoutColors[StrLower(layouts[A_Index])] := colors[A_Index]
    }
}

; Then simplified color getter:
GetLayoutColor(layoutID) {
    layoutID := StrLower(layoutID)  ; Convert input to lowercase

    return layoutColors.Has(layoutID) ? layoutColors[layoutID] : "808080"  ; Gray for unmapped layouts
}

GetLanguageLetter(layoutID) {

    layoutID := StrLower(layoutID)  ; Convert input to lowercase
    return letterMap.Has(layoutID) ? letterMap[layoutID] : "?"
}

GetInstalledLayouts() {
    size := DllCall("GetKeyboardLayoutList", "UInt", 0, "Ptr", 0)
    layouts := Buffer(size * A_PtrSize, 0)
    DllCall("GetKeyboardLayoutList", "UInt", size, "Ptr", layouts)
    layoutList := []
    loop size {
        layout := NumGet(layouts, (A_Index - 1) * A_PtrSize, "Ptr")
        layoutID := SubStr(Format("0x{:x}", layout), -4)
        layoutList.Push(layoutID)
    }
    return layoutList
}

GetCurrentLayout() {
    ; Check if CapsLock is on - treat as English if it is
    if GetKeyState("CapsLock", "T")
        return "0409"    ; Return English layout code

    ; Otherwise get the actual keyboard layout
    hWnd := DllCall("GetForegroundWindow")
    threadId := DllCall("GetWindowThreadProcessId", "Ptr", hWnd, "Ptr", 0)
    currentLayout := DllCall("GetKeyboardLayout", "UInt", threadId)
    return SubStr(Format("0x{:x}", currentLayout), -4)
}

UpdatePosition() {
    CoordMode("Mouse", "Screen")  ; Ensure consistent coordinates
    MouseGetPos(&x, &y)
    cursorGui.Show(Format("x{} y{} NoActivate", x + 10, y + 10))
}

Log(msg) {
    FileAppend msg "`n", "debug_lang.txt"
}


InitGui_DOT() {
    dot := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")  ; Initialize as GUI
    currentLang := GetCurrentLayout()
    dotColor := GetLayoutColor(currentLang)

    dot.BackColor := "0x" dotColor
    dot.Show("w4 h4 NoActivate")
    return dot
}

UpdateDotColor_DOT(guiObj) {
    currentLang := GetCurrentLayout()
    guiObj.BackColor := "0x" GetLayoutColor(currentLang)
 }
 
 