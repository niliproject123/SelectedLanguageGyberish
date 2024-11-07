#SingleInstance Force

; Get layouts once at startup
layoutList := GetInstalledLayouts()

TrayTip "Switch using 'ctrl+'' or 'ctrl+right click' ", "Language Swithcing"
A_IconTip := "Language Converter Active"
A_TrayMenu.Rename("1&", "Language Converter")  ; Changes default first menu item

ConvertSelectedTextToLayout(fromLayout, toLayout) {
   selectedText := GetSelectedText()
   if (selectedText = "")
       return
   convertedText := ConvertText(selectedText, fromLayout, toLayout)
   ReplaceSelectedText(convertedText)
}

GetNextLayout(currentID) {
   currentIndex := 0
   for index, layout in layoutList {
       if (layout = currentID) {
           currentIndex := index
           break
       }
   }
   
   nextIndex := currentIndex = layoutList.Length ? 1 : currentIndex + 1
   return layoutList[nextIndex]
}

MenuHandler(currentID, nextLayout) {
   ConvertSelectedTextToLayout(currentID, nextLayout)
}

~^RButton up::
{
    currentID := GetCurrentLayout()
    nextLayout := GetNextLayout(currentID)
    nextLanguage := languageNames.Has(nextLayout) ? languageNames[nextLayout] : "unknown language"

    ; Create context menu
    myMenu := Menu()
    myMenu.Add("Switch to " nextLanguage, (*) => MenuHandler(currentID, nextLayout))
    MouseGetPos(&mouseX, &mouseY)
    myMenu.Show(mouseX, mouseY)
}

~^'::
{
   currentID := GetCurrentLayout()
   nextLayout := GetNextLayout(currentID)
   ConvertSelectedTextToLayout(currentID, nextLayout)
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

GetSelectedText() {
   oldClip := A_Clipboard
   A_Clipboard := ""
   Send "^c"
   if !ClipWait(0.1)
       return ""
   selectedText := A_Clipboard
   A_Clipboard := oldClip
   return selectedText
}

ConvertText(text, fromLayout, toLayout) {
   ; Check if layouts are supported
   if (!keyMaps.Has(fromLayout) || !keyMaps.Has(toLayout)) {
       TrayTip "Language not supported", "Current or target language is not supported", 4
       return text
   }

   convertedText := ""
   loop parse text {
       char := A_LoopField
       englishKey := ""

       ; Get English key position for this character
       for srcChar, engPos in keyMaps[fromLayout] {
           if (srcChar = char) {
               englishKey := engPos
               break
           }
       }

       ; Find character in target layout at this position
       if (englishKey) {
           for tgtChar, engPos in keyMaps[toLayout] {
               if (engPos = englishKey) {
                   convertedText .= tgtChar
                   break
               }
           }
       } else {
           convertedText .= char  ; Keep original if no mapping found
       }
   }
   return convertedText
}

ReplaceSelectedText(newText) {
   oldClip := A_Clipboard
   A_Clipboard := newText
   Send "^v"
   Sleep 50
   A_Clipboard := oldClip
}

languageNames := Map(
    "0409", "English",
    "040d", "Hebrew",
    "0419", "Russian",
    "0401", "Arabic"
 )
 
 keyMaps := Map(
    "0409", Map(  ; English -> English positions
        "a", "a", "b", "b", "c", "c", "d", "d", "e", "e", "f", "f", "g", "g",
        "h", "h", "i", "i", "j", "j", "k", "k", "l", "l", "m", "m", "n", "n",
        "o", "o", "p", "p", "q", "q", "r", "r", "s", "s", "t", "t", "u", "u",
        "v", "v", "w", "w", "x", "x", "y", "y", "z", "z",
        ";", ";", "'", "'", ",", ",", ".", ".", "/", "/"
    ),
    "040d", Map(  ; Hebrew -> English positions
        "ש", "a", "נ", "b", "ב", "c", "ג", "d", "ק", "e", "כ", "f", "ע", "g",
        "י", "h", "ן", "i", "ח", "j", "ל", "k", "ך", "l", "צ", "m", "מ", "n",
        "ם", "o", "פ", "p", "/", "q", "ר", "r", "ד", "s", "א", "t", "ו", "u",
        "ה", "v", "'", "w", "ס", "x", "ט", "y", "ז", "z",
        "ף", ";", ",", "'", "ת", ",", "ץ", ".", ".", "/"
    ),
    "0419", Map(  ; Russian -> English positions
        "ф", "a", "и", "b", "с", "c", "в", "d", "у", "e", "а", "f", "п", "g",
        "р", "h", "ш", "i", "о", "j", "л", "k", "д", "l", "ь", "m", "т", "n",
        "щ", "o", "з", "p", "й", "q", "к", "r", "ы", "s", "е", "t", "г", "u",
        "м", "v", "ц", "w", "ч", "x", "н", "y", "я", "z",
        "ж", ";", "э", "'", "б", ",", "ю", ".", ".", "/"
    ),
    "0401", Map(  ; Arabic -> English positions
        "ا", "a", "لا", "b", "ؤ", "c", "ي", "d", "ث", "e", "ب", "f", "ل", "g",
        "ا", "h", "ه", "i", "ت", "j", "ن", "k", "م", "l", "ة", "m", "ى", "n",
        "خ", "o", "ح", "p", "ض", "q", "ق", "r", "س", "s", "ف", "t", "ع", "u",
        "ر", "v", "ص", "w", "ء", "x", "غ", "y", "ئ", "z",
        "ك", ";", "ط", "'", "و", ",", "ز", ".", "ظ", "/"
    )
 )