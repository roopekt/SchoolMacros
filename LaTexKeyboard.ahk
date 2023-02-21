#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

DoubleArrowEnabled := 0
LaTexEnabled := 0
GreeceEnabled := 0

Show_LatexToolsOn_Warning(_greeceEnabled) {
    message := "LaTex tools on"
    If (_greeceEnabled == 1) {
        message := message . " (g)"
    }

    Hide_LatextToolsOn_Warning()

    Gui, Font, s30
    Gui, Add, Text,, %message%
    Gui, Color, FF0000
    Gui, -Caption

    Gui, +AlwaysOnTop +Disabled -SysMenu +Owner
    Gui, Show, NoActivate x0 y0, LaTex tools
}

Hide_LatextToolsOn_Warning() {
    Gui, Destroy
}

; Ctrl + M => toggle LaTex tools
^m::
    LaTexEnabled := !LaTexEnabled
    If (LaTexEnabled == 1){
        Show_LatexToolsOn_Warning(GreeceEnabled)
    }
    else{
        Hide_LatextToolsOn_Warning()
    }
return

; Ctrl + G => toggle Greece
^g::
    GreeceEnabled := !GreeceEnabled
    If (LaTexEnabled == 1){
        Show_LatexToolsOn_Warning(GreeceEnabled)
    }
return

; paste given text
SendByClipboard(text) {
    origClip := clipboard
    clipboard := text
    Send ^v
    Sleep 100
    clipboard := origClip
}

; the LaTex tools
#if LaTexEnabled AND NOT GreeceEnabled

#Hotstring ?* c

; region hotstrings

; algebra
; {space} makes Abitti replace '\parallel' with a LaTex symbol immediately
::mid::\parallel{space}

; style
::text::\textrm{space}
::rm::\mathrm{space}{space}
::bar::\bar{space}

; geometry
::deg::°
::ang::\angle{space}
::paral::\parallel{space}
::perp::\perpendicular{space}

; trigonometry
::asin::
    SendByClipboard("\sin^{-1} ")
return
::acos::
    SendByClipboard("\cos^{-1} ")
return
::atan::
    SendByClipboard("\tan^{-1} ")
return
::sin::\sin{space}
::cos::\cos{space}
::tan::\tan{space}

; general math
::sq::\sqrt{space}
::+-::\pm{space}
::frac::\frac{space}
::<-->::\Leftrightarrow{space}
::<->::\leftrightarrow{space}
::->::\rightarrow{space}
::sum::\sum{space}
::sigma::\Sigma{space}
::sim::\equiv{space}
::subset::\subset{space}
::ins::\in{space}
::mul::
    SendByClipboard("\begin{matrix}\end{matrix}")
    Send {Left}
return

; number theory
::mod::
    Send \text mod{space}
    Send {Right}
return
::cong::\equiv{space}

; logic
::and::\and{space}
::or::\or{space}
::if::\rightarrow{space}
::not::\not{space}
::!=::\neq{space}
::all::\forall{space}
::exist::\exists{space}

; calculus
::par::\partial{space}
::der::
    SendByClipboard("\frac{d}{dx}")
return
::iint::
    SendByClipboard("\int_{ }^{ }")
return
::int::
    SendByClipboard("\int_{ }^{ }")
    Send {Left 2}
return
::+C::
    SendByClipboard("+C{,}\ \ \ C\in\mathbb{R}")
return

; some greece letters
::pi::\pi{space}
::delta::\Delta{space}

; sets
::Nat::
    Send \mathbb N
    Send {Right}
return
::Int::
    Send \mathbb Z
    Send {Right}
return
::Rat::
    Send \mathbb Q
    Send {Right}
return
::Real::
    Send \mathbb R
    Send {Right}
return
::Com::
    Send \mathbb C
    Send {Right}
return
; endregion

::root::
    SendByClipboard("\sqrt[]{} ")
    Send {Left 2}
return

; RCtrl + D => toggle double arrow (between '=>' and '<=>')
>^d::
    DoubleArrowEnabled := !DoubleArrowEnabled
    If (DoubleArrowEnabled == 1){
        TrayTip, LaTex tools, double arrow enabled
    }
    else{
        TrayTip, LaTex tools, double arrow disabled
    }
return

::=>::
    if(DoubleArrowEnabled){
        Send \Leftrightarrow{space}
    }
    else{
        Send \Rightarrow{space}
    }
return

; pair => pair of equations
::pair::
    SendByClipboard("\begin{cases} \\ \end{cases}")
    Send {Left 2}
return

; vec => column vector
::vec::
    SendByClipboard("\left[\begin{matrix} \\ \end{matrix}\right]")
    Send {Left 3}
return

; right shift + 0 (key with '=') => '≈'
>+0::Send \approx{space}

; Ctrl + 2 => "^2" + right arrow (adds 2 as exponent)
^2::
    Send {raw}^2
    Send {Right}
return

; same as above, but for 3
^3::
    Send {raw}^3
    Send {Right}
return

#if LaTexEnabled && GreeceEnabled
::Alpha::\Alpha{space}
::alpha::\alpha{space}
::Beta::\Beta{space}
::beta::\beta{space}
::Gamma::\Gamma{space}
::gamma::\gamma{space}
::Delta::\Delta{space}
::delta::\delta{space}
::Epsilon::\Epsilon{space}
::epsilon::\epsilon{space}
::Zeta::\Zeta{space}
::zeta::\zeta{space}
::Theta::\Theta{space}
::theta::\theta{space}
::Eta::\Eta{space}
::eta::\eta{space}
::Iota::\Iota{space}
::iota::\iota{space}
::Kappa::\Kappa{space}
::kappa::\kappa{space}
::Lambda::\Lambda{space}
::lambda::\lambda{space}
::Mu::\Mu{space}
::mu::\mu{space}
::Nu::\Nu{space}
::nu::\nu{space}
::Xi::\Xi{space}
::xi::\xi{space}
::Omikron::\Omikron{space}
::omikron::\omikron{space}
::Pi::\Pi{space}
::pi::\pi{space}
::Rho::\Rho{space}
::rho::\rho{space}
::Zigma::\Zigma{space}
::zigma::\zigma{space}
::Tau::\Tau{space}
::tau::\tau{space}
::Upsilon::\Upsilon{space}
::upsilon::\upsilon{space}
::Phi::\Phi{space}
::phi::\phi{space}
::Chi::\Chi{space}
::chi::\chi{space}
::Psi::\Psi{space}
::psi::\psi{space}
::Omega::\Omega{space}
::omega::\omega{space}

#if ; endif