; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot Lib
; by Sw1ftb
; -----------------------------------------------------------------------------------------

fullScreenOption := false ; Steam borderless fullscreen option

SetTitleMatchMode, 3 ; Steam [3] or browser [regex] version?

; If browser, you need to verify (or adjust) the top margin setting.
; Start Windows Spy, then check the relative y position of the top edge of the CH area (below the logo).
browserTopMargin := 230 ; Firefox [230], IE [198], Chrome (steals focus!) [222]

; -----------------------------------------------------------------------------------------
; -- BEWARE!        CHANGING ANYTHING BELOW THIS LINE IS ON YOUR OWN RISK        BEWARE! --
; -----------------------------------------------------------------------------------------

libVersion=1.1

winName=Clicker Heroes

global ProgressBar, ProgressBarTime ; progress bar controls

exitThread := false
exitDRThread := false

chWinId := ""

; All the script coordinates are based on these four default dimensions.
chWidth := 1136
chHeight := 640
chMargin := 8
chTopMargin := 30

chTotalWidth := chWidth + chMargin * 2
chTotalHeight := chHeight + chMargin + chTopMargin

; Calculated
leftMarginOffset := 0
topMarginOffset := 0

; Calculated
aspectRatio := 1
hBorder := 0
vBorder := 0

wSplash := 200

zzz := 200 ; sleep delay (in ms) after a click
lvlUpDelay := 5 ; time (in seconds) between lvl up clicks
barUpdateDelay := 30 ; time (in seconds) between progress bar updates
coinPickUpDelay := 7 ; time (in seconds) needed to pick up all coins from a clickable
nextHeroDelay := 5 ; extra gold farm delay (in seconds) between heroes

; -- Coordinates --------------------------------------------------------------------------

; Top LVL UP button when scrolled to the bottom
xLvl := 100
yLvl := 285
oLvl := 107 ; offset to next button

; Ascension button
xAsc := 310
yAsc := 434

buttonSize := 35

; Ascend Yes button
xYes := 500
yYes := 445

xCombatTab := 50
yCombatTab := 130

xRelicTab := 380
yRelicTab := 130

xRelic := 103
yRelic := 380

xSalvageJunk := 280
ySalvageJunk := 470

xDestroyYes := 500
yDestroyYes := 430

; Scrollbar
xScroll := 554
yUp := 219
yDown := 653
top2BottomClicks := 46

xGilded := 95
yGilded := 582

xGildedClose := 1090
yGildedClose := 54

rangers := ["Dread Knight", "Atlas", "Terra", "Phthalo", "Banana", "Lilin", "Cadmia", "Alabaster", "Astraea"]

rangerPositions := {}
rangerPositions[1] := {x:180, y:435}
rangerPositions[2] := {x:380, y:435}
rangerPositions[3] := {x:580, y:435}
rangerPositions[4] := {x:780, y:435}
rangerPositions[5] := {x:980, y:435}
rangerPositions[6] := {x:180, y:495}
rangerPositions[7] := {x:380, y:495}
rangerPositions[8] := {x:580, y:495}
rangerPositions[9] := {x:780, y:495}


; Buy Available Upgrades button
xBuy := 300
yBuy := 582

xHero := 474
yHero := 227

xMonster := 920
yMonster := 164

; Tab safety zone (script will pause when entering)
xSafetyZoneL := 7
xSafetyZoneR := 425
ySafetyZoneT := 104
ySafetyZoneB := 154

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

; No smart image recognition, so we click'em all!
getClickable() {
	global
	; Break idle on purpose to get the same amount of gold every run
	loop 3 {
		clickPos(xMonster, yMonster)
	}
    clickPos(524, 487)
    clickPos(747, 431)
    clickPos(760, 380)
    clickPos(873, 512)
    clickPos(1005, 453)
    clickPos(1053, 443)
}

clientCheck() {
	WinGet, activeWinId, ID, A ; remember current active window...
	if (A_TitleMatchMode = 3) {
		calculateSteamAspectRatio() ; Steam
	} else {
		calculateBrowserOffsets() ; Browser
		fullScreenOption := false
	}
	WinActivate, ahk_id %activeWinId% ; ... and restore focus back
}

calculateBrowserOffsets() {
	global
	winName=Lvl.*Clicker Heroes.*
	IfWinExist, % winName
	{
		showSplash("Calculating browser offsets...", 2, 0)
		WinActivate
		WinGetPos, x, y, w, h
		WinGet, chWinId, ID, A

		local leftMargin := (w - chWidth) // 2
		leftMarginOffset := leftMargin - chMargin
		topMarginOffset := browserTopMargin - chTopMargin
	} else {
		showSplash("Clicker Heroes started in browser?",3,2)
	}
}

calculateSteamAspectRatio() {
	global
	IfWinExist, % winName
	{
		WinActivate
		WinGetPos, x, y, w, h
		WinGet, chWinId, ID, A

		; Fullscreen sanity checks
		if (fullScreenOption) {
			if (w <> A_ScreenWidth || h <> A_ScreenHeight) {
				showSplash("Bot expect fullscreen mode!",3,2)
				return
			}
		} else if (w = A_ScreenWidth && h = A_ScreenHeight) {
			showSplash("Bot don't expect fullscreen mode!",3,2)
			return
		}

		if (w != chTotalWidth || h != chTotalHeight) {
			showSplash("Calculating Steam aspect ratio...", 2, 0)

			local winWidth := fullScreenOption ? w : w - 2 * chMargin
			local winHeight := fullScreenOption ? h : h - chTopMargin - chMargin
			local horizontalAR := winWidth/chWidth
			local verticalAR := winHeight/chHeight

			; Take the lowest aspect ratio and calculate border size
			if (horizontalAR < verticalAR) {
				aspectRatio := horizontalAR
				vBorder := (winHeight - chHeight * aspectRatio) // 2
			} else {
				aspectRatio := verticalAR
				hBorder := (winWidth - chWidth * aspectRatio) // 2
			}
		}
	} else {
		showSplash("Clicker Heroes started?",3,2)
	}
}

clickPos(xCoord, yCoord, clickCount:=1) {
	global
	local xAdj := getAdjustedX(xCoord)
	local yAdj := getAdjustedY(yCoord)
 	ControlClick, x%xAdj% y%yAdj%, ahk_id %chWinId%,,, %clickCount%, NA
}

getAdjustedX(x) {
	global
	local leftMargin := fullScreenOption ? 0 : chMargin + leftMarginOffset
	return round(aspectRatio*(x - chMargin) + leftMargin + hBorder)
}

getAdjustedY(y) {
	global
	local topMargin := fullScreenOption ? 0 : chTopMargin + topMarginOffset
	return round(aspectRatio*(y - chTopMargin) + topMargin + vBorder)
}

playWarningSound() {
	if (playSounds) {
		SoundPlay, %A_WinDir%\Media\tada.wav
	}
}

playNotificationSound() {
	if (playSounds) {
		SoundPlay, %A_WinDir%\Media\Windows User Account Control.wav
	}
}

showSplash(text, seconds:=2, sound:=1) {
	global
	if (seconds > 0) {
		if (showSplashTexts) {
			progress,% "w" wSplash " x" xSplash " y" ySplash " zh0 fs10", %text%,,% scriptName " v" scriptVersion
		}
		if (sound = 1) {
			playNotificationSound()
		} else if (sound = 2) {
			playWarningSound()
		}
		sleep % seconds * 1000
		progress, off
	}
}

startProgress(title, min:=0, max:=100) {
	global
	if (showProgressBar) {
		gui, new
		gui, margin, 0, 0
		gui, font, s18
		gui, add, progress,% "w300 h28 range" min "-" max " -smooth vProgressBar"
		gui, add, text, w92 vProgressBarTime x+2
		gui, show,% "na x" xProgressBar " y" yProgressBar,% scriptName " - " title
	}
}

updateProgress(position, remainingTime) {
	if (showProgressBar) {
		guicontrol,, ProgressBar,% position
		guicontrol,, ProgressBarTime,% formatSeconds(remainingTime)
	}
}

stopProgress() {
	if (showProgressBar) {
		gui, destroy
	}
}

formatSeconds(s) {
    time := 19990101 ; *Midnight* of an arbitrary date.
    time += %s%, seconds
	FormatTime, timeStr, %time%, HH:mm:ss
    return timeStr
}

secondsSince(startTime) {
	return (A_TickCount - startTime) // 1000
}

toggleFlag(flagName, byref flag) {
	flag := !flag
	flagValue := flag ? "On" : "Off"
	showSplash("Toggled " . flagName . " " . flagValue)
}
