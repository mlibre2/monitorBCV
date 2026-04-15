#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <FontConstants.au3>
#include <SendMessage.au3>
#include <Misc.au3>

; --- Variables de Estado Globales ---
$g_bDarkMode = False
Global $g_iBgColor, $g_iTextColor
$g_iSecondaryColor = 0x888888
$sTitle = "Monitor BCV"
Const $sVersion = "1.1"

If Not _Singleton($sTitle, 1) Then Exit

; --- Manejador de errores COM ---
$oErrorHandler = ObjEvent("AutoIt.Error", "_ErrFunc")

; --- Elementos de Interfaz Globales ---
Global $g_hGUI, $g_btnExit, $g_btnMin, $g_lblHeader, $g_lblUSD_Tag, $g_lblUSD, $g_lblEUR_Tag, $g_lblEUR, $g_lblStatus, $g_iconTheme, $g_iconRefresh, $g_btnCalc

; --- Posicionamiento ---
Local $iGuiW = 350, $iGuiH = 220
$iPosX = @DesktopWidth - $iGuiW - 20
$iPosY = @DesktopHeight - $iGuiH - 80

; --- Creación de la GUI ---
$g_hGUI = GUICreate($sTitle, $iGuiW, $iGuiH, $iPosX, $iPosY, $WS_POPUP)

; --- Elementos de Interfaz ---
$g_btnExit = GUICtrlCreateLabel("✕", $iGuiW - 25, 5, 20, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, $FW_BOLD, 0, "Segoe UI")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Cerrar")

$g_btnMin = GUICtrlCreateLabel("—", $iGuiW - 45, 5, 20, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, $FW_BOLD, 0, "Segoe UI")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Minimizar")

$g_lblHeader = GUICtrlCreateLabel($sTitle & " - Tipo de Cambio", 20, 15, 250, 25)
GUICtrlSetFont(-1, 12, $FW_BOLD, 0, "Segoe UI")
GUICtrlSetTip(-1, "Versión: " & $sVersion)

; USD
$g_lblUSD_Tag = GUICtrlCreateLabel("$ USD:", 20, 60, 130, 40)
GUICtrlSetFont(-1, 22, $FW_BOLD, 0, "Verdana")
GUICtrlSetColor(-1, 0x2E7D32)
GUICtrlSetTip(-1, "Dolares Americanos")

$g_lblUSD = GUICtrlCreateLabel("...", 150, 60, 170, 40)
GUICtrlSetFont(-1, 24, $FW_BOLD, 0, "Verdana")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Copiar")

; EUR
$g_lblEUR_Tag = GUICtrlCreateLabel("€ EUR:", 20, 120, 130, 40)
GUICtrlSetFont(-1, 22, $FW_BOLD, 0, "Verdana")
GUICtrlSetColor(-1, 0x1565C0)
GUICtrlSetTip(-1, "Euros")

$g_lblEUR = GUICtrlCreateLabel("...", 150, 120, 170, 40)
GUICtrlSetFont(-1, 24, $FW_BOLD, 0, "Verdana")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Copiar")

; Footer
$g_lblStatus = GUICtrlCreateLabel("Iniciando...", 15, 195, 210, 20)
GUICtrlSetFont(-1, 8, $FW_NORMAL, 0, "Segoe UI")

$g_iconTheme = GUICtrlCreateIcon("shell32.dll", -175, $iGuiW - 95, 192, 20, 20)
GUICtrlSetTip(-1, "Cambiar tema")
GUICtrlSetCursor(-1, 0)

$g_iconRefresh = GUICtrlCreateIcon("shell32.dll", -239, $iGuiW - 65, 192, 20, 20)
GUICtrlSetTip(-1, "Actualizar")
GUICtrlSetCursor(-1, 0)

$g_btnCalc = GUICtrlCreateIcon("calc.exe", -1, $iGuiW - 35, 192, 20, 20)
GUICtrlSetTip(-1, "Calculadora")
GUICtrlSetCursor(-1, 0)

; --- Inicialización de Tema ---
_AutoDetectTheme()
GUISetState(@SW_SHOW)
_UpdateRates()

; --- Bucle Principal ---
While 1
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE, $g_btnExit
		 Exit

	  Case $g_btnMin
		 GUISetState(@SW_MINIMIZE)

	  Case $g_iconRefresh
		 _UpdateRates()

	  Case $g_iconTheme
		 _ToggleTheme()

	  Case $g_btnCalc
		 Run("calc")

	  Case $g_lblUSD
		 _CopyToClipboard(GUICtrlRead($g_lblUSD), $g_lblUSD)

	  Case $g_lblEUR
		 _CopyToClipboard(GUICtrlRead($g_lblEUR), $g_lblEUR)

	  Case $GUI_EVENT_PRIMARYDOWN
		 _SendMessage($g_hGUI, $WM_SYSCOMMAND, 0xF012, 0)

	EndSwitch
WEnd

; --- Funciones ---

Func _AutoDetectTheme()
   $iReg = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme")
   $g_bDarkMode = ($iReg = 0)
   _ApplyTheme()
EndFunc

Func _ToggleTheme()
   $g_bDarkMode = Not $g_bDarkMode
   _ApplyTheme()
EndFunc

Func _ApplyTheme()
   $g_iBgColor = ($g_bDarkMode ? 0x1E1E1E : 0xFFFFFF)
   $g_iTextColor = ($g_bDarkMode ? 0xFFFFFF : 0x000000)

   GUISetBkColor($g_iBgColor, $g_hGUI)
   GUICtrlSetColor($g_lblHeader, $g_iTextColor)
   GUICtrlSetColor($g_lblUSD, $g_iTextColor)
   GUICtrlSetColor($g_lblEUR, $g_iTextColor)
   GUICtrlSetColor($g_btnExit, $g_iSecondaryColor)
   GUICtrlSetColor($g_btnMin, $g_iSecondaryColor)
   GUICtrlSetColor($g_lblStatus, $g_iSecondaryColor)
EndFunc

Func _UpdateRates()
   GUICtrlSetState($g_iconRefresh, $GUI_DISABLE)
   GUICtrlSetData($g_lblStatus, "Buscando datos...")

   $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
   If IsObj($oHTTP) Then
	  $oHTTP.Open("GET", "https://www.bcv.org.ve/", False)
	  $oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0")
	  $oHTTP.Send()

	  If Not @error Then
		 $html = $oHTTP.ResponseText
		 GUICtrlSetData($g_lblUSD, _FormatBCV($html, "dolar"))
		 GUICtrlSetData($g_lblEUR, _FormatBCV($html, "euro"))
		 GUICtrlSetData($g_lblStatus, "Último chequeo: " & @MDAY & "/" & @MON & "/" & @YEAR & " - " & _GetTime())
	  Else
		 GUICtrlSetData($g_lblStatus, "Error de conexión")
	  EndIf
    EndIf
    GUICtrlSetState($g_iconRefresh, $GUI_ENABLE)
EndFunc

Func _FormatBCV($sHTML, $sCurrencyID)
   $pattern = '(?si)id="' & $sCurrencyID & '".*?<strong>\s*([\d,\.]+)\s*</strong>'
   $aResult = StringRegExp($sHTML, $pattern, 3)
   If IsArray($aResult) Then
	  $valNum = Number(StringReplace(StringStripWS($aResult[0], 8), ",", "."))
	  Return StringReplace(StringFormat("%.2f", $valNum), ".", ",")
   EndIf
   Return "Error"
EndFunc

Func _GetTime()
   $iHour = Int(@HOUR)
   $sAMPM = ($iHour >= 12 ? "PM" : "AM")
   $iHour12 = ($iHour > 12 ? $iHour - 12 : ($iHour = 0 ? 12 : $iHour))
   Return StringFormat("%02d:%s %s", $iHour12, @MIN, $sAMPM)
EndFunc

Func _CopyToClipboard($sText, $ctrlID)
   If $sText <> "..." And $sText <> "Error" Then
	  ClipPut($sText)
	  GUICtrlSetData($ctrlID, "Copiado")
	  GUICtrlSetColor($ctrlID, 0xD32F2F)
	  Sleep(500)
	  GUICtrlSetData($ctrlID, $sText)
	  GUICtrlSetColor($ctrlID, $g_iTextColor)
    EndIf
EndFunc

Func _ErrFunc()
   ; Silenciar errores COM
EndFunc
