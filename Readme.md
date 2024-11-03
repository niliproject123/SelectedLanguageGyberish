# Language Tools for Windows
You know how you write something and you've think you're on English keyboard, whern you are Hebrew Keyboard?
And you wrote gyberish?
Two Utilities to help with that:

## 1. Language Indicator
A small colored letter near your cursor showing your current keyboard layout

### Usage
- Run `LanguageIndicator.exe`
- A small colored letter will follow your cursor
- Color and letter change automatically when you switch keyboard layouts

## 2. Text Converter
Converts text between keyboard layouts when typed in the wrong language.

### Usage
- Run `TextConverter.exe`
- Select text that was typed in wrong keyboard layout
- Press `Ctrl + Right Click` to show conversion menu
- OR press `Ctrl + '` to convert directly to next language
- Text will be replaced with the converted version

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

## Requirements
- Windows 10/11
- Supported keyboard layouts installed (English, Hebrew, Russian, Arabic)

## Notes
- Both tools run independently - you can use either or both
- Tools can be closed from the system tray