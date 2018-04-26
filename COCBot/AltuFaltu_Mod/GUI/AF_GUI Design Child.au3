; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This functions will create the basic GUI user interface.
; Syntax ........: #include
; Parameters ....: None
; Return values .: None
; Author ........: AltuFaltu(06-04-18)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;#include <StaticConstants.au3>


Global $g_hGUI_MOD_AF = 0
Local $sTxtTip

$g_hGUI_MOD_AF = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $WS_CHILD, -1, $g_hFrmBotEx)

;GUISetBkColor($COLOR_WHITE, $hGUI_BOT)

GUISwitch($g_hGUI_MOD_AF)

;================================= Tab1 ===============================================
SplashStep("Loading M0d - Tab1...")
GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $TCS_FLATBUTTONS)
GUICtrlCreateTabItem(GetTranslatedFileIni("AF_Mod", 11, "Tab1"))

Local $x = 10, $y = 30 ;Start location

Local $grpSwithAccAF = GUICtrlCreateGroup(GetTranslatedFileIni("AF_Mod", 12, "AltuFaltu Switch Account"), $x, $y, 430, 250)
$y += 20
Local const $LogoSCID = @ScriptDir & "\COCBot\AltuFaltu_Mod\Pics\LogoSCID.bmp"
	GUICtrlCreatePic($LogoSCID, $x + 120, $y , 200, 41,-1 ,-1)
$g_chkSCIDSwitchAccAF = GUICtrlCreateCheckbox(GetTranslatedFileIni("AF_Mod", 14, "ALtuFaltu SuperCellID Switch Account"), $x + 120, $y+45, -1, -1)
	$sTxtTip = "This is a simple click process to switch between SCID Account." & @CRLF & _
	"Need to do necessary multi account setup on Bot's Main Profile Tab."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkSCIDSwitchAccAF")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

;Demen's Smart Train
Local $x = 10, $y = 300
Local $grpSmartTrain = GUICtrlCreateGroup(GetTranslatedFileIni("AF_Mod", 12, "Demen's Smart Train"), $x, $y, 430, 100)
$x += 15
$y += 40
$g_hChkSmartTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkSmartTrain", "Double Train Army"), $x, $y, -1, 15)
			GUICtrlSetOnEvent(-1, "chkSmartTrain")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkSmartTrain_Info_01", "Train 2 sets of army to make full camp & full queue") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkSmartTrain_Info_02", "Only delete queued troops or spells if the queue is not full") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkSmartTrain_Info_03", "Not delete training troops up to full camp capacity"))
	$x += 130
		$g_hChkPreciseArmyCamp = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkPreciseArmyCamp", "Precise troops"), $x, $y, -1, 15)
			GUICtrlSetOnEvent(-1, "chkPreciseTroops")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkPreciseArmyCamp_Info_01", "Check precision of troops & spells before training.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkPreciseArmyCamp_Info_02", "Will remove wrong troops or spells if any"))
	$x += 103
		$g_hChkFillArcher = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkFillArcher", "Fill Archer:"), $x, $y, -1, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkFillArcher")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkFillArcher_Info_01", "Train some archers to top-up the camp or queue if it is nearly full"))
		$g_hTxtFillArcher = GUICtrlCreateInput("5", $x + 70, $y-1, 20, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 2)
	$x += 110
		$g_hChkFillEQ = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkFillEQ", "Fill 1 EQ"), $x, $y, -1, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "chkFillEQ_Info_01", "Brew 1 EarthQuake Spell to top-up the spell camp or queue"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)