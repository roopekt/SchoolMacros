#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

UnicodeToolsEnabled := 0 ; features of this script are disabled by default

; RCtrl + U => toggle unicode tools
>^u::
    UnicodeToolsEnabled := !UnicodeToolsEnabled
    If (UnicodeToolsEnabled == 1){
        TrayTip, Unicode tools, enabled
    }
    else{
        TrayTip, Unicode tools, disabled
    }
return

; the unicode tools
#if UnicodeToolsEnabled

#Hotstring c

::Alpha::Α
::alpha::α
::Beta::Β
::beta::β
::Gamma::Γ
::gamma::γ
::Delta::Δ
::delta::𝛿
::Epsilon::Ε
::epsilon::ε
::Zeta::Ζ
::zeta::ζ
::Eta::Η
::eta::η
::Theta::Θ
::theta::θ
::Iota::Ι
::iota::ι
::Kappa::Κ
::kappa::κ
::Lambda::Λ
::lambda::λ
::Mu::Μ
::mu::μ
::Nu::Ν
::nu::ν
::Xi::Ξ
::xi::ξ
::Omikron::Ο
::omikron::ο
::Pi::Π
::pi::π
::Rho::Ρ
::rho::ρ
::Zigma::Σ
::_zigma::ς
::zigma::σ
::Tau::Τ
::tau::τ
::Upsilon::Υ
::upsilon::υ
::Phi::Φ
::phi::φ
::Chi::Χ
::chi::χ
::Psi::Ψ
::psi::ψ
::Omega::Ω
::omega::ω

#Hotstring ?

::^0::⁰
::^1::¹
::^2::²
::^3::³
::^4::⁴
::^5::⁵
::^6::⁶
::^7::⁷
::^8::⁸
::^9::⁹
::^+::⁺
::^-::⁻

::_0::₀
::_1::₁
::_2::₂
::_3::₃
::_4::₄
::_5::₅
::_6::₆
::_7::₇
::_8::₈
::_9::₉
::_+::₊
::_-::₋

::+-::±
::deg::°
::cor::

; LShift + equals => ≈
>+0::≈