; #FUNCTION# ====================================================================================================================
; Name ..........: OCR bypass
; Description ...: ByPass camps. capacity auto update
; Author ........: Boludoz (25/6/2018)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: 
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: getArmyCapacityOnTrainTroops, _getArmyCapacityOnTrainTroops
; ===============================================================================================================================

Func _getArmyCapacityOnTrainTroops($x_start, $y_start) ;  -> Gets quantity of troops in army Window
	Local $aResult[3] = [0, 0, 0]
	$aResult[0] = getOcrAndCapture("coc-NewCapacity", $x_start, $y_start, 67, 14, True)
	
		Local $aTempResult = StringSplit($aResult[0], "#", $STR_NOCOUNT)
		$aResult[1] = Number($aTempResult[0]) 
		$aResult[2] = Number($aTempResult[1]) / 2
		; Case to use this function os Spells will be <= 22 , 11*2
		If $aResult[2] <= 11 Then
			_GUICtrlComboBox_SelectString($g_hTxtTotalCountSpell, $aResult[2])
			Global $g_iTotalSpellValue = $aResult[2] * 2
			; May 2018 Update the Army Camp Value on Train page is DOUBLE Value
		ElseIf $aResult[2] >= 15 Then
			GUICtrlSetData($g_hTxtTotalCampForced, $aResult[2])
			Global $g_iTotalCampSpace = $aResult[2] * 2
		EndIf

	Return $aResult[0]
EndFunc   ;==>getArmyCapacityOnTrainTroops
