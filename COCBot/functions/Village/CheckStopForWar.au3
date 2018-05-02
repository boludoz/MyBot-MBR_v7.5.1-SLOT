; #FUNCTION# ====================================================================================================================
; Name ..........: CheckStopForWar
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CheckStopForWar()

	If ProfileSwitchAccountEnabled() Then CheckStopForWarAllAccounts()

	If Not $g_bStopForWar Then Return

	Local $bCurrentWar = False, $aResult[3], $bStopAction = False

	If ProfileSwitchAccountEnabled() Then ; Load Timer of Current Account
		$g_iStartTimerToRecheck = $g_aiStartTimerToRecheck[$g_iCurAccount]
		$g_iTimerToRecheck = $g_aiTimerToRecheck[$g_iCurAccount]
		$g_sCheckOrStop = $g_asCheckOrStop[$g_iCurAccount]
	EndIf

	If $g_bFirstStart Then $g_iStartTimerToRecheck = 0

	If $g_iStartTimerToRecheck <> 0 Then
		Local $iCheckTimer = TimerDiff($g_iStartTimerToRecheck)
		If $iCheckTimer < $g_iTimerToRecheck * 60 * 1000 Then Return
		If $g_sCheckOrStop = "Time to stop" Then SetLog("Should be time to stop for war now. Let's have a look", $COLOR_INFO)
	EndIf

	$bCurrentWar = CheckWarTime($aResult)
	If @error Then Return
	Local $iBattleStartTime = $aResult[0]
	Local $iBattleEndTime = $aResult[1]
	Local $bInWar = $aResult[2]

	If Not $bCurrentWar Then
		$g_iStartTimerToRecheck = TimerInit()
		$g_iTimerToRecheck = 6 * 60 ; 360 minutes = 6 hours
		$g_sCheckOrStop = "Time to re-check"
		SetLog("Will come back to check in 6 hours", $COLOR_INFO)

		If ProfileSwitchAccountEnabled() Then SaveTimerCurrentAccount()
		Return
	Else
		If Not $bInWar Then
			$g_iStartTimerToRecheck = TimerInit()
			$g_iTimerToRecheck = $iBattleStartTime >= 0 ? $iBattleStartTime + 24 * 60 : $iBattleEndTime
			If $g_iTimerToRecheck > 0 Then
				SetLog("Will come back to check after current war finish in " & Int($g_iTimerToRecheck / 60) & "h " & Mod($g_iTimerToRecheck, 60) & "m", $COLOR_INFO)
				$g_sCheckOrStop = "Time to re-check"
			Else
				$g_iStartTimerToRecheck = 0 ; remove timer
			EndIf

			If ProfileSwitchAccountEnabled() Then SaveTimerCurrentAccount()
			Return
		Else
			Local $iBattleTime = $iBattleStartTime >= 0 ? $iBattleStartTime : 24 * 60 - $iBattleEndTime ; check battle start time
			If $g_bDebugSetlog Then SetDebugLog("$iBattleTime: " & $iBattleTime & " minutes")

			$g_iTimerToRecheck = $iBattleTime + $g_bStopBeforeBattle ? (-$g_iStopTime * 60) ? $g_iStopTime * 60
			If $g_bDebugSetlog Then SetDebugLog("$g_iTimerToRecheck: " & $g_iTimerToRecheck & " minutes")
			If $g_iTimerToRecheck > 0 Then
				$g_iStartTimerToRecheck = TimerInit()
				SetLog("Will stop for war preparation in " & Int($g_iTimerToRecheck / 60) & "h " & Mod($g_iTimerToRecheck, 60) & "m", $COLOR_INFO)
				$g_sCheckOrStop = "Time to stop"
			Else
				$g_iStartTimerToRecheck = 0 ; remove timer
				$g_sCheckOrStop = ""

				$iBattleTime = $iBattleEndTime >= 0 ? $iBattleEndTime : $iBattleStartTime + 24 * 60 ; check battle end time
				Local $iSleepTime = $iBattleTime - $g_iReturnTime * 60

				If $iSleepTime >= 60 Then
					SetLog("Stop and prepare for war now", $COLOR_INFO)
					$bStopAction = True
				Else
					SetLog("It's time to stop for war. But stop time window is too tight, just skip and continue", $COLOR_INFO)
					SetLog("Will come back to check in 6 hours", $COLOR_INFO)
					$g_iStartTimerToRecheck = TimerInit()
					$g_iTimerToRecheck = 6 * 60 ; 360 minutes = 6 hours
					$g_sCheckOrStop = "Time to re-check"
				EndIf
			EndIf
			If ProfileSwitchAccountEnabled() Then SaveTimerCurrentAccount()
			If $bStopAction Then StopAndPrepareForWar($iSleepTime) ; quit function here
		EndIf
	EndIf

EndFunc   ;==>CheckStopForWar

Func IsWarMenu()
	Local $Result = _ColorCheck(_GetPixelColor(826, 34, True), "FFFFFF", 20)
	Return $Result
EndFunc   ;==>IsWarMenu

Func CheckWarTime(ByRef $aResult) ; return Success + $aResult[3] = [ $iBattleStartTime, $iBattleEndTime, $bInWar] OR Failure

	$aResult[0] = -1
	$aResult[1] = -1 ; reset time (minutes)
	Local $directory = @ScriptDir & "\imgxml\WarPage"
	Local $bBattleDay_InWar = False, $sWarDay, $sTime

	If IsMainPage() Then
		$bBattleDay_InWar = _ColorCheck(_GetPixelColor(45, 500, True), "ED151D", 20) ; Red color in war button
		If $g_bDebugSetlog Then SetDebugLog("Checking battle notification, $bBattleDay_InWar = " & $bBattleDay_InWar)
		Click(40, 530) ; open war menu
		If _Sleep(1000) Then Return
	EndIf

	If IsWarMenu() Then
		If $bBattleDay_InWar Then
			$sWarDay = "Battle"
			$aResult[2] = True
		Else
			$sWarDay = QuickMIS("N1", $directory, 360, 85, 360 + 145, 85 + 28, True) ; Prepare or Battle
			If $g_bDebugSetlog Then SetDebugLog("$sResult QuickMIS N1: " & $sWarDay)
		EndIf

		If Not StringInStr($sWarDay, "Battle") And Not StringInStr($sWarDay, "Preparation") Then
			SetLog("Your Clan is not in active war yet.", $COLOR_INFO)
			Click(70, 680, 1, 500, "#0000") ; return home
			Return False

		Else
			$sTime = QuickMIS("OCR", $directory, 396, 65, 396 + 70, 70 + 20, True)
			If $g_bDebugSetlog Then SetDebugLog("$sResult QuickMIS OCR: " & ($bBattleDay_InWar ? $sWarDay & ", " : "") & $sTime)

			Local $iConvertedTime = ConvertOCRTime("War", $sTime, False)
			If StringInStr($sWarDay, "Preparation") Then
				$aResult[0] = $iConvertedTime ; $iBattleStartTime
				SetLog("Clan war is now in preparation. Battle will start in " & $sTime, $COLOR_INFO)
			ElseIf StringInStr($sWarDay, "Battle") Then
				$aResult[1] = $iConvertedTime ; $iBattleEndTime
				SetLog("Clan war is now in battle day. Battle will finish in " & $sTime, $COLOR_INFO)
			EndIf

			If _Max($aResult[0], $aResult[1]) < 0 Then Return False

			$aResult[2] = QuickMIS("BC1", $directory, 795, 555, 795 + 20, 555 + 60, True) ; $bInWar

			SetLog("You are " & ($aResult[2] ? "" : "not ") & "in war", $COLOR_INFO)

			Click(70, 680, 1, 500, "#0000") ; return home
			Return True
		EndIf

	Else
		SetLog("Error when trying to open War window.", $COLOR_WARNING)
		Return SetError(1, 0, "Error open War window")
		ClickP($aAway, 2, 0, "#0000") ;Click Away
	EndIf
EndFunc   ;==>CheckWarTime

Func StopAndPrepareForWar($iSleepTime)

	If $g_bTrainWarTroop Then
		SetLog("Let's remove all farming troops and train war troop", $COLOR_ACTION)
		If $g_bUseQuickTrainWar Then
			$g_bQuickTrainEnable = $g_bUseQuickTrainWar
			$g_bQuickTrainArmy[0] = $g_aChkArmyWar[0]
			$g_bQuickTrainArmy[1] = $g_aChkArmyWar[1]
			$g_bQuickTrainArmy[2] = $g_aChkArmyWar[2]
		Else
			For $i = 0 To $eTroopCount - 1
				$g_aiArmyCompTroops[$i] = $g_aiWarCompTroops[$i]
				If $i = $eSpellCount Then ContinueLoop
				$g_aiArmyCompSpells[$i] = $g_aiWarCompSpells[$i]
			Next
		EndIf
		TrainRevamp()
		; Double train
		; If Not $g_bChkSmartTrain Then
		StartGainCost()
		OpenArmyOverview(True, "StopAndPrepareForWar()")
		OpenTroopsTab()
		If _Sleep(500) Then Return
		Local $TroopCamp = GetOCRCurrent(43, 160)
		SetLog("Checking troop tab: " & $TroopCamp[0] & "/" & $TroopCamp[1] * 2)

		OpenSpellsTab()
		If _Sleep(500) Then Return
		Local $SpellCamp = GetOCRCurrent(43, 160)
		SetLog("Checking spell tab: " & $SpellCamp[0] & "/" & $SpellCamp[1] * 2)

		If Not $g_bUseQuickTrainWar Then ; Custom train troops
			$g_bIsFullArmywithHeroesAndSpells = True
			If $TroopCamp[0] = $TroopCamp[1] Then
				SetLog("Troops camp is perfect, let's train 1 more set", $COLOR_ACTION)
				Local $rWhatToTrain = WhatToTrain(False, False)
				TrainUsingWhatToTrain($rWhatToTrain)
			EndIf
			If $SpellCamp[0] = $SpellCamp[1] Then
				SetLog("Spells camp is perfect, let's train 1 more set", $COLOR_ACTION)
				Local $rWhatToTrain = WhatToTrain(False, False)
				TrainUsingWhatToTrain($rWhatToTrain, True)
			EndIf

		Else
			OpenQuickTrainTab()
			If _Sleep(1000) Then Return
			TrainArmyNumber($g_bQuickTrainArmy)
			If _Sleep(700) Then Return

		EndIf

		If _Sleep(250) Then Return
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		EndGainCost("Train")
		; EndIf
	EndIf

	If $g_bRequestCCForWar Then
		$g_bRequestTroopsEnable = True
		$g_bDonationEnabled = True
		$g_abRequestCCHours[@HOUR] = True
		$g_sRequestTroopsText = $g_sTxtRequestCCForWar

		SetLog("Let's request again for war", $COLOR_ACTION)
		RemoveCC()
		RequestCC()
	EndIf

	SetLog("It's war time, let's take a break", $COLOR_ACTION)

	If Not ProfileSwitchAccountEnabled() Then
		UniversalCloseWaitOpenCoC($iSleepTime * 60 * 1000, "StopAndPrepareForWar", False, True) ; wake up & full restart
	Else
		If GUICtrlRead($g_ahChkAccount[$g_iCurAccount]) = $GUI_CHECKED Then
			GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
			chkAccount($g_iCurAccount)
			SaveConfig_600_35_2() ; Save config profile after changing botting type
			ReadConfig_600_35_2() ; Update variables
			UpdateMultiStats(False)
			SetLog("Acc [" & $g_iCurAccount + 1 & "] turned OFF")
			SetSwitchAccLog("   Acc. " & $g_iCurAccount + 1 & " now Idle for war", $COLOR_ACTION)

			Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
			If UBound($aActiveAccount) >= 1 Then
				$g_iNextAccount = $aActiveAccount[0]
				SwitchCOCAcc($g_iNextAccount)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>StopAndPrepareForWar

Func RemoveCC()

	If Not IsMainPage() Then
		OpenArmyOverview(True, "CheckCC()")
		If _Sleep(1500) Then Return
	EndIf

	Local $sCCTroop, $aCCTroop, $sCCSpell, $aCCSpell
	$sCCTroop = getOcrAndCapture("coc-ms", 302, 470, 60, 16, True, False, True) ; read CC troops 0/35
	$aCCTroop = StringSplit($sCCTroop, "#") ; split the trained troop number from the total troop number
	$sCCSpell = getOcrAndCapture("coc-ms", 530, 468, 35, 16, True, False, True) ; read CC Spells 0/2
	$aCCSpell = StringSplit($sCCSpell, "#") ; split the trained troop number from the total troop number
	Local $aPos[2] = [40, 575]

	If IsArray($aCCTroop) Or IsArray($aCCSpell) Then
		If $aCCTroop[0] >= 1 Or $aCCSpell[0] >= 1 Then
			Click(Random(715, 825, 1), Random(507, 545, 1)) ; Click on Edit Army Button
			If _Sleep(500) Then Return
			For $i = 0 To 6
				If _ColorCheck(_GetPixelColor(Round(30 + 72.8 * $i, 0), 508, True), Hex(0xCFCFC8, 6), 15) Then
					ExitLoop
				Else
					$aPos[0] = 40 + 74 * $i
					ClickRemoveTroop($aPos, 35, $g_iTrainClickDelay)
				EndIf
			Next
			If Not _ColorCheck(_GetPixelColor(570, 508, True), Hex(0xCFCFC8, 6), 15) Then
				$aPos[0] = 570
				ClickRemoveTroop($aPos, 3, $g_iTrainClickDelay)
			EndIf

			For $i = 0 To 10
				If _ColorCheck(_GetPixelColor(806, 567, True), Hex(0xCEEF76, 6), 25) Then
					Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes
					ExitLoop
				Else
					If $i = 10 Then
						SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_WARNING)
						ClickP($aAway, 2, 0)
						Return ; Exit function
					EndIf
					If _Sleep(200) Then Return
				EndIf
			Next

			For $i = 0 To 10
				If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) Then
					Click(Random(445, 583, 1), Random(402, 455, 1)) ; Click on 'Okay' button to Save changes... Last button
					ExitLoop
				Else
					If $i = 10 Then
						SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_WARNING)
						ClickP($aAway, 2, 0)
						Return ; Exit function
					EndIf
					If _Sleep(300) Then Return
				EndIf
			Next
			SetLog("CC Troops/Spells removed", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
		EndIf
	EndIf

	getArmyCCStatus()

	ClickP($aAway, 2, 0)
EndFunc   ;==>RemoveCC

Func SaveTimerCurrentAccount()
	$g_aiStartTimerToRecheck[$g_iCurAccount] = $g_iStartTimerToRecheck
	$g_aiTimerToRecheck[$g_iCurAccount] = $g_iTimerToRecheck
	$g_asCheckOrStop[$g_iCurAccount] = $g_sCheckOrStop
EndFunc   ;==>SaveTimerCurrentAccount

Func CheckStopForWarAllAccounts()

	$g_abStopForWar[$g_iCurAccount] = $g_bStopForWar

	For $i = 0 To $g_iTotalAcc
		If $i = $g_iCurAccount Or Not $g_abStopForWar[$i] Then ContinueLoop ; not check current account
		If $g_aiStartTimerToRecheck[$i] <> 0 Then
			Local $iCheckTimer = TimerDiff($g_aiStartTimerToRecheck[$i])
			If $iCheckTimer >= $g_aiTimerToRecheck[$i] * 60 * 1000 And $g_asCheckOrStop[$i] = "Time to stop" Then
				SetLog("Account [" & $i + 1 & "] should stop for war now.", $COLOR_INFO)
				If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
					GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
					chkAccount($i)
					SaveConfig_600_35_2() ; Save config profile after changing botting type
					ReadConfig_600_35_2() ; Update variables
					UpdateMultiStats()
					SetLog("Acc [" & $i + 1 & "] turned OFF")
					SetSwitchAccLog("   Acc. " & $i + 1 & " now Idle for war", $COLOR_ACTION)
				EndIf
			EndIf
		EndIf
	Next
EndFunc   ;==>CheckStopForWarAllAccounts
