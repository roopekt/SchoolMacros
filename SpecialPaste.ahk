#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; paste given text
SendByClipboard(text) {
    origClip := clipboard
    clipboard := text
    Send ^v
    Sleep 100
    clipboard := origClip
}

OtavamathToLatex(text) {
    text := RegExReplace(text, "^\)", "") ; remove ')' from start
    text := RegExReplace(text, "^[a-z]\)", "") ; remove e.g. 'a)' from start

    text := RegExReplace(text, "i)([a-z])(\d)", "$1^$2") ; e.g. 'x2' => 'x^2'
    text := RegExReplace(text, "\)(\d)", ")^$1") ; e.g. ')2' => ')^2'

    text := RegExReplace(text, "−", "-")

    return text
}

SanomaproChemistryToLatex(text) {
    text := RegExReplace(text, "i)([a-z])(\d)", "$1_$2") ; e.g. 'O2' => 'O_2'

    text := RegExReplace(text, "−", "-")
    text := RegExReplace(text, "→", "\rightarrow")

    return text
}

LatexToSpeedcrunch(text) {
    ; '\frac{x}{y}' => '{x}/{y}'
    StringReplace, text, text, }{, }/{, All
    StringReplace, text, text, \frac,, All

    text := MarkClosingMathrms(text)
    text := RegexReplaceFiltered(text, "U)@mathrm\{(.*)@mathrm\}", "ShortToLongUnits") ; '@mathrm{x@mathrm}' => with long units 'x'

    ; '\left[\begin{matrix}x\\y\end{matrix}\right]' (with some newlines) => '((x)+(y)j)'
    text := RegExReplace(text, "U)(\\left)?\[\\begin\{matrix\}\R?(.*)\R?\\\\\R?(.*)\R?\\end\{matrix\}(\\right)?\]", "(($2)+($3)j)")

    text := RegExReplace(text, "\\overline", "") ; '\overline{x}' => '{x}'
    text := RegExReplace(text, "\\bar", "") ; '\bar{x}' => '{x}'
    text := RegExReplace(text, "\\sqrt\[(.*)\]\{", "root{$1; ") ; '\sqrt[n]{x}' => 'root{n; x}'
    text := RegExReplace(text, "\\sqrt", "sqrt") ; '\sqrt{x}' => 'sqrt{x}'
    text := RegExReplace(text, "\\cdot", "*") ; '\cdot' => '*'
    text := RegExReplace(text, "\{,\}", ".") ; '{,}' => '.'
    text := RegExReplace(text, "\\%", "(.01)") ; '\%' => '(.01)'
    text := RegExReplace(text, "\\left", "") ; '\left{' => '{'
    text := RegExReplace(text, "\\right", "") ; '\right}' => '}'
    text := RegExReplace(text, "\\log ?_(.*)\(", "log($1; ") ; '\log_2(3)' => 'log(2; 3)'

    text := RegExReplace(text, "\\ ", "") ; '\ ' => ''
    text := RegExReplace(text, "\\", "") ; '\' => ''
    text := RegExReplace(text, "\{", "(") ; '{' => '('
    text := RegExReplace(text, "\}", ")") ; '}' => ')'
    text := RegExReplace(text, "m)^\((.*)\)=", "$1=") ; '(x)=' => 'x='

    return text
}

ShortToLongUnits(text) {
    wordRegex := "\b([a-zA-Z]+)\b"

    text := RegExReplace(text, "([a-zA-Z]+)([0-9])", "($1^$2)") ; 'abc3' => '(abc^3)'
    text := RegExReplace(text, wordRegex, "($1)") ; 'abc' => '(abc)'
    StringReplace, text, text, \eta{space}, y, All

    global longUnits
    longUnits := []
    loop {
        RegExMatch(text, wordRegex, shortUnit)

        if (shortUnit == "") {
            Break
        } else {
            longUnits.Push(ShortToLongUnit(shortUnit))
        }

        text := RegExReplace(text, wordRegex, "¤",, 1)
    }

    for i, longUnit in longUnits {
        StringReplace, text, text, ¤, %longUnit%
    }

    return text
}

ShortToLongUnit(simpleUnit) {
    unit := simpleUnit

    prefixes := { "T": "tera", "G": "giga", "M": "mega", "k": "kilo", "h": "hecto", "da": "deka", "d": "deci", "c": "centi", "m": "milli", "y": "micro", "n": "nano", "p": "pico", "f": "femto", "a": "atto" }
    mainUnits := { "g": "gram", "J": "joule", "Pa": "pascal", "K": "kelvin", "m": "meter", "h": "hour", "min": "minute", "s": "second", "l": "liter", "MM": "mole/liter", "MOLE": "mole", "N": "newton", "W": "watt", "V": "volt"}
    unit := RegExReplace(unit, "mol\b", "MOLE") ; 'l' and 'mol' would otherwise interfere
    unit := RegExReplace(unit, "M\b", "MM") ; because dict-keys are case-insensitive...

    for short, long in mainUnits {
        unit := RegExReplace(unit, short "\b", "¤" long, replaceCount) ; 'km' => 'k¤meter'

        if (replaceCount > 0) ; only one replacement allowed
            Break
    }
    for short, long in prefixes {
        unit := RegExReplace(unit, short "¤", long " ") ; 'k¤meter' => 'kilo meter'
    }
    unit := RegExReplace(unit, "¤", "") ; '¤meter' => 'meter'

    return unit
}

MarkClosingMathrms(text) {
    Loop {
        new := MarkClosingMathrm(text)

        if (new == text)
            return text

        text := new
    }
}

MarkClosingMathrm(text) {
    mathrmIndex := InStr(text, "\mathrm")
    StringReplace, text, text, \mathrm, @mathrm

    if (mathrmIndex == 0)
        return text

    openingCounter := 0
    closingCounter := 0
    loop, parse, text,
    {
        if (A_Index < mathrmIndex)
            Continue
        else if (A_LoopField == "{")
            openingCounter++
        else if (A_LoopField == "}")
            closingCounter++

        if (openingCounter > 0 and openingCounter == closingCounter) {
            text := SubStr(text, 1, A_Index-1) . "@mathrm" . SubStr(text, A_Index)
            return text
        }
    }

    return "fuck"
}

RegexReplaceFiltered(haystack, needle, filterFunction) {
    loop {
        RegExMatch(haystack, needle, match)

        if (match == "")
            return haystack

        filtered := %filterFunction%(match1)
        StringReplace, haystack, haystack, %match%, %filtered%
    }
}

RegexReplaceRecursive(haystack, needle, insertable) {
    Loop {
        new := RegExReplace(haystack, needle, insertable)

        if (new == haystack)
            return haystack

        haystack := new
    }
}

; Ctrl + Shift + V => paste special
^+V::
    Gui, New, -MaximizeBox -MinimizeBox, Paste special
    Gui, Add, ListBox, r5 vChoice AltSubmit, LaTex -> SpeedCrunch||Otava math -> LaTex|Cancel
    Gui, Show

    KeyWait, Enter, D
    Gui, Submit
    Gui, Destroy

    Switch Choice
    {
    Case 1:
        SendByClipboard(LatexToSpeedcrunch(clipboard))
    Case 2:
        SendByClipboard(OtavamathToLatex(clipboard))
    Case 3:
    Default:
        return
    }
return