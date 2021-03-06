; -----------------------------------------------------------------------------------------
; Clicker Heroes Sw1ft Bot
; by Sw1ftb

; Script home @ http://redd.it/3a3bmy

; -- Complete file list -------------------------------------------------------------------

; ch_bot_lib.ahk      https://gist.github.com/swiftb/940bd6da6ad2bc9199b0#file-ch_bot_lib-ahk
; ch_sw1ft_bot.ahk    https://gist.github.com/swiftb/940bd6da6ad2bc9199b0#file-ch_sw1ft_bot-ahk
; monster_clicker.ahk https://gist.github.com/swiftb/940bd6da6ad2bc9199b0#file-monster_clicker-ahk

; New in v2.2 is the option to do all configuration in a separate settings file!
; Example @ http://pastebin.com/7haemd0h

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
; Shift+Ctrl+F3 to toggle the playNotificationSounds flag
; Shift+Ctrl+F4 to toggle the playWarningSounds flag
; Shift+Ctrl+F5 to toggle the showSplashTexts flag
; Shift+Ctrl+F12 to toggle the debug flag (currently to debug the speed run variable calculations)

; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook

#Include %A_ScriptDir%
#Include ch_bot_lib.ahk

SetControlDelay, -1

scriptName=CH Sw1ft Bot
scriptVersion=2.2
minLibVersion=1.2

script := scriptName . " v" . scriptVersion

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
irisLevel := 1029 ; try to keep your Iris within 1001 levels of your optimal zone

; Clicker Heroes Ancients Optimizer @ http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html

; Use the optimizer to set the optimal level and time:
optimalLevel := 2000
speedRunTime := 29 ; minutes (usually between 27 and 33 minutes)

; In the Heroes tab you can verify that you are using the optimal ranger.
gildedRanger := 6 ; the number of your main guilded ranger
; 1:Dread Knight, 2:Atlas, 3:Terra, 4:Phthalo, 5:Banana, 6:Lilin, 7:Cadmia, 8:Alabaster, 9:Astraea

; The assistant will automatically try to set the correct initDownClicks and yLvlInit settings.
; It will also assist with Iris level recommendations.
useConfigurationAssistant := true

; -- Init run & ascend --------------------------------------------------------------------

; These settings are affected by your Iris level.

; A list of clicks needed to scroll down 4 heroes at a time, starting from the top.
initDownClicks := [6,7,6,7,6,3] ; the assistant will override this value if active

; This y coordinate is supposed to keep itself inside the top lvl up button when scrolling down according to the above "clicking pattern".
yLvlInit := 240 ; the assistant will override this value if active

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
; If you are close to one of these Iris irisThresholds, you should move above it with some margin. 
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

ascDownClicks := 26 ; # of down clicks needed to get the ascension button center:ish (after a full speed run)

; If all worked so far, you are set to go!

; -----------------------------------------------------------------------------------------
; -- Optional Settings
; -----------------------------------------------------------------------------------------

; (Steam only) Want to run borderless fullscreen?
; 1. In Clicker Heroes, turn on the "Full Screen" option.
; 2. Change "fullScreenOption" to "true" in the ch_bot_lib.ahk file.
; 3. Refresh with Alt+F5.

; -- Speed run ----------------------------------------------------------------------------

; Adjust this setting so the script reach and can level your gilded ranger to >175 instantly.
thresholdFactor := 0 ; -1, -0.5, 0, 0.5, 1

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
global showSplashTexts := true ; Note that some splash texts will always be shown
global showProgressBar := true
global playNotificationSounds := true
global playWarningSounds := true

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

comboStart := [15*60, "8-1-2-3-4-5-7-6-9"]
comboEDR := [15*60, "1-2-3-4-5-7-8-6-9", "8-9-1-2-3-4-5-7"]
comboExtraLucky := [2.5*60, "8-3-7-6-5-4-2", "2", "2", "2-3-4", "2", "2"]
comboGoldenLuck := [2.5*60, "6-2-3-5-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]
comboSuperLucky := [2.5*60, "6-2-3-7-8-9", "2-3-4-5-7", "2", "2", "2-3-4", "2", "2"]

speedRunStartCombo := comboStart
deepRunCombo := comboSuperLucky

; comboEDR timetable:
; 00:00 : 1-2-3-4-5-7-8-6-9
; 15:00 : 8-9-1-2-3-4-5-7
; 30:00 : repeat

; comboSuperLucky timetable:
; 00:00 : 6-2-3-7-8-9
; 02:30 : 2-3-4-5-7
; 05:00 : 2
; 07:30 : 2
; 10:00 : 2-3-4
; 12:30 : 2
; 15:00 : 2
; 17:30 : repeat

; -----------------------------------------------------------------------------------------

if (libVersion != minLibVersion) {
	showWarningSplash("The bot lib version must be " . minLibVersion . "!")
	ExitApp
}

#Include *i ch_bot_settings.ahk

scheduleReload := false

if (useConfigurationAssistant) {
	configurationAssistant()
}

clientCheck()
handleAutorun()

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift, !=Alt, ^=Ctrl)
; -----------------------------------------------------------------------------------------

; Show the cursor position with Alt+Middle Mouse Button
!mbutton::
	mousegetpos, xpos, ypos
	msgbox,,% script,% "Cursor position: x" xpos-leftMarginOffset " y" ypos-topMarginOffset
return

; Pause/Unpause script
Pause::Pause
return

; Abort speed/deep runs and auto ascensions with Alt+Pause
!Pause::
	showSplashAlways("Aborting...")
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
	switchToCombatTab()
	speedRun()
return

!F4::
	ascend(autoAscend)
return

; Reload script with Alt+F5
!F5::
	global scheduleReload := true
	handleScheduledReload()
return

; Speed run loop.
; Use to farm Hero Souls
^F1::
	loopSpeedRun()
return

; Deep run.
; Use (after a speed run) to get a few new gilds every now and then
^F2::
	deepRun()
return

^F6::
	reGildRanger := reGildRanger > rangers.MinIndex() ? reGildRanger-1 : reGildRanger
	showSplashAlways("Re-gild ranger set to " . rangers[reGildRanger])
return

^F7::
	reGildRanger := reGildRanger < rangers.MaxIndex() ? reGildRanger+1 : reGildRanger
	showSplashAlways("Re-gild ranger set to " . rangers[reGildRanger])
return

^F8::
	critical
	playNotificationSound()
	msgbox, 4,% script,% "Move " . reGildCount . " gilds to " . rangers[reGildRanger] . "?"
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
	toggleFlag("playNotificationSounds", playNotificationSounds)
return

+^F4::
	toggleFlag("playWarningSounds", playWarningSounds)
return

+^F5::
	toggleFlag("showSplashTexts", showSplashTexts)
return

+^F12::
	toggleFlag("debug", debug)
return

; Schedule reload script with Shift+F5
+F5::
	toggleFlag("scheduleReload", scheduleReload)
return


; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

configurationAssistant() {
	global

	if (irisLevel < 145) {
		playWarningSound()
		msgbox,,% script,% "Your Iris do not fulfill the minimum level requirement of 145 or higher!"
		exit
	}

	if (irisThreshold(2010)) { ; Astraea
		initDownClicks := [6,5,6,5,6,3]
		yLvlInit := 241
	} else if (irisThreshold(1760)) { ; Alabaster
		initDownClicks := [6,6,5,6,6,3]
		yLvlInit := 259
	} else if (irisThreshold(1510)) { ; Cadmia
		initDownClicks := [6,6,6,6,6,3]
		yLvlInit := 240
	} else if (irisThreshold(1260)) { ; Lilin
		initDownClicks := [6,6,6,6,6,3]
		yLvlInit := 285
	} else if (irisThreshold(1010)) { ; Banana
		initDownClicks := [6,7,6,7,6,3]
		yLvlInit := 240
	} else if (irisThreshold(760)) { ; Phthalo
		initDownClicks := [6,7,7,6,7,3]
		yLvlInit := 273
	} else if (irisThreshold(510)) { ; Terra
		initDownClicks := [7,7,7,7,7,3]
		yLvlInit := 240
	} else if (irisThreshold(260)) { ; Atlas
		initDownClicks := [7,7,7,8,7,3]
		yLvlInit := 273
	} else { ; Dread Knight
		initDownClicks := [7,8,7,8,7,4]
		yLvlInit := 257
	}

	if (irisLevel < optimalLevel - 1001) {
		local levels := optimalLevel - 1001 - irisLevel
		playNotificationSound()
		msgbox,,% script,% "Your Iris is " . levels . " levels below the recommended ""optimal level - 1001"" rule."
	}
}

irisThreshold(lvl) {
	global
	local upperThreshold := lvl + 19
	local lowerThreshold := lvl - 20
	if (irisLevel >= lowerThreshold and irisLevel < upperThreshold) {
		playWarningSound()
		msgbox,,% script,% "Threshold proximity warning! You should level up your Iris to " . upperThreshold . " or higher."
	}
	return irisLevel > lvl
}

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

loopSpeedRun() {
	global

	mode := hybridMode ? "hybrid" : "speed"
	showSplashAlways("Starting " . mode . " runs...")
	loop
	{
		getClickable()
	    sleep % coinPickUpDelay * 1000
		initRun()
		if (activateSkillsAtStart) {
			activateSkills(speedRunStartCombo[2])
		}
		speedRun()
		if (hybridMode) {
			deepRun()
		}
		ascend(autoAscend)
		handleScheduledReload(true)
	}
}

; All heroes/rangers are expected to "insta-kill" everything at max speed (i.e. around
; 7 minutes per 250 levels). Only the last 2-3 minutes should slow down slightly.
speedRun() {
	global

	local stint := 0
	local stints := 2
	local tMax := 7 * 60
	local lMax := 250
	local lvlThreshold := 36 * thresholdFactor
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
	local totalClickDelay := ceil(srDuration / lvlUpDelay * zzz / 1000 + nextHeroDelay * stints)
	local lastStintTime := srDuration - firstStintTime - midStintTime - totalClickDelay
	local lastStintButton := gildedRanger = 9 ? 3 : 2 ; special case for Astraea

	if (debug)
	{
		local nl := "`r`n"
		local output := ""
		output .= "irisLevel = " . irisLevel . nl
		output .= "optimalLevel = " . optimalLevel . nl
		output .= "speedRunTime = " . speedRunTime . nl
		output .= "gildedRanger = " . rangers[gildedRanger] . nl
		output .= "-----------------------------" . nl
		output .= "initDownClicks = "
		for i, e in initDownClicks {
			output .= e " "
		}
		output .= nl
		output .= "yLvlInit = " . yLvlInit . nl
		output .= "thresholdFactor = " . thresholdFactor . nl
		output .= "-----------------------------" . nl
		output .= "lvlThreshold = " . lvlThreshold . nl
		output .= "zoneLvl = " . zoneLvl . nl
		output .= "lvls = " . lvls . nl
		output .= "srDuration = " . formatSeconds(srDuration) . nl
		output .= "firstStintTime = " . formatSeconds(firstStintTime) . nl
		output .= "midStintTime = " . formatSeconds(midStintTime) . nl
		output .= "lastStintTime = " . formatSeconds(lastStintTime) . nl
		output .= "totalClickDelay = " . formatSeconds(totalClickDelay) . nl

		clipboard := % output
		msgbox % output
		return
	}

	showSplash("Starting speed run...")

	if (irisLevel < 2 * lMax + 10) ; Iris high enough to start with a ranger?
	{
		switchToCombatTab()
		scrollDown(initDownClicks[1])
		toggleMode() ; toggle to progression mode
		lvlUp(firstStintTime, 0, 3, ++stint, stints) ; nope, let's bridge with Samurai
		scrollToBottom()
	} else {
		scrollToBottom()
		toggleMode() ; toggle to progression mode
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

	local comboDelay := deepRunCombo[1]
	local comboIndex := 2
	local stopHuntIndex := drDuration - stopHuntThreshold * 60
	local t := 0

	loop % drDuration
	{
		if (exitDRThread) {
			monsterClickerOff()
			stopProgress()
			stopMouseMonitoring()
			showSplashAlways("Deep run aborted!")
			exit
		}
		clickPos(xMonster, yMonster)
		if (mod(t, comboDelay) = 0) {
			activateSkills(deepRunCombo[comboIndex])
			comboIndex := comboIndex < deepRunCombo.MaxIndex() ? comboIndex+1 : 2
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
			showSplashAlways("Speed run aborted!")
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
		showWarningSplash(autoAscendDelay . " seconds till ASCENSION! (Abort with Alt+Pause)", autoAscendDelay)
		if (exitThread) {
			showSplashAlways("Ascension aborted!")
			exit
		}
	} else {
		playWarningSound()
		msgbox, 4,% script,Salvage Junk Pile & Ascend?
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
	if (autoAscend && screenShotRelics) {
		clickPos(xRelic, yRelic) ; focus
		screenShot()
		clickPos(xRelic+100, yRelic) ; remove focus
	}
	clickPos(xSalvageJunk, ySalvageJunk)
	sleep % zzz * 4
	clickPos(xDestroyYes, yDestroyYes)
	sleep % zzz * 2
}

buyAvailableUpgrades() {
	global
	clickPos(xBuy, yBuy)
	sleep % zzz * 3
}

; Scroll down fix when at bottom and scroll bar don't update correctly
scrollWayDown(clickCount:=1) {
	global
	scrollUp()
	scrollDown(clickCount + 1)
	sleep % nextHeroDelay * 1000
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

; Toggle between farm and progression modes
toggleMode() {
	global
	ControlSend,, {a down}{a up}, % winName
	sleep % zzz
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


handleScheduledReload(autorun := false) {
	global
	if(scheduleReload) {
		showSplashAlways("Reloading bot...", 1)

		autorun_flag := autorun = true ? "/autorun" : ""
		Run "%A_AhkPath%" /restart "%A_ScriptFullPath%" %autorun_flag%
	}
}

handleAutorun() {
	global
	param_1 = %1%
	if(param_1 = "/autorun") {
		showSplashAlways("Autorun speedruns...")
		loopSpeedrun()
	}
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
			msgbox,,% script,Click safety pause engaged. Continue?
		}
	}
return

