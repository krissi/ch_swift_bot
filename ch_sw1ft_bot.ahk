; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot
; by Sw1ftb

; Script home @ http://redd.it/3a3bmy

; Quick start guide:

; 1. Read the 1st half of the FAQ @ http://pastebin.com/awy9p847
; 2. Follow the instructions in the mandatory configuration section.
; 3. Read the 2nd half of the FAQ.

; Commonly changed optional settings:
; * speedRunTime - depending on the end zone lvl you aim at, adjust as needed
; * autoAscend - for those over night farm sessions

; If you can speed run to 1700 or above (in less than 30 minutes) and have a hybrid build (with Bhaal, Frag, 
; Jugg and co.), you might want to try the Deep run option. It is designed to start off where a speed run 
; finish and will only lvl up the same ranger till the end. Just set the deepRunTime duration and hit Ctrl+F2.

; Main Hotkeys:

; Ctrl+F1 to loop speed runs
; Ctrl+F2 to start a deep run
; Pause to pause/unpause the script at any time
; Alt+Pause to abort runs (or an auto ascension)
; Alt+F5 to reload the script

; See the Hotkeys section for all available commands.

; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook

#Include ch_bot_lib.ahk

scriptName=CH Sw1ft Bot
scriptVersion=2.0
minLibVersion=1.0

; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

; In Clicker Heroes, turn off the "Show relic found popups" option.

; What game client are you running?
; * Steam: Do the configuration at default resolution (1136x640).
;   Right-click the script taskbar icon, start Windows Spy and verify the client size.
; * Browser: Change "SetTitleMatchMode" and "browserTopMargin" in the ch_bot_lib.ahk file.

; Refresh script with Alt+F5.

; Quick test #1: Ctrl+Alt+F1 should scroll down to the bottom
; Quick test #2: Ctrl+Alt+F2 should switch to the relics tab and then back

; -- Speed run ----------------------------------------------------------------------------

; Set to your Iris level in game.
irisLevel := 1109 ; try to keep your Iris within 1000-1100 levels of your optimal zone

; 1:dread knight, 2:atlas, 3:terra, 4:phthalo, 5:banana, 6:lilin, 7:cadmia, 8:alabaster, 9:astraea
gildedRanger := 6 ; the number of your main guilded ranger

; -----------------------------------------------------------------------------------------

; A list of clicks needed to scroll down 4 heroes at a time, starting from the top.
initDownClicks := [6,7,6,7,6,3]

; This y coordinate is supposed to keep itself inside the top lvl up button when scrolling down according to the above "clicking pattern".
yLvlInit := 240 

; To get these two right, do this:
; 1. Ascend with a "clickable" available.
; 2. Click Alt+F1 (the script should pick up the clickable).
; 3. Scroll down to the bottom. What ranger is last?
; 4. From the list below, pick the matching settings:

; Astraea      [6,5,6,5,6,3], 241
; Alabaster    [6,6,5,6,6,3], 259
; Cadmia       [6,6,6,6,6,3], 240
; Lilin        [6,6,6,6,6,3], 285
; Banana       [6,7,6,7,6,3], 240
; Phthalo      [6,7,7,6,7,3], 273
; Terra        [7,7,7,7,7,3], 240
; Atlas        [7,7,7,8,7,3], 273
; Dread Knight [7,8,7,8,7,4], 257

; E.g. if Phthalo is last, you set initDownClicks to [6,7,7,6,7,3] and yLvlInit to 273.

; 5. Now click Alt+F2 (the script should level up and upgrade all heroes from Cid to Frostleaf).

; If some heroes where missed, do this:
; * Set the below zzz setting to 500 and reload the script with Alt+F5.
; * Scroll to the top and position your cursor dead center on Cid's lvl up button.
; * Click Alt+F2 again. When you get to the heroes that where missed, try to see if you need 
;   to slightly move up or down. Redo this till you find a position that looks to be inside 
;   all top lvl up buttons (but the last), then click Alt+MiddleMouseButton.
;   Update yLvlInit with this new y coordinate and try Alt+F2 once again.
;   If it works now, then set back zzz to 200 and reload the script (Alt+F5).

; 6. Click Alt+F3 to start a speed run. If the script got to a ranger to early and could 
;    not buy all upgrades at once, then increase the thresholdFactor below.
; 7. When done, click Alt+F4 to run the ascend code.
;    If it didn't ascend, adjust the ascDownClicks setting below and try again.

ascDownClicks := 26 ; # of down clicks needed to get the ascension button center:ish (after a full speed run)

; If all worked so far, you are set to go!

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; (Steam only) Want to run borderless fullscreen?
; 1. In Clicker Heroes, turn on the "Full Screen" option.
; 2. Change "fullScreenOption" to "true" in the ch_bot_lib.ahk file.
; 3. Refresh with Alt+F5.

zzz := 200 ; sleep delay (in ms) after a click
lvlUpDelay := 5 ; time (in seconds) between lvl up clicks

; -- Speed run ----------------------------------------------------------------------------

speedRunTime := 30 ; minutes (usually between 25 and 35 minutes)

; Adjust this setting so the script reach and can level your gilded ranger to >150 instantly.
; Each step adds or subtracts around 35 levels.
thresholdFactor := 0 ; -2, -1, 0, 1 or 2

activateSkillsAtStart := true

hybridMode := false ; chain a deep run when the speed run finish

; Added flag for v0.19.
autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention!
autoAscendDelay := 15 ; warning timer (in seconds) before ascending

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := false

; -- Deep run -----------------------------------------------------------------------------

deepRunTime := 60*2 ; minutes

coolDownTime := 15 ; assuming maxed Vaagur (lvl 15)

clickableHuntDelay := 15 ; hunt for a clickable every 15s
stopHuntThreshold := 30 ; stop hunt when this many minutes remain of a deep run

cpsTarget := 25 ; monster clicks per second

; If you want a stable long deep run, I strongly recommend using the external monster clicker script.
useExternalClicker := true

; -- Look & Feel --------------------------------------------------------------------------

; true or false
global showSplashTexts := true
global showProgressBar := true
global playSounds := true

; Splash text window position
xSplash := A_ScreenWidth // 2 - wSplash // 2
ySplash := A_ScreenHeight // 2

; Progress bar position
xProgressBar := 20
yProgressBar := 20

; If you run with a dual/tripple monitor setup, you can move windows
; right or left by adding or subtracting A_ScreenWidth from the x-parameters.

; -----------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------

if (libVersion < minLibVersion) {
	showSplash("The bot lib version must be " . minLibVersion . " or higher!",5,2)
	ExitApp
}

clientCheck()

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift, !=Alt, ^=Ctrl)
; -----------------------------------------------------------------------------------------

; Show the cursor position with Alt+Middle Mouse Button
!mbutton::
	mousegetpos, xpos, ypos
	msgbox,,% scriptName " v" scriptVersion,% "Cursor position: x" xpos-leftMarginOffset " y" ypos-topMarginOffset
return

; Pause/Unpause script
Pause::Pause
return

; Abort speed/deep runs and auto ascensions with Alt+Pause
!Pause::
	showSplash("Aborting...")
	exitThread := true
	exitDRThread := true
return

; Quick tests:
; Ctrl+Alt+F1 should scroll down to the bottom
; Ctrl+Alt+F2 should switch to the relics tab and then back

^!F1::
	scrollToBottom()
return

^!F2::
	switchToRelicTab()
	switchToCombatTab()
return

; Alt+F1 to F4 are here to test the individual parts of the full speed run loop

!F1::
	getClickable()
return

!F2::
	initRun()
return

!F3::
	speedRun()
return

!F4::
	ascend(autoAscend)
return

; Reload script with Alt+F5
!F5::
	showSplash("Reloading bot...", 1)
	Reload
return

; Speed run loop.
; Use to farm Hero Souls
^F1::
	mode := hybridMode ? "hybrid" : "speed"
	showSplash("Starting " . mode . " runs...")
	loop
	{
		getClickable()
	    sleep % coinPickUpDelay * 1000
		initRun()
		toggleMode() ; toggle to progression mode
		if (activateSkillsAtStart) {
			activateSkills()
			activateEdrSkills()
		}
		speedRun()
		if (hybridMode) {
			deepRun()
		}
		ascend(autoAscend)
	}
return

; Deep run.
; Use (after a speed run) to get a few new gilds every now and then
^F2::
	deepRun()
return

+!F1::
	toggleFlag("autoAscend", autoAscend)
return

+!F2::
	toggleFlag("playSounds", playSounds)
return

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

; Level up and upgrade all heroes
initRun() {
	global

	switchToCombatTab()
	clickPos(xHero, yHero) ; prevent initial upgrade ctrlClick fails

	upgrade(initDownClicks[1],2,,2) ; cid --> brittany
	upgrade(initDownClicks[2]) ; fisherman --> leon
	upgrade(initDownClicks[3]) ; seer --> mercedes
	upgrade(initDownClicks[4],,,,2) ; bobby --> king
	upgrade(initDownClicks[5],2,,,2) ; ice --> amenhotep
	upgrade(initDownClicks[6],,,2) ; beastlord --> shinatobe
	upgrade(0,,,,,true) ; grant & frostleaf

	scrollToBottom()
	buyAvailableUpgrades()
}

upgrade(times, cc1:=1, cc2:=1, cc3:=1, cc4:=1, skip:=false) {
	global

	if (!skip) {
		ctrlClick(xLvl, yLvlInit, cc1)
		ctrlClick(xLvl, yLvlInit + oLvl, cc2)
	}
	ctrlClick(xLvl, yLvlInit + oLvl*2, cc3)
	ctrlClick(xLvl, yLvlInit + oLvl*3, cc4)

	scrollDown(times)
}

; All heroes/rangers are expected to "insta-kill" everything at max speed (i.e. around
; 7 minutes per 250 levels). Only the last 2-3 minutes should slow down slightly.
speedRun() {
	global

	local stint := 0
	local stints := 2
	local tMax := 7 * 60
	local lMax := 250
	local lvlThreshold := 35 * thresholdFactor
	local zoneLvl := gildedRanger * lMax + lvlThreshold ; approx zone lvl where we can buy our gilded ranger @ lvl 150
	local lvls := zoneLvl - irisLevel ; lvl's to get there
	local midStintTime := 0

	if (lvls > lMax) ; add a mid stint if needed
	{
		midStintTime := tMax
		lvls -= lMax
		stints += 1
	}
	local firstStintTime := ceil(lvls * tMax / lMax)
	local srDuration := speedRunTime * 60
	local totalClickDelay := (srDuration // lvlUpDelay) * zzz // 1000
	local lastStintTime := srDuration - firstStintTime - midStintTime - totalClickDelay - nextHeroDelay * stints
	local lastStintButton := gildedRanger = 9 ? 3 : 2 ; special case for Astraea

	showSplash("Starting speed run...")

	switchToCombatTab()

	if (irisLevel < lMax + lvlThreshold) ; Iris high enough to start with a ranger?
	{
		scrollDown(initDownClicks[1])
		lvlUp(firstStintTime, 0, 3, ++stint, stints) ; nope, let's bridge with Samurai
		scrollToBottom()
	} else {
		scrollToBottom()
		lvlUp(firstStintTime, 1, 1, ++stint, stints)
		scrollWayDown(3)
	}
	if (midStintTime) {
		lvlUp(midStintTime, 1, 2, ++stint, stints)
		scrollWayDown(2)
	}
	lvlUp(lastStintTime, 1, lastStintButton, ++stint, stints)

	showSplash("Speed run completed.")
}

deepRun() {
	global

	exitDRThread := false
	monsterClicks := 0
	local drDuration := deepRunTime * 60
	local cds := coolDownTime * 60
	local y := yLvl + oLvl * 2 ; 3rd lvl up button

	showSplash("Starting deep run...")

	startMouseMonitoring()
	startProgress("Deep Run Progress", 0, drDuration // barUpdateDelay)

	local drStartTime := A_TickCount

	fastMode()

	setTimer, endDeepRun, % -drDuration * 1000 ; run only once

	if (useExternalClicker) {
		send {blind}{shift down}{f1}{shift up}
	} else {
		setTimer, slayMonsters, % 1000 / cpsTarget
	}

	local stopHuntIndex := drDuration - stopHuntThreshold * 60
	local toggle := true

	while(!exitDRThread)
	{
		if (mod(A_Index, cds) = 0 or A_Index = 1) {
			if (toggle) {
				activateSkills()
				activateEdrSkills()
			} else {
				activateErSkills()
				activateSkills()
			}
			toggle := !toggle
		}
		if (mod(A_Index, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y, 1, 0)
		}
		if (mod(A_Index, clickableHuntDelay) = 0 and A_Index < stopHuntIndex) {
			getClickable()
		}
		updateProgress(A_Index // barUpdateDelay, drDuration - A_Index)
		sleep 1000
	}

	if (useExternalClicker) {
		send {blind}{shift down}{pause}{shift up}
	} else {
		setTimer, slayMonsters, off
	}

	local clicksPerSecond := round(monsterClicks / secondsSince(drStartTime), 2)

	stopProgress()
	stopMouseMonitoring()

	local cpsText := !useExternalClicker ? " (" . clicksPerSecond . " cps)." : "."
	showSplash("Deep run ended" . cpsText, 5)
}

lvlUp(seconds, buyUpgrades, button, stint, stints) {
	global

	exitThread := false
	local y := yLvl + oLvl * (button - 1)
	local title := "Speed Run Progress (" . stint . "/" . stints . ")"

	startMouseMonitoring()

	if (buyUpgrades) {
		ctrlClick(xLvl, y)
		buyAvailableUpgrades()
	}
	maxClick(xLvl, y)

	startProgress(title, 0, seconds // barUpdateDelay)
	loop % seconds
	{
		if (mod(A_Index, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y)
		}
		updateProgress(A_Index // barUpdateDelay, seconds - A_Index)
		if (exitThread) {
			stopProgress()
			stopMouseMonitoring()
			showSplash("Speed run aborted!")
			exit
		}
		sleep 1000
	}
	stopProgress()
	stopMouseMonitoring()
}

ascend(autoYes:=false) {
	global
	exitThread := false
	local extraClicks := 6
	local y := yAsc - extraClicks * buttonSize

	if (autoYes) {
		showSplash(autoAscendDelay . " seconds till ASCENSION! (Abort with Alt+Pause)", autoAscendDelay, 2)
		if (exitThread) {
			showSplash("Ascension aborted!")
			exit
		}
	} else {
		playWarningSound()
		msgbox, 4,% scriptName " v" scriptVersion,Salvage Junk Pile & Ascend?
		ifmsgbox no
			exit
	}

	salvageJunkPile() ; must salvage junk relics before ascending

	switchToCombatTab()

	scrollDown(ascDownClicks)
	sleep % zzz * 2

	; Scrolling is not an exact science, hence we click above, center and below
	loop % 2 * extraClicks + 1
	{
		clickPos(xAsc, y)
		y += buttonSize
	}
	sleep % zzz * 4
	clickPos(xYes, yYes)
	sleep % zzz * 2
}

salvageJunkPile() {
	global

	switchToRelicTab()
	screenShot()
	clickPos(xSalvageJunk, ySalvageJunk)
	sleep % zzz * 4
	clickPos(xDestroyYes, yDestroyYes)
	sleep % zzz * 2
}

screenShot() {
	global

	if (autoAscend && screenShotRelics) {
		IfWinExist, % winName
		{
			WinActivate
			clickPos(xRelic, yRelic) ; focus
			sleep % zzz
			send {blind}{f12} ; Steam screenshot
			sleep % zzz
			clickPos(xRelic+100, yRelic) ; remove focus
		}
	}
}

switchToRelicTab() {
	global
	clickPos(xRelicTab, yRelicTab)
	sleep % zzz * 2
}

switchToCombatTab() {
	global
	clickPos(xCombatTab, yCombatTab)
	sleep % zzz * 4
}

buyAvailableUpgrades() {
	global
	clickPos(xBuy, yBuy)
	sleep % zzz * 3
}

scrollUp(clickCount:=1) {
	global
	fastMode()
	clickPos(xScroll, yUp, clickCount)
	slowMode()
	sleep % zzz * 2
}

scrollDown(clickCount:=1) {
	global
	fastMode()
	clickPos(xScroll, yDown, clickCount)
	slowMode()
	sleep % zzz * 2
}

; Scroll down fix when at bottom and scroll bar don't update correctly
scrollWayDown(clickCount:=1) {
	global
	scrollUp()
	scrollDown(clickCount + 1)
	sleep % nextHeroDelay * 1000
}

scrollToTop() {
	global
	scrollUp(top2BottomClicks)
	sleep % 1000 - zzz
}

scrollToBottom() {
	global
	scrollDown(top2BottomClicks)
	sleep % 1000 - zzz
}

maxClick(xCoord, yCoord) {
	global
	ControlSend,, {shift down}{q down}, % winName
	clickPos(xCoord, yCoord, clickCount)
	ControlSend,, {q up}{shift up}, % winName
	sleep % zzz
}

ctrlClick(xCoord, yCoord, clickCount:=1, sleepSome:=1) {
	global
	ControlSend,, {ctrl down}, % winName
	clickPos(xCoord, yCoord, clickCount)
	ControlSend,, {ctrl up}, % winName
	if (sleepSome) {
		sleep % zzz
	}
}

; Toggle between farm and progression modes
toggleMode() {
	global
	ControlSend,, {a down}{a up}, % winName
}

activateSkills() {
	global
	ControlSend,, {1 down}{1 up}, % winName ; clickstorm
	ControlSend,, {2 down}{2 up}, % winName ; powersurge
	ControlSend,, {3 down}{3 up}, % winName ; lucky strikes
	ControlSend,, {4 down}{4 up}, % winName ; metal detector
	ControlSend,, {5 down}{5 up}, % winName ; golden clicks
	ControlSend,, {7 down}{7 up}, % winName ; super clicks
}

activateEdrSkills() {
	global
	ControlSend,, {8 down}{8 up}, % winName ; energize
	ControlSend,, {6 down}{6 up}, % winName ; dark ritual
	ControlSend,, {9 down}{9 up}, % winName ; reload
}

activateErSkills() {
	global
	ControlSend,, {8 down}{8 up}, % winName ; energize
	ControlSend,, {9 down}{9 up}, % winName ; reload
}

startMouseMonitoring() {
	setTimer, checkMousePosition, 250
}

stopMouseMonitoring() {
	setTimer, checkMousePosition, off
}

; -----------------------------------------------------------------------------------------
; -- Subroutines
; -----------------------------------------------------------------------------------------

endDeepRun:
	exitDRThread := true
return

slayMonsters:
	clickPos(xMonster, yMonster)
	monsterClicks++
return

checkMousePosition:
	MouseGetPos,,, window
	if (window = WinExist(winName)) {
		WinActivate
		MouseGetPos, x, y

		leftMargin := fullScreenOption ? 0 : chMargin + leftMarginOffset
		topMargin := fullScreenOption ? 0 : chTopMargin + topMarginOffset

		xL := round(aspectRatio*(xSafetyZoneL - chMargin) + leftMargin + hBorder)
		xR := round(aspectRatio*(xSafetyZoneR - chMargin) + leftMargin + hBorder)
		yT := round(aspectRatio*(ySafetyZoneT - chTopMargin) + topMargin + vBorder)
		yB := round(aspectRatio*(ySafetyZoneB - chTopMargin) + topMargin + vBorder)

		if (x > xL && x < xR && y > yT && y < yB) {
			playNotificationSound()
			msgbox,,% scriptName " v" scriptVersion,Click safety pause engaged. Continue?
		}
	}
return
