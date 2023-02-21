#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; alt + down :: convert to lower case
RControl & Down::
    ConvertSelection("MakeLowerCase")
return

; alt + up :: convert to upper case
RControl & Up::                                   
    ConvertSelection("MakeUpperCase")
return

; alt + I :: convert to inverted case
!I::                         
    ConvertSelection("InvertCase")
return

ConvertSelection(conversionFunc) {
    originalClipboard := ClipboardAll
    Clipboard := ""
    Send ^c
    ClipWait, 1, 0
    selection := Clipboard
    Clipboard := originalClipboard

    selection := %conversionFunc%(selection)

    SendPlay %selection%
    len:= Strlen(selection)
    Send +{left %len%}
}

MakeUpperCase(s) {
    StringUpper s, s
    return s
}

MakeLowerCase(s) {
    StringLower s, s
    return s
}

InvertClipboardCase(s) {
    out := ""
    Loop % Strlen(s)
    {
        char := Substr(s, A_Index, 1)

        static szTChar := A_IsUnicode ? "UShort" : "UChar"
        isUpper := DllCall("IsCharUpper", szTChar, NumGet(char, 0, szTChar), "UInt")

        if isUpper
            StringLower, char, char
        else
            StringUpper, char, char

        out := out char
    }

    return out
}