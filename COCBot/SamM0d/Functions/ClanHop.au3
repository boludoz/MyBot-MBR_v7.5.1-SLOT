; #FUNCTION# ====================================================================================================================
; Name ..........: ClanHop
; Description ...:
; Syntax ........: ClanHop()
; Parameters ....:
; Return values .:
; Author ........: BOLUDOZ(2018)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; #FUNCTION# ============================================================================================================================                                              ; Clan HOP
; Name ..........: ClanHop.au3                                                                                                                                                         ; Clan HOP
; Version........:                                                                                                                                                                     ; Clan HOP
; Description ...: This function joins/quit random clans and fills requests indefinitly                                                                                                ; Clan HOP
; Syntax ........: clanHop()                                                                                                                                                           ; Clan HOP
; Parameters ....: None                                                                                                                                                                ; Clan HOP
; Return values .: None                                                                                                                                                                ; Clan HOP
; Author ........: zengzeng, MantasM (complete overhaul)                                                                                                                               ; Clan HOP
; Modified ......: Rhinoceros                                                                                                                                                          ; Clan HOP
; Remarks .......: This file is a part of MyBotRun. Copyright 2015                                                                                                                     ; Clan HOP
; ................ MyBotRun is distributed under the terms of the GNU GPL                                                                                                              ; Clan HOP
; Related .......: No                                                                                                                                                                  ; Clan HOP
; =======================================================================================================================================  

Global $g_ahChkClanHophours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hChkClanHophoursE1 = 0, $g_hChkClanHophoursE2 = 0
Global $g_hLblClanHophoursAM = 0, $g_hLblClanHophoursPM = 0
Global $g_ahLblClanHophoursE = 0
GLobal $g_hLblClanHophours[12] = [0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_abClanHophours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]                                            
                                                                                                                                                                                       ; Clan HOP
Func ClanHop()                                                                                                                                                                         ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	If Not $g_bChkClanHop Then Return                                                                                                                                                   ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	SetLog("Start Clan Hopping", $COLOR_INFO)                                                                                                                                           ; Clan HOP
	Local $sTimeStartedHopping = _NowCalc()                                                                                                                                             ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	Local $iPosJoinedClans = 0, $iScrolls = 0, $iHopLoops = 0, $iErrors = 0                                                                                                             ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	Local $aJoinClanBtn[4] = [157, 476, 0xD0E974, 20] ; Green Join Button on Chat Tab when you are not in a Clan                                                                        ; Clan HOP
	Local $aClanPage[4] = [735, 385, 0xF65D60, 40] ; Red Leave Clan Button on Clan Page                                                                                                 ; Clan HOP
	Local $aClanPageJoin[4] = [767, 397, 0x71BC2D, 40] ; Green Join Clan Button on Clan Page                                                                                            ; Clan HOP
	Local $aJoinClanPage[4] = [725, 310, 0xEBCC81, 40] ; Trophy Amount of Clan Background of first Clan                                                                                 ; Clan HOP
	Local $aClanChat[4] = [105, 650, 0x7BB310, 40] ; *Your Name* joined the Clan Message Check to verify loaded Clan Chat                                                               ; Clan HOP
	Local $aChatTab[4] = [189, 24, 0x706C50, 20] ; Clan Chat Tab on Top, check if right one is selected                                                                                 ; Clan HOP
	Local $aGlobalTab[4] = [189, 24, 0x383828, 20] ; Global Chat Tab on Top, check if right one is selected                                                                             ; Clan HOP
	Local $aClanBadgeNoClan[4] = [151, 307, 0xEE5035, 20]; Orange Tile of Clan Logo on Chat Tab if you are not in a Clan                                                                ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	Local $aClanNameBtn[2] = [89, 63] ; Button to open Clan Page from Chat Tab                                                                                                          ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	$g_iCommandStop = 0 ; Halt Attacking                                                                                                                                                ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	If Not IsMainPage() Then                                                                                                                                                            ; Clan HOP
		SetLog("Couldn't locate Mainscreen!", $COLOR_ERROR)                                                                                                                             ; Clan HOP
		Return                                                                                                                                                                          ; Clan HOP
	EndIf                                                                                                                                                                               ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
	While 1                                                                                                                                                                             ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		ClickP($aAway, 1, 0) ; Click away any open Windows                                                                                                                              ; Clan HOP
		If _Sleep($DELAYRESPOND) Then Return                                                                                                                                            ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If $iErrors >= 10 Then                                                                                                                                                          ; Clan HOP
			Local $y = 0                                                                                                                                                                ; Clan HOP
			SetLog("Too Many Errors occured in current ClanHop Loop. Leaving ClanHopping!", $COLOR_ERROR)                                                                               ; Clan HOP
			While 1                                                                                                                                                                     ; Clan HOP
				If _Sleep(100) Then Return                                                                                                                                              ; Clan HOP
				If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then                                                       ; Clan HOP
					; Clicks chat Button                                                                                                                                                ; Clan HOP
					Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat close button                                                                                      ; Clan HOP
					ExitLoop                                                                                                                                                            ; Clan HOP
				Else                                                                                                                                                                    ; Clan HOP
					If _Sleep(100) Then Return                                                                                                                                          ; Clan HOP
					$y += 1                                                                                                                                                             ; Clan HOP
					If $y > 30 Then                                                                                                                                                     ; Clan HOP
						SetLog("Error finding Clan Tab to close.", $COLOR_ERROR)                                                                                                        ; Clan HOP
						AndroidPageError("ClanHop")                                                                                                                                     ; Clan HOP
						ExitLoop                                                                                                                                                        ; Clan HOP
					EndIf                                                                                                                                                               ; Clan HOP
				EndIf                                                                                                                                                                   ; Clan HOP
			WEnd                                                                                                                                                                        ; Clan HOP
			Return                                                                                                                                                                      ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If $iScrolls >= 8 Then                                                                                                                                                          ; Clan HOP
			CloseCoc(True) ; Restarting to get some new Clans                                                                                                                           ; Clan HOP
			$iScrolls = 0                                                                                                                                                               ; Clan HOP
			$iPosJoinedClans = 0                                                                                                                                                        ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		ForceCaptureRegion()                                                                                                                                                            ; Clan HOP
		If Not _CheckPixel($aChatTab, $g_bCapturePixel) Then ClickP($aOpenChat, 1, 0) ; Clicks chat tab                                                                                 ; Clan HOP
		If _Sleep($DELAYDONATECC4) Then Return                                                                                                                                          ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		Local $iCount = 0                                                                                                                                                               ; Clan HOP
		While 1                                                                                                                                                                         ; Clan HOP
			;If Clan tab is selected.                                                                                                                                                   ; Clan HOP
			If _CheckPixel($aChatTab, $g_bCapturePixel) Then ; color med gray                                                                                                           ; Clan HOP
				ExitLoop                                                                                                                                                                ; Clan HOP
			EndIf                                                                                                                                                                       ; Clan HOP
			;If Global tab is selected.                                                                                                                                                 ; Clan HOP
			If _CheckPixel($aGlobalTab, $g_bCapturePixel) Then ; Darker gray                                                                                                            ; Clan HOP
				If _Sleep($DELAYDONATECC1) Then Return ;small delay to allow tab to completely open                                                                                     ; Clan HOP
				ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab                                                                                                                    ; Clan HOP
				If _Sleep(800) Then Return ; Delay to wait till Clan Page is fully up and visible so the next Color Check won't fail ;)                                                 ; Clan HOP
				ExitLoop                                                                                                                                                                ; Clan HOP
			EndIf                                                                                                                                                                       ; Clan HOP
			;counter for time approx 3 sec max allowed for tab to open                                                                                                                  ; Clan HOP
			$iCount += 1                                                                                                                                                                ; Clan HOP
			If $iCount >= 15 Then ; allows for up to a sleep of 3000                                                                                                                    ; Clan HOP
				SetLog("Clan Chat Did Not Open - Abandon ClanHop")                                                                                                                      ; Clan HOP
				AndroidPageError("ClanHop")                                                                                                                                             ; Clan HOP
				Return                                                                                                                                                                  ; Clan HOP
			EndIf                                                                                                                                                                       ; Clan HOP
		WEnd                                                                                                                                                                            ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If Not _CheckPixel($aClanBadgeNoClan, $g_bCapturePixel) Then ; If Still in Clan                                                                                                 ; Clan HOP
			SetLog("Still in a Clan! Leaving the Clan now")                                                                                                                             ; Clan HOP
			ClickP($aClanNameBtn)                                                                                                                                                       ; Clan HOP
			If _WaitForCheckPixel($aClanPage, $g_bCapturePixel, Default, "Wait for Clan Page:") Then                                                                                    ; Clan HOP
				ClickP($aClanPage)                                                                                                                                                      ; Clan HOP
				If Not ClickOkay("ClanHop") Then                                                                                                                                        ; Clan HOP
					SetLog("Okay Button not found! Starting over again", $COLOR_ERROR)                                                                                                  ; Clan HOP
					$iErrors += 1                                                                                                                                                       ; Clan HOP
					ContinueLoop                                                                                                                                                        ; Clan HOP
				Else                                                                                                                                                                    ; Clan HOP
					SetLog("Successfully left Clan", $COLOR_SUCCESS)                                                                                                                    ; Clan HOP
					If _Sleep(400) Then Return                                                                                                                                          ; Clan HOP
				EndIf                                                                                                                                                                   ; Clan HOP
			Else                                                                                                                                                                        ; Clan HOP
				SetLog("Clan Page did not open! Starting over again", $COLOR_ERROR)                                                                                                     ; Clan HOP
				$iErrors += 1                                                                                                                                                           ; Clan HOP
				ContinueLoop                                                                                                                                                            ; Clan HOP
			EndIf                                                                                                                                                                       ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If _CheckPixel($aJoinClanBtn, $g_bCapturePixel) Then ; Click on Green Join Button on Donate Window                                                                              ; Clan HOP
			SetLog("Opening Join Clan Page", $COLOR_INFO)                                                                                                                               ; Clan HOP
			ClickP($aJoinClanBtn)                                                                                                                                                       ; Clan HOP
		Else                                                                                                                                                                            ; Clan HOP
			SetLog("Join Clan Button not visible! Starting over again", $COLOR_ERROR)                                                                                                   ; Clan HOP
			$iErrors += 1                                                                                                                                                               ; Clan HOP
			ContinueLoop                                                                                                                                                                ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If Not _WaitForCheckPixel($aJoinClanPage, $g_bCapturePixel, Default, "Wait For Join Clan Page:") Then ; Wait For The golden Trophy Background of the First Clan in list         ; Clan HOP
			SetLog("Joinable Clans did not show.. Starting over again", $COLOR_ERROR)                                                                                                   ; Clan HOP
			$iErrors += 1                                                                                                                                                               ; Clan HOP
			ContinueLoop                                                                                                                                                                ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		;Go through all Clans of the list 1 by 1                                                                                                                                        ; Clan HOP
		If $iPosJoinedClans >= 7 Then                                                                                                                                                   ; Clan HOP
			ClickDrag(333, 668, 333, 286, 300)                                                                                                                                          ; Clan HOP
			$iScrolls += 1                                                                                                                                                              ; Clan HOP
			$iPosJoinedClans = 0                                                                                                                                                        ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		Click(161, 286 + ($iPosJoinedClans * 55)) ; Open specific Clans Page                                                                                                            ; Clan HOP
		$iPosJoinedClans += 1                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If Not _WaitForCheckPixel($aClanPageJoin, $g_bCapturePixel, Default, "Wait For Clan Page:") Then ; Check if Clan Page itself opened up                                          ; Clan HOP
			SetLog("Clan Page did not open. Starting over again", $COLOR_ERROR)                                                                                                         ; Clan HOP
			$iErrors += 1                                                                                                                                                               ; Clan HOP
			ContinueLoop                                                                                                                                                                ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		ClickP($aClanPageJoin) ; Join Clan                                                                                                                                              ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If Not _WaitForCheckPixel($aClanChat, $g_bCapturePixel, Default, "Wait For Clan Chat:") Then ; Check for your "joined the Clan" Message to verify that Chat loaded successfully	; Clan HOP
			SetLog("Could not verify loaded Clan Chat. Starting over again", $COLOR_ERROR)                                                                                              ; Clan HOP
			$iErrors += 1                                                                                                                                                               ; Clan HOP
			ContinueLoop                                                                                                                                                                ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		DonateCC(False) ; Start Donate Sequence                                                                                                                                         ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If _Sleep(300) Then Return ; Little Sleep if requests got filled and chat moves                                                                                                 ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		DonateCC(False)                                                                                                                                                                 ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		ForceCaptureRegion()                                                                                                                                                            ; Clan HOP
		If Not _CheckPixel($aChatTab, $g_bCapturePixel) Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab                                                                        ; Clan HOP
		If _Sleep($DELAYDONATECC4) Then Return                                                                                                                                          ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		ClickP($aClanNameBtn) ;  Click the Clan Banner in Top left corner of donate window                                                                                              ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If _WaitForCheckPixel($aClanPage, $g_bCapturePixel, Default, "Wait for Clan Page:") Then ; Leave the Clan                                                                       ; Clan HOP
			ClickP($aClanPage)                                                                                                                                                          ; Clan HOP
			If Not ClickOkay("ClanHop") Then                                                                                                                                            ; Clan HOP
				SetLog("Okay Button not found! Starting over again", $COLOR_ERROR)                                                                                                      ; Clan HOP
				$iErrors += 1                                                                                                                                                           ; Clan HOP
				ContinueLoop                                                                                                                                                            ; Clan HOP
			Else                                                                                                                                                                        ; Clan HOP
				SetLog("Successfully left Clan", $COLOR_SUCCESS)                                                                                                                        ; Clan HOP
				If _Sleep(400) Then Return                                                                                                                                              ; Clan HOP
			EndIf                                                                                                                                                                       ; Clan HOP
		Else                                                                                                                                                                            ; Clan HOP
			SetLog("Clan Page did not open! Starting over again", $COLOR_ERROR)                                                                                                         ; Clan HOP
			$iErrors += 1                                                                                                                                                               ; Clan HOP
			ContinueLoop                                                                                                                                                                ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If $iHopLoops >= 5 Then                                                                                                                                                         ; Clan HOP
			; Update Troops and Spells Capacity                                                                                                                                         ; Clan HOP
			Local $i = 0                                                                                                                                                                ; Clan HOP
			While 1                                                                                                                                                                     ; Clan HOP
				If _Sleep(100) Then Return                                                                                                                                              ; Clan HOP
				If _CheckPixel($aCloseChat, $g_bCapturePixel) Then                                                                                                                      ; Clan HOP
					; Clicks chat Button                                                                                                                                                ; Clan HOP
					Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat close button                                                                                      ; Clan HOP
					ExitLoop                                                                                                                                                            ; Clan HOP
				Else                                                                                                                                                                    ; Clan HOP
					If _Sleep(100) Then Return                                                                                                                                          ; Clan HOP
					$i += 1                                                                                                                                                             ; Clan HOP
					If $i > 30 Then                                                                                                                                                     ; Clan HOP
						SetLog("Error finding Clan Tab to close.", $COLOR_ERROR)                                                                                                        ; Clan HOP
						AndroidPageError("ClanHop")                                                                                                                                     ; Clan HOP
						ExitLoop                                                                                                                                                        ; Clan HOP
					EndIf                                                                                                                                                               ; Clan HOP
				EndIf                                                                                                                                                                   ; Clan HOP
			WEnd                                                                                                                                                                        ; Clan HOP
			TrainRevamp()                                                                                                                                                               ; Clan HOP
			$iHopLoops = 0                                                                                                                                                              ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		EndIf                                                                                                                                                                           ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
		If _DateDiff("h", $sTimeStartedHopping, _NowCalc) > 1 Then ExitLoop                                                                                                             ; Clan HOP
		$iHopLoops += 1                                                                                                                                                                 ; Clan HOP
	WEnd                                                                                                                                                                                ; Clan HOP
                                                                                                                                                                                       ; Clan HOP
EndFunc   ;==>ClanHop                                                                                                                                                                  

Func SetupClanHopGUI($x, $y)
	Local $xStart = $x
	Local $yStart = $y

		Local $grpClanHopAF = GUICtrlCreateGroup(GetTranslatedFileIni("AF_Mod", 15, "Clan Hop"), $x, $y, 430, 250)
		$y += 20

		$g_bChkClanHop = GUICtrlCreateCheckbox(GetTranslatedFileIni("AF_Mod", 15, "Clan Hop"), $x + 120, $y+45, -1, -1)
		Local $sTxtTip = GetTranslatedFileIni("AF_Mod", 15, "Clan Hop")
		_GUICtrlSetTip(-1, $sTxtTip)
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkSCIDSwitchAccAF")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		$x = $xStart + 10
		$y = $yStart + 80
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x, $y, 300, 20, $BS_MULTILINE)
		$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour",  "Hour") & ":", $x , $y, -1, 15)
		Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblClanHophours[0] =  GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		$g_hLblClanHophours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		$g_hLblClanHophours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		$g_hLblClanHophours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		$g_hLblClanHophours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		$g_hLblClanHophours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		$g_hLblClanHophours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		$g_hLblClanHophours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		$g_hLblClanHophours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		$g_hLblClanHophours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		$g_hLblClanHophours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		$g_hLblClanHophours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		$g_ahLblClanHophoursE = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)

		$y += 15
		$g_ahChkClanHophours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_hChkClanHophoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
		   GUICtrlSetOnEvent(-1, "chkClanHophoursE1")
		$g_hLblClanHophoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)

		$y += 15
		$g_ahChkClanHophours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_hChkClanHophoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
		   GUICtrlSetOnEvent(-1, "chkClanHophoursE2")
		$g_hLblClanHophoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func ChkClanHophours()
	For $i = 0 to 23
		$g_abClanHophours[$i] = (GUICtrlRead($g_ahChkClanHophours[$i]) = $GUI_CHECKED ? 1: 0)
	Next
EndFunc

Func chkClanHophoursE1()
	If GUICtrlRead($g_hChkClanHophoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkClanHophours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkClanHophoursE1, $GUI_UNCHECKED)
	ChkClanHophours()
EndFunc   ;==>chkClanHophoursE1

Func chkClanHophoursE2()
	If GUICtrlRead($g_hChkClanHophoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkClanHophours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkClanHophoursE2, $GUI_UNCHECKED)
	ChkClanHophours()
EndFunc   ;==>chkClanHophoursE2

Func saveClanHopSetting()
	Local $string = ""
	For $i = 0 To 23
		$string &= (GUICtrlRead($g_ahChkClanHophours[$i]) = $GUI_CHECKED ? 1: 0) & "|"
	Next
	_Ini_Add("ClanHop", "ClanHopPlannedRequestHours", $string)
	$string = ""
	_Ini_Add("donate", "chkClanHop", $g_bChkClanHop ? 1 : 0)	; Clan HOP
EndFunc

Func readClanHopSetting()
	$g_abClanHophours = StringSplit(IniRead($g_sProfileConfigPath, "ClanHop", "ClanHopPlannedRequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
 	$g_bChkClanHop = (IniRead($g_sProfileConfigPath, "donate", "chkClanHop", "0") = "1")	; Clan HOP

	EndFunc

Func applyClanHopSetting()
	For $i = 0 To 23
		GUICtrlSetState($g_ahChkClanHophours[$i], ($g_abClanHophours[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
		
	GUICtrlSetState($g_hChkClanHop, $g_bChkClanHop ? $GUI_CHECKED : $GUI_UNCHECKED)	; Clan HOP
	$g_bChkClanHop = (GUICtrlRead($g_hChkClanHop) = $GUI_CHECKED)	; Clan HOP

Next
EndFunc

