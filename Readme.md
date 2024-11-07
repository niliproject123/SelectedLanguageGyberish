# Language Tools for Windows
You know how you write something and you've think you're on English keyboard, whern you are Hebrew Keyboard?
And you wrote gyberish?
Two Utilities to help with that:

## 1. Text Converter
Converts text between keyboard layouts when typed in the wrong language.

### Usage
- Run `TextConverter.exe`
- Select text that was typed in wrong keyboard layout
- Press `Ctrl + Right Click` to show conversion menu
- OR press `Ctrl + '` to convert directly to next language
- Text will be replaced with the converted version

## 2. Language Indicator
A small colored letter near your cursor showing your current keyboard layout

### Usage
- Run `LanguageIndicator.exe`
- A small colored letter will follow your cursor
- Color and letter change automatically when you switch keyboard layouts

## Auto-Start Setup
To make tools run automatically when Windows starts:

1. Press `Win + R`
2. Type `shell:startup` and press Enter
3. Copy shortcuts of the .exe files to this folder

To disable auto-start:
1. Press `Win + R`
2. Type `shell:startup` and press Enter
3. Delete the shortcuts you don't want to auto-start

Alternatively, you can manage startup programs through Task Manager:
1. Open Task Manager (Ctrl + Shift + Esc)
2. Go to "Startup" tab
3. Enable/Disable the tools as needed

## Compilation Instructions

1. Install AutoHotkey v2.0 from [autohotkey.com](https://www.autohotkey.com/)

2. Open AutoHotkey Dash from Start Menu (search for "AutoHotkey")

3. Click on "Compile" from the left menu

4. In the Ahk2Exe window:
   - For "Source (script file)" - browse to your .ahk file
   - For "Destination (.exe file)" - choose where to save the exe
   - For "Base File (.bin, .exe)" - select "v2.0.18 U32 AutoHotkey32.exe" from dropdown
   - Click "Convert"

5. Repeat for both scripts:
   - `LanguageIndicator.ahk` → `LanguageIndicator.exe`
   - `TextConverter.ahk` → `TextConverter.exe`

Note: Make sure to select the v2 base file in the dropdown as shown in the image, otherwise compilation will fail.

## Requirements
- Windows 10/11
- Supported keyboard layouts installed (English, Hebrew, Russian, Arabic)

## Notes
- Both tools run independently - you can use either or both
- Tools can be closed from the system tray