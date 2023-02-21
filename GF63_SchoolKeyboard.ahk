#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run SchoolKeyboard.ahk

; print screen key => Win + Shift + S (Snip & Sketch)
PrintScreen::#+S

; calculator key => open or activate speedcrunch
Launch_App2::
If WinExist("ahk_exe speedcrunch.exe")
	WinActivate ; activate the window found by WinExist
else
	Run, D:\Programs\SpeedCrunch\speedcrunch.exe
return