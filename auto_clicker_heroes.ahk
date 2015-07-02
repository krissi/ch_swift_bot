; -----------------------------------------------------------------------------------------
; Clicker Heroes HS Speed Farmer
; v1.8
; by Sw1ftb

; Note that this bot is not intended for the early game!
; It assumes that your Iris ancient level is high enough to (after an ascension + clickable)
; instantly unlock and level all heroes, including Frostleaf, to 100 and buy all upgrades.
; The goal is to speed run around 1000 levels (starting from your Iris level) in 30-35 minutes and then restart.

; How to get millions of Hero Souls?

; 1. Select Steam or browser support with the SetTitleMatchMode parameter.
; - If Steam, make sure you run in windowed mode at default size (1136 x 640).
; - If browser, follow the instructions below for setting the correct top margin.
; 2. Scroll down to the Hotkeys section and run the "Quick initial tests".
; 3. If those works, go back up and adjust the Coordinates > initRun function settings.
;    Some tinkering might be needed if you are at a later stage in the game than me.
; 4. When that bit work, go back up and configure your Speed run.
;    Adjust the irisLevel and gildedRanger settings. Leave the rest as is and hit Ctrl+F1!
;    Important! The script assumes that you have just ascended with a "clickable" available and in Farm Mode.
; 5. If everything works you should end up with a "Salvage Junk Pile & Ascend?" question after ~30 minutes.
;    Answer No, then find the Coordinates > Ascension button settings and adjust if needed.
; 6. Now click Alt+F4 to manually restart the ascend function.
;    Before hitting Yes to continue, verify that your junk pile is ok to salvage.
; 7. If the script managed to salvage and ascend successfully, then everything is now operational.
;
; Options you might want to change:
; * speedRunTime - depending on the end zone lvl you aim at, adjust as needed
; * activateSkillsAtStart - if you do longer runs (>35 minutes), you might benefit from the energize + dark ritual dps bonus
; * autoAscend - for those over night farm sessions
;
; If you can speed run to 1700 or above (in less than 30 minutes) and have a hybrid build (with Bhaal, Frag, 
; Jugg and co.), you might want to try the Deep run option. It is designed to start off where a speed run 
; finish and will only lvl up the same ranger till the end. Just set the deepRunTime duration and hit Ctrl+F2.
;
; Note that you must reload the script with Alt+F5 (and Alt+F6 if you run in a browser) for any change to take effect.
;
; At any given time, you can pause the script with the Pause button, or abort a run with Alt+Pause.

; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook
Thread, interrupt, 0

winName=Clicker Heroes

global ProgressBar, ProgressBarTime ; progress bar controls

exitThread = 0
exitDRThread = 0

SetTitleMatchMode, 3 ; Steam (3) or browser (regex) version?

; If browser, you need to verify (or adjust) this top margin setting:
browserTopMargin = 230 ; Chrome (222), Firefox (230), IE (198)

; Start the script, then:
; Alt+Middle Mouse Button the top edge of the CH area (below the logo) to get the coordinate.
; When done, reload the script with Alt+F5 and calculate browser offsets with Alt+F6.

; Note that Chrome steals focus, so I would recommend using Firefox.

; All the script coordinates are based on these four dimensions. DO NOT CHANGE!
chWidth = 1136
chHeight = 640
chLeftMargin = 8
chTopMargin = 30

; These will be calculated by the script
leftMarginOffset = 0
topMarginOffset = 0

; -----------------------------------------------------------------------------------------
; -- Configuration
; -----------------------------------------------------------------------------------------

; In Clicker Heroes, turn off the "Show relic found popups" option.

; This is the base setting for how fast or slow the script will run.
; 200 is a safe setting. Anything lower than 150 is on your own risk!
zzz = 200 ; sleep delay (in ms) after a click

lvlUpDelay = 5 ; time (in seconds) between lvl up clicks
barUpdateDelay = 30

; -- Speed run ----------------------------------------------------------------------------

; http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html

speedRunTime = 30 ; minutes
irisLevel = 1013 ; try to keep your Iris within 1000 levels of your optimal zone lvl

; 1:dread knight, 2:atlas, 3:terra, 4:phthalo, 5:banana, 6:lilin, 7:cadmia, 8:alabaster, 9:astraea
gildedRanger = 6 ; your main guilded ranger. Tip: Keep 1 gild on the hero starting the run.

; Adjust this setting so the script reach and can level your gilded ranger to >150 instantly.
thresholdFactor = 1 ; 0, 1 or 2

activateSkillsAtStart = 0

; Added flag for v0.19.
autoAscend = 0 ; Warning! Set to 1 will both salvage relics and ascend without any user intervention!

; -- Deep run -----------------------------------------------------------------------------

deepRunTime = 30 ; minutes
coolDownTime = 15 ; assuming Vaagur lvl 15
clickableDelay = 30 ; hunt for a clickable every 30s (set to 0 to stop hunting)

; If you want a stable run, I strongly recommend using an external auto-clicker.
cpsTarget = 25 ; monster clicks per second (0 for external) 

; -- Coordinates --------------------------------------------------------------------------

; Use Windows Spy (for Steam version) or click Alt+MiddleMouseButton to tune the below (relative) coordinates.

; Top LVL UP button when scrolled to the bottom
xLvl = 100
yLvl = 285
oLvl = 107 ; offset to next button

; Approximate Iris lvl thresholds that affect the scroll bar:
; 260 (Atlas), 510 (Terra), 760 (Phthalo), 1010 (Banana), 1260 (Lilin)

; initRun function settings
initDownClicks :=  [6,7,6,7,6,3] ; # of clicks down needed to get next 4 heroes in view (after an ascension + clickable)

; This y coordinate is supposed to keep itself inside the top lvl up button when scrolling down according to the above "clicking pattern".
; Trial run with Alt+F2. Tip: If things move to fast, temporarily increase the zzz parameter to slow down the script.
yLvlInit = 240

; After an ascend plus (non-idle) clickable, who's at the bottom? Suggested settings:
; Lilin        [6,6,6,6,6,3], 285
; Banana       [6,7,6,7,6,3], 240
; Phthalo      [6,7,7,6,7,3], 273
; Terra        [7,7,7,7,7,3], 240
; Atlas        [7,7,7,8,7,3], 273
; Dread Knight [7,8,7,8,7,4], 257

; Ascension button settings
ascDownClicks = 25 ; # of down clicks needed to get the button as centered as possible (after a full speed run)
xAsc = 310
yAsc = 468

buttonSize = 34

; Ascend Yes button
xYes = 500
yYes = 445

xCombatTab = 50
yCombatTab = 130

xRelicTab = 380
yRelicTab = 130

xSalvageJunk = 280
ySalvageJunk = 470

xDestroyYes = 500
yDestroyYes = 430

; Scrollbar
xScroll = 555
yUp = 220
yDown = 650
top2BottomClicks = 50

; Buy Available Upgrades button
xBuy = 300
yBuy = 580

xHero = 474
yHero = 229

xMonster = 860
yMonster = 420

; No smart image recognition, so we click'em all!
get_clickable()
{
	global
	; Break idle on purpose to get the same amount of gold every run
	clickPos(xMonster, yMonster)
	clickPos(xMonster, yMonster)
	sleep 1000
    clickPos(524, 487)
    clickPos(747, 431)
    clickPos(755, 480)
    clickPos(760, 380)
    clickPos(873, 512)
    clickPos(1005, 453)
    clickPos(1053, 443)
}

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift, !=Alt, ^=Ctrl)
; -----------------------------------------------------------------------------------------

; Quick initial tests:
; Shift+F1 should scroll down to the bottom and lvl up the top hero
; Shift+F2 should lvl up the wandering fisherman
; Shift+F3 should switch to the relics tab and then back

+F1::
	scrollToBottom()
	clickPos(xLvl, yLvl)
return

+F2::
	scrollToTop()
	scrollDown(initDownClicks[1])
	clickPos(xLvl, yLvl)
return

+F3::
	switchToRelicTab()
	switchToCombatTab()
return

; Show the cursor position with Alt+Middle Mouse Button
!mbutton::
	mousegetpos, xpos, ypos
	msgbox,% "Cursor position: x" xpos-leftMarginOffset " y" ypos-topMarginOffset
return

; Reload script with Alt+F5
!F5::
	showSplash("Reloading...", 2, 0)
	Reload
return

; Calculate browser offsets compared to the Steam client with Alt+F6
!F6::
	winName=Lvl.*Clicker Heroes.*

	IfWinExist, % winName
	{
		showSplash("Calculating browser offsets...")

		WinActivate
		WinGetPos, x, y, winWidth, winHeight

		leftMargin := (winWidth - chWidth) // 2
		leftMarginOffset := leftMargin - chLeftMargin
		topMarginOffset := browserTopMargin - chTopMargin
	} else {
		showSplash("Clicker Heroes started?")
	}
return

; Pause/Unpause script
Pause::Pause
return

; Abort speed/deep runs and auto ascensions with Alt+Pause
!Pause::
	showSplash("Aborting...", 2, 0)
	exitThread = 1
	exitDRThread = 1
return

; Alt+F1 to F4 are here to test the individual parts of the full speed run loop

!F1::
	get_clickable()
    sleep 8000
	toggleMode()
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

; Speed run loop.
; Use to farm Hero Souls
^F1::
	keywait, ctrl
	showSplash("Starting speed runs...", 2, 0)
	loop
	{
		get_clickable()
	    sleep 8000 ; wait 8s to pick up all coins
		toggleMode() ; toggle to progression mode
		initRun()
		if (activateSkillsAtStart) {
			activateSkills()
			activateEdrSkills()
		}
		speedRun()
		ascend(autoAscend)
	}
return

; Deep run.
; Use (after a speed run) to get a few new gilds every now and then
^F2::
	exitDRThread = 0
	monsterClicks = 0
	drDuration := deepRunTime * 60
	cds := coolDownTime * 60

	showSplash("Starting deep run...", 2, 0)
	startProgress("Deep Run Progress", 0, drDuration // barUpdateDelay)

	drStartTime := A_TickCount

	fastMode()

	setTimer, endDeepRun, % -drDuration * 1000 ; run only once
	if (cpsTarget > 0) {
		setTimer, slayMonsters, % 1000 / cpsTarget
	}

	toggle = true

	while(!exitDRThread)
	{
		if (mod(A_Index, cds) = 0) {
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
			ctrlClick(xLvl, yLvl + oLvl, 1, 0)
		}
		if (mod(A_Index, clickableDelay) = 0) {
			get_clickable()
		}
		updateProgress(A_Index // barUpdateDelay, drDuration - A_Index)
		sleep 1000
	}

	setTimer, slayMonsters, off

	clicksPerSecond := round(monsterClicks / secondsSince(drStartTime), 2)

	stopProgress()
	showSplash("Deep run ended (" . clicksPerSecond . " cps)")
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
	upgrade(0,,,,,1) ; grant & frostleaf

	buyAvailableUpgrades()
}

upgrade(times, cc1:=1, cc2:=1, cc3:=1, cc4:=1, skip:=0) {
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

	local stints := 2
	local tMax := 7 * 60
	local lMax := 250
	local lvlThreshold := 35 * thresholdFactor
	local zoneLvl := gildedRanger * lMax + lvlThreshold ; approx zone lvl where we can buy our gilded ranger @ lvl 150
	local lvls := zoneLvl - irisLevel ; lvl's to get there
	local midStintTime := 0

	if (lvls > lMax) ; add a mid stint if needed
	{
		midStintTime := ceil(lMax * tMax / lMax)
		lvls -= lMax
		stints += 1
	}
	local firstStintTime := ceil(lvls * tMax / lMax)
	local srDuration := speedRunTime * 60
	local totalClickDelay := (srDuration // lvlUpDelay) * zzz // 1000
	local lastStintTime := srDuration - firstStintTime - midStintTime - totalClickDelay

	showSplash("Starting speed run...", 2, 0)

	switchToCombatTab()

	if (irisLevel < lMax + lvlThreshold) ; Iris high enough to start with a ranger?
	{
		scrollDown(initDownClicks[1])
		lvlUp(firstStintTime, 0, 3, 1, stints) ; nope, let's bridge with Samurai
		scrollToBottom()
	} else {
		scrollToBottom()
		lvlUp(firstStintTime, 1, 1, 1, stints)
		scrollWayDown(2)
	}
	if (midStintTime) {
		lvlUp(midStintTime, 1, 2, 2, stints)
		scrollWayDown(2)
	}
	lvlUp(lastStintTime, 1, 2, 2, stints)

	showSplash("Speed run completed.")
}

lvlUp(seconds, buyUpgrades, button, stint, stints) {
	global
	exitThread = 0
	local y := yLvl + oLvl * (button - 1)
	local title := "Speed Run - Leveling Hero " . stint . "/" . stints

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
			showSplash("Speed run aborted!")
			exit
		}
		sleep 1000
	}
	stopProgress()
}

ascend(autoYes:=0) {
	global
	exitThread = 0
	local y = yAsc - 3 * buttonSize

	if (autoYes) {
		showSplash("10 seconds till ASCENSION! (Abort with Alt+Pause)", 10, 2)
		if (exitThread) {
			showSplash("Ascension aborted!")
			exit
		}
	} else {
		playWarningSound()
		msgbox, 4,,Salvage Junk Pile & Ascend?
		ifmsgbox no
			exit
	}

	salvageJunkPile() ; must salvage junk relics before ascending

	switchToCombatTab()

	scrollDown(ascDownClicks)
	sleep % zzz * 2

	; Scrolling is not an exact science, hence we click above, center and below
	loop 9
	{
		clickPos(xAsc, y)
		y := y + buttonSize
	}
	sleep % zzz * 4
	clickPos(xYes, yYes)
	sleep % zzz * 2
}

salvageJunkPile() {
	global

	switchToRelicTab()
	clickPos(xSalvageJunk, ySalvageJunk)
	sleep % zzz * 4
	clickPos(xDestroyYes, yDestroyYes)
	sleep % zzz * 2
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
	scrollToBottom()
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
	scrollUp()
	scrollDown(clickCount + 1)
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

clickPos(xCoord, yCoord, clickCount:=1) {
	global
	ControlClick,% "x" xCoord+leftMarginOffset " y" yCoord+topMarginOffset,% winName,,,% clickCount,Pos
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

playWarningSound() {
	SoundPlay, %A_WinDir%\Media\tada.wav
}

showSplash(text, seconds:=5, sound:=1) {
	splashtexton,200,40,Auto-clicker,%text%
	if (sound = 1) {
		SoundPlay, %A_WinDir%\Media\Windows User Account Control.wav
	} else if (sound = 2) {
		playWarningSound()
	}
	sleep % seconds * 1000
	splashtextoff
}

startProgress(title, min:=0, max:=100) {
	gui, new
	gui, margin, 0, 0
	gui, font, s18
	gui, add, progress,% "w300 h28 range" min "-" max " -smooth vProgressBar"
	gui, add, text, w92 vProgressBarTime x+2
	gui, show, x20 y20,% title
}

updateProgress(position, remainingTime) {
	guicontrol,, ProgressBar,% position
	guicontrol,, ProgressBarTime,% formatSeconds(remainingTime)
}

stopProgress() {
	gui, destroy
}

formatSeconds(s) {
    time = 19990101 ; *Midnight* of an arbitrary date.
    time += %s%, seconds
	FormatTime, timeStr, %time%, HH:mm:ss
    return timeStr
}

secondsSince(startTime) {
	return (A_TickCount - startTime) // 1000
}

fastMode() {
	SetControlDelay, -1
}

slowMode() {
	SetControlDelay, 20
}

; -----------------------------------------------------------------------------------------
; -- Subroutines
; -----------------------------------------------------------------------------------------

endDeepRun:
	exitDRThread = 1
return

slayMonsters:
	clickPos(xMonster, yMonster)
	monsterClicks++
return
