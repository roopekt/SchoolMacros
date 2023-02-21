#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run LaTexKeyboard.ahk
Run UnicodeKeyboard.ahk
Run SpecialPaste.ahk

; alt + W :: activate Holmes
!W::
    Send {F6} ; select url tab
    Send {+Home}{BackSpace 3} ; remove contents of the url tab
    Send *{Tab} ; activate holmes
return

; ctrl + shift + W :: replace Chrome tab with new tab
^+W::
    Send !t ; new tab to the right (depends on 'duplicate tab shortcut' extension)
    Sleep, 50
    Send ^+{Tab} ; switch back to the previous tab
    Sleep, 50
    Send ^w ; delete the tab & swicth to the right tab
return

; Alt + H => hybernate (with confirmation dialog)
!H::
    MsgBox, 4 ,, Hybernate?
    IfMsgBox Yes
        DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
return

; go to first tab of Chrome
!x::
    winactivate, ahk_exe chrome.exe
    ; winwaitactive, ahk_exe chrome.exe

    loop, 100 {
        Send ^1 ; go to first tab
        Sleep 10
    }
return