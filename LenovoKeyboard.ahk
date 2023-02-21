#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run SchoolKeyboard.ahk
; Run CustomTaskbarAhk.ahk

; remap FN to left control.
; with lenovo's 'swicth fn and control keys' this applies to the left physical control key (labeled as 'Ctrl')
SC163::LControl

; Alt + L => got to sleep (suspend)
; docs for the dll-call: https://www.autohotkey.com/docs/commands/Shutdown.htm
!L::DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)

WaitClipboardChange(original) {
    dt = 50
    maxTime = 300
    time = 0
    while (Clipboard != original && time < maxTime) {
        Sleep dt
        time += dt
    }
}

+^C::
    orig := Clipboard
    Send ^C
    WaitClipboardChange(orig)
    Clipboard := Clipboard ; remove formatting
return