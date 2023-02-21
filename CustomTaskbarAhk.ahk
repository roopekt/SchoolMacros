#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

python := "C:\Program Files\Python39\pythonw.exe"
openAppWidgetScript := "C:\Users\gr263947\OneDrive - Jyväskylän koulutuskuntayhtymä Gradia\Ahk\OpenAppWidget\dist\bin\bin.exe"

#CapsLock::Run "%openAppWidgetScript%"

; activate indexth app on taskbar
ActivateApp(index){
    Send #t
    Send {Right %index%}
    Send {Enter}
}

#1::ActivateApp(0)
#2::ActivateApp(1)
#3::ActivateApp(2)
#4::ActivateApp(3)
#5::ActivateApp(4)
#6::ActivateApp(5)
#7::ActivateApp(6)
#8::ActivateApp(7)
#9::ActivateApp(8)
#0::ActivateApp(10)

#+::
    WinGet, path, ProcessPath, A
    Run "%openAppWidgetScript%" -AddApp "%path%"
return