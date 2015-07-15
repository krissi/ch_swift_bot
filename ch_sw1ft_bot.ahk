; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot
; by Sw1ftb

; Script home @ http://redd.it/3a3bmy

; -- Complete file list -------------------------------------------------------------------

; ch_bot_lib.ahk      https://gist.github.com/swiftb/940bd6da6ad2bc9199b0#file-ch_bot_lib-ahk
; ch_sw1ft_bot.ahk    https://gist.github.com/swiftb/940bd6da6ad2bc9199b0#file-ch_sw1ft_bot-ahk
; monster_clicker.ahk https://gist.github.com/swiftb/940bd6da6ad2bc9199b0#file-monster_clicker-ahk

; -- Quick start guide --------------------------------------------------------------------

; 1. Install the latest version of AutoHotkey from http://ahkscript.org/
; 2. Follow the instructions in the Mandatory Configuration section.

; Problems/questions? Read the FAQ @ http://pastebin.com/awy9p847

; -- Hotkeys ------------------------------------------------------------------------------

; -- Configuration
; Alt+F5 to reload the script (needed after configuration changes and a client window resize)
; Alt+MiddleMouseButton to show the current cursor position

; -- Quick tests (run these first)
; Ctrl+Alt+F1 should scroll down to the bottom
; Ctrl+Alt+F2 should switch to the relics tab and then back

; -- Speed run loop function tests
; Alt+F1 to test the getClickable() function
; Alt+F2 to test the initRun() function
; Alt+F3 to test the speedRun() function
; Alt+F4 to test the ascend() function

; -- Main bot functions
; Ctrl+F1 to loop speed runs
; Ctrl+F2 to start a deep run (requires a running monster_clicker.ahk)

; Pause to pause/unpause the script
; Alt+Pause to abort active speed/deep runs and an initiated auto ascension

; -- Re-gilding
; Ctrl+F6 to set previous ranger as re-gild target
; Ctrl+F7 to set next ranger as re-gild target
; Ctrl+F8 to move reGildCount gilds to the target ranger (will pause the monster clicker if running)

; -- Toggle boolean (true/false) settings
; Shift+Ctrl+F1 to toggle the autoAscend flag
; Shift+Ctrl+F2 to toggle the screenShotRelics flag
; Shift+Ctrl+F3 to toggle the playSounds flag

; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook

#Include %A_ScriptDir%
#Include ch_bot_lib.ahk

SetControlDelay, -1

scriptName=CH Sw1ft Bot
scriptVersion=2.1
minLibVersion=1.1

; -----------------------------------------------------------------------------------------
; -- Mandatory Configuration
; -----------------------------------------------------------------------------------------

; In Clicker Heroes, turn off the "Show relic found popups" option.

; What game client are you running?
; * Steam: Do the configuration at default window size (1136x640).
;   Right-click the script taskbar icon, start Windows Spy and verify the client size.
; * Browser: Change "SetTitleMatchMode" and "browserTopMargin" in the ch_bot_lib.ahk file.

; Refresh script with Alt+F5.

; Quick test #1: Ctrl+Alt+F1 should scroll down to the bottom
; Quick test #2: Ctrl+Alt+F2 should switch to the relics tab and then back

; -- Speed run ----------------------------------------------------------------------------

; Set to your Iris level in game.
irisLevel := 1299 ; try to keep your Iris within 1000-1100 levels of your optimal zone

; 1:dread knight, 2:atlas, 3:terra, 4:phthalo, 5:banana, 6:lilin, 7:cadmia, 8:alabaster, 9:astraea
gildedRanger := 7 ; the number of your main guilded ranger

; -- Init run & ascend --------------------------------------------------------------------

; These settings are affected by your Iris level.

; A list of clicks needed to scroll down 4 heroes at a time, starting from the top.
initDownClicks := [6,6,6,6,6,3]

; This y coordinate is supposed to keep itself inside the top lvl up button when scrolling down according to the above "clicking pattern".
yLvlInit := 285

; To get these two right, do this:
; 1. Ascend with a "clickable" available.
; 2. Click Alt+F1 (the script should pick up the clickable).
; 3. Scroll down to the bottom. What ranger is last?
; 4. From the list below, pick the matching settings:

; Astraea      [6,5,6,5,6,3], 241 (Iris > 2010)
; Alabaster    [6,6,5,6,6,3], 259 (Iris > 1760)
; Cadmia       [6,6,6,6,6,3], 240 (Iris > 1510)
; Lilin        [6,6,6,6,6,3], 285 (Iris > 1260)
; Banana       [6,7,6,7,6,3], 240 (Iris > 1010)
; Phthalo      [6,7,7,6,7,3], 273 (Iris > 760)
; Terra        [7,7,7,7,7,3], 240 (Iris > 510)
; Atlas        [7,7,7,8,7,3], 273 (Iris > 260)
; Dread Knight [7,8,7,8,7,4], 257

; E.g. if Phthalo is last, you set initDownClicks to [6,7,7,6,7,3] and yLvlInit to 273.
; In this case your Iris level should be somewhere between 760 and 1010.

; 5. Now click Alt+F2 (the script should level up and upgrade all heroes from Cid to Frostleaf).

; If some heroes where missed, make sure you have picked the suggested setting for your Iris level.
; If you are close to one of these Iris thresholds, you should move above it with some margin. 
; E.g if your Iris is at 489, you should level it to at least 529, pick the setting for Terra,
; reload the script (Alt+F5), ascend with a clickable and try Alt+F2 again.

; If it still does not work, it's either the "click down" pattern or the click coordinate that is off.

; My "trick" getting this to work is taking a ruler, position it inside Cid's lvl up button,
; then count the down clicks needed to get to Fisherman. If the ruler is still inside the
; top lvl up button, I continue down to Forest Seer (still counting clicks). I repeat this 
; till I find a click pattern and starting position that work. Notice that the last step
; is only from Beastlord to Aphrodite to get Grant and Frostleaf in view.
; You can get the final yLvlInit coordinate via the Alt+MiddleMouseButton hotkey.

; 6. Now click Alt+F3 to start a speed run. If the script got to a ranger to early and could 
;    not buy all upgrades at once, then increase the thresholdFactor below.
; 7. When done, click Alt+F4 to run the ascend code.
;    If it didn't ascend, adjust the ascDownClicks setting below and try again.

ascDownClicks := 25 ; # of down clicks needed to get the ascension button center:ish (after a full speed run)

; If all worked so far, you are set to go!

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; (Steam only) Want to run borderless fullscreen?
; 1. In Clicker Heroes, turn on the "Full Screen" option.
; 2. Change "fullScreenOption" to "true" in the ch_bot_lib.ahk file.
; 3. Refresh with Alt+F5.

; -- Speed run ----------------------------------------------------------------------------

speedRunTime := 30 ; minutes (usually between 25 and 35 minutes)

; Adjust this setting so the script reach and can level your gilded ranger to >150 instantly.
; Each step adds or subtracts around 35 levels.
thresholdFactor := 0 ; -2, -1, 0, 1 or 2

activateSkillsAtStart := true

hybridMode := false ; chain a deep run when the speed run finish

; Added flag for v0.19.
autoAscend := false ; Warning! Set to true will both salvage relics and ascend without any user intervention!
autoAscendDelay := 10 ; warning timer (in seconds) before ascending

; If you run the Steam client with autoAscend, you can screenshot every relic you salvage!
screenShotRelics := true

; -- Deep run -----------------------------------------------------------------------------

deepRunTime := 60 ; minutes

clickableHuntDelay := 15 ; hunt for a clickable every 15s
stopHuntThreshold := 30 ; stop hunt when this many minutes remain of a deep run

; Number of gilds to move over at a time
reGildCount := 100 ; don't set this higher than 100 if you plan on moving gilds during a deep run
reGildRanger := gildedRanger + 1 

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

; -- Skill Combos -------------------------------------------------------------------------

; Combo tester @ http://pastebin.com/YCj3UxP5

; 1 - Clickstorm, 2 - Powersurge, 3 - Lucky Strikes, 4 - Metal Detector, 5 - Golden Clicks
; 6 - The Dark Ritual, 7 - Super Clicks, 8 - Energize, 9 - Reload

comboEDR := [15*60, "1-2-3-4-5-7-8-6-9", "8-9-1-2-3-4-5-7"]
comboDPS := [2.5*60, "8-3-7-6-5-4-2", "2", "2", "2-3-4", "2", "2"]

; comboEDR timetable:
; 00:00 : 1-2-3-4-5-7-8-6-9
; 15:00 : 8-9-1-2-3-4-5-7
; 30:00 : repeat

; comboDPS timetable:
; 00:00 : 8-3-7-6-5-4-2
; 02:30 : 2
; 05:00 : 2
; 07:30 : 2-3-4
; 10:00 : 2
; 12:30 : 2
; 15:00 : repeat

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
			activateSkills(comboEDR[2])
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

^F6::
	reGildRanger := reGildRanger > rangers.MinIndex() ? reGildRanger-1 : reGildRanger
	showSplash("Re-gild ranger set to " . rangers[reGildRanger])
return

^F7::
	reGildRanger := reGildRanger < rangers.MaxIndex() ? reGildRanger+1 : reGildRanger
	showSplash("Re-gild ranger set to " . rangers[reGildRanger])
return

^F8::
	critical
	playNotificationSound()
	msgbox, 4,% scriptName " v" scriptVersion,% "Move " . reGildCount . " gilds to " . rangers[reGildRanger] . "?"
	ifmsgbox no
		return
	regild(reGildRanger, reGildCount) ; will pause the monster clicker if running
return

+^F1::
	toggleFlag("autoAscend", autoAscend)
return

+^F2::
	toggleFlag("screenShotRelics", screenShotRelics)
return

+^F3::
	toggleFlag("playSounds", playSounds)
return

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

; Level up and upgrade all heroes
initRun() {
	global

	switchToCombatTab()
	clickPos(xHero, yHero) ; prevent fails

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

	local drDuration := deepRunTime * 60
	local button := gildedRanger = 9 ? 3 : 2 ; special case for Astraea
	local y := yLvl + oLvl * (button - 1)

	showSplash("Starting deep run...")

	startMouseMonitoring()
	startProgress("Deep Run Progress", 0, drDuration // barUpdateDelay)
	monsterClickerOn()

	local comboDelay := comboDPS[1]
	local comboIndex := 2
	local stopHuntIndex := drDuration - stopHuntThreshold * 60
	local t := 0

	loop % drDuration
	{
		if (exitDRThread) {
			monsterClickerOff()
			stopProgress()
			stopMouseMonitoring()
			showSplash("Deep run aborted!")
			exit
		}
		clickPos(xMonster, yMonster)
		if (mod(t, comboDelay) = 0) {
			activateSkills(comboDPS[comboIndex])
			comboIndex := comboIndex < comboDPS.MaxIndex() ? comboIndex+1 : 2
		}
		if (mod(t, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y, 1, 0)
		}
		if (mod(t, clickableHuntDelay) = 0 and t < stopHuntIndex) {
			getClickable()
		}
		t += 1
		updateProgress(t // barUpdateDelay, drDuration - t)
		sleep 1000
	}

	monsterClickerOff()
	stopProgress()
	stopMouseMonitoring()

	showSplash("Deep run ended.")
}

monsterClickerOn() {
	send {blind}{shift down}{f1}{shift up}
}

monsterClickerPause() {
	send {blind}{shift down}{f2}{shift up}
}

monsterClickerOff() {
	send {blind}{shift down}{pause}{shift up}
}

lvlUp(seconds, buyUpgrades, button, stint, stints) {
	global

	exitThread := false
	local y := yLvl + oLvl * (button - 1)
	local title := "Speed Run Progress (" . stint . "/" . stints . ")"

	startMouseMonitoring()
	startProgress(title, 0, seconds // barUpdateDelay)

	if (buyUpgrades) {
		ctrlClick(xLvl, y)
		buyAvailableUpgrades()
	}
	maxClick(xLvl, y)

	local t := 0

	loop % seconds
	{
		if (exitThread) {
			stopProgress()
			stopMouseMonitoring()
			showSplash("Speed run aborted!")
			exit
		}
		if (mod(t, lvlUpDelay) = 0) {
			ctrlClick(xLvl, y)
		}
		t += 1
		updateProgress(t // barUpdateDelay, seconds - t)
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
	clickPos(xScroll, yUp, clickCount)
	sleep % zzz * 2
}

scrollDown(clickCount:=1) {
	global
	clickPos(xScroll, yDown, clickCount)
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
	sleep % 1000
}

scrollToBottom() {
	global
	scrollDown(top2BottomClicks)
	sleep % 1000
}

regild(ranger, gildCount) {
	global
	monsterClickerPause()
	switchToCombatTab()
	scrollToBottom()

	clickPos(xGilded, yGilded)
	sleep % zzz * 2

	ControlSend,, {shift down}, % winName
	clickPos(rangerPositions[ranger].x, rangerPositions[ranger].y, gildCount)
	sleep % 1000 * gildCount/100*5
	ControlSend,, {shift up}, % winName

	clickPos(xGildedClose, yGildedClose)
	sleep % zzz * 2
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

activateSkills(skills) {
	global
	clickPos(xHero, yHero) ; prevent fails
	loop,parse,skills,-
	{
		ControlSend,,% A_LoopField, % winName
		sleep 100
	}
	sleep 1000
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

checkMousePosition:
	MouseGetPos,,, window
	if (window = WinExist(winName)) {
		WinActivate
		MouseGetPos, x, y

		xL := getAdjustedX(xSafetyZoneL)
		xR := getAdjustedX(xSafetyZoneR)
		yT := getAdjustedY(ySafetyZoneT)
		yB := getAdjustedY(ySafetyZoneB)

		if (x > xL && x < xR && y > yT && y < yB) {
			playNotificationSound()
			msgbox,,% scriptName " v" scriptVersion,Click safety pause engaged. Continue?
		}
	}
return
