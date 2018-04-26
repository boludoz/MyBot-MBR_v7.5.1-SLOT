; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This functions will do all config operation like save or restore gui data into or from ini files.
; Syntax ........: None
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

Func AF_ApplyRead_SmartTrain()

	GUICtrlSetState($g_hChkSmartTrain, $g_bChkSmartTrain ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkPreciseArmyCamp, $g_bChkPreciseArmyCamp ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkFillArcher, $g_bChkFillArcher ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetData($g_hTxtFillArcher, $g_iTxtFillArcher)
	GUICtrlSetState($g_hChkFillEQ, $g_bChkFillEQ ? $GUI_CHECKED : $GUI_UNCHECKED)
	chkSmartTrain()

EndFunc

Func AF_ApplySave_SmartTrain()

	$g_bChkSmartTrain = (GUICtrlRead($g_hChkSmartTrain) = $GUI_CHECKED)
	$g_bChkPreciseArmyCamp = (GUICtrlRead($g_hChkPreciseArmyCamp) = $GUI_CHECKED)
	$g_bChkFillArcher = (GUICtrlRead($g_hChkFillArcher) = $GUI_CHECKED)
	$g_iTxtFillArcher = GUICtrlRead($g_hTxtFillArcher)
	$g_bChkFillEQ = (GUICtrlRead($g_hChkFillEQ) = $GUI_CHECKED)

EndFunc

Func AF_ReadConfig_SmartTrain()

	IniReadS($g_bChkSmartTrain, $g_sProfileConfigPath, "SmartTrain", "Enable", False, "Bool")
	IniReadS($g_bChkPreciseArmyCamp, $g_sProfileConfigPath, "SmartTrain", "ChkPreciseTroops", False, "Bool")
	IniReadS($g_bChkFillArcher, $g_sProfileConfigPath, "SmartTrain", "ChkFillArcher", False, "Bool")
	IniReadS($g_iTxtFillArcher, $g_sProfileConfigPath, "SmartTrain", "TxtFillArcher", 5, "int")
	IniReadS($g_bChkFillEQ, $g_sProfileConfigPath, "SmartTrain", "ChkFillEQ", False, "Bool")

EndFunc

Func AF_SaveConfig_SmartTrain()

	_Ini_Add("SmartTrain", "Enable", $g_bChkSmartTrain ? 1 : 0)
	_Ini_Add("SmartTrain", "ChkPreciseTroops", $g_bChkPreciseArmyCamp ? 1 : 0)
	_Ini_Add("SmartTrain", "ChkFillArcher", $g_bChkFillArcher ? 1 : 0)
	_Ini_Add("SmartTrain", "TxtFillArcher", $g_iTxtFillArcher)
	_Ini_Add("SmartTrain", "ChkFillEQ", $g_bChkFillEQ ? 1 : 0)

EndFunc

Func AF_ApplyReadSwitchAcc()

	GUICtrlSetState($g_chkSCIDSwitchAccAF, $g_ichkSCIDSwitchAccAF ? $GUI_CHECKED : $GUI_UNCHECKED)
	chkSCIDSwitchAccAF()

EndFunc

Func AF_ApplySaveSwitchAcc()

	$g_ichkSCIDSwitchAccAF = (GUICtrlRead($g_chkSCIDSwitchAccAF) = $GUI_CHECKED)

EndFunc

Func AF_ReadConfigSwitchAcc($sSwitchAccFile = -1)

	If $sSwitchAccFile = -1 Then
		IniReadS($g_ichkSCIDSwitchAccAF, $g_sProfileConfigPath, "SwitchAccount", "AF_ChkSCIDSwitchAcc", False, "bool")
	Else
		$g_ichkSCIDSwitchAccAF = IniRead($sSwitchAccFile, "SwitchAccount", "AF_ChkSCIDSwitchAcc", $g_chkSCIDSwitchAccAF ? "1" : "0") = "1"
	EndIf

EndFunc

Func AF_SaveConfigSwitchAcc($sSwitchAccFile = -1)

	If $sSwitchAccFile = -1 Then
		_Ini_Add("SwitchAccount", "AF_ChkSCIDSwitchAcc", $g_ichkSCIDSwitchAccAF)
	Else
		IniWrite($sSwitchAccFile, "SwitchAccount", "AF_ChkSCIDSwitchAcc", $g_ichkSCIDSwitchAccAF ? 1 : 0)
	EndIf

EndFunc