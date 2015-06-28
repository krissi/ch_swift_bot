; -----------------------------------------------------------------------------------------
; Clicker Heroes HS Speed Farmer
; v1.6
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
;    (While there, glance through the configured Hotkeys)
; 3. If those works, go back up and adjust the Coordinates > init_run function settings.
;    Some tinkering might be needed if you are at a later stage in the game than me.
; 4. When that bit work, go back up and configure your Speed run settings.
;    Adjust the irisLevel and gildedRanger. Leave the rest as is and hit Ctrl+F1!
;    Important! The script assumes that you have just ascended with a "clickable" available and in Farm Mode.
; 5. If everything works you should end up with a "Salvage Junk Pile & Ascend?" question after ~30 minutes.
;    If you answer No, the speed run will end. Yes will salvage, ascend and restart.
;
; If you ended the run, you now have the option to change any setting you like.
; E.g. setting autoAscend to 1 to go true idle mode when AFK.
;
; After any configuration change, you must reload the script with Alt+F5 (and Alt+F6 if you run in a browser) for the changes to take effect.
;
; At any given time, you can pause the script with the Pause button, or abort a run with Alt+Pause.

; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
Thread, interrupt, 0

winName=Clicker Heroes

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
; 200 is a safe setting. Anything lower than 100 is on your own risk!
zzz = 200 ; sleep delay (in ms) after a click

lvlUpDelay = 5 ; time (in seconds) between lvl up clicks

; -- Speed run ----------------------------------------------------------------------------

; http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html

speedRunTime = 30 ; minutes
irisLevel = 798 ; try to keep your Iris within 1000 levels of your optimal zone lvl

lvl200Threshold := 20 * 2 ; if the script start on ranger #2 below lvl 100 and misses the upgrades, then up the multiplier a notch

; 1:dread knight, 2:atlas, 3:terra, 4:phthalo, 5:banana, 6:lilin, 7:cadmia, 8:alabaster, 9:astraea
gildedRanger = 5 ; your main guilded ranger. Tip: Keep 1 gild on the 3 rangers prior to not get stuck at the start.

activateSkillsAtStart = 0

; Added flag for v0.19.
autoAscend = 0 ; Warning! Set to 1 will both salvage relics and ascend without any user intervention!

; -- Deep run -----------------------------------------------------------------------------

deepRunTime = 20 ; minutes
coolDownTime = 15 ; assuming Vaagur lvl 15
clickableDelay = 30 ; hunt for a clickable every 30s (set to 0 to stop hunting)

; -- Coordinates --------------------------------------------------------------------------

; Use Windows Spy or click Alt+MiddleMouseButton to tune the below (relative) coordinates.

; Top LVL UP button when scrolled to the bottom
xLvl = 100
yLvl = 285
oLvl = 107 ; offset to next button

; Approximate Iris lvl thresholds that affect the scroll bar:
; 225 (Atlas), 475 (Terra), 725 (Phthalo), 975 (Banana), 1225 (Lilin)

; init_run function settings
initDownClicks := [6,7,7,6,7,3] ; # of clicks down needed to get next 4 heroes in view (after an ascension + clickable)

; This y coordinate is supposed to keep itself inside the top lvl up button when scrolling down according to the above "clicking pattern".
; Trial run with Alt+F2. Tip: If things move to fast, temporarily increase the zzz parameter to slow down the script.
yLvlInit = 273 ; try 240 if 273 don't work

; After an ascend + clickable, who's the last ranger visible? Suggested settings:
; Lilin        [6,6,6,6,6,3], 285
; Banana        ???
; Phthalo      [6,7,7,6,7,3], 273
; Terra        [7,7,7,7,7,3], 240
; Atlas        [7,7,7,8,7,3], 273
; Dread Knight [7,8,7,8,7,3], ?

; Ascension button
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

; No smart image recognition, so we click'em all!
get_clickable()
{
    click_(524, 487)
    click_(747, 431)
    click_(755, 480)
    click_(760, 380)
    click_(873, 512)
    click_(1005, 453)
    click_(1053, 443)
}

xMonster = 1053
yMonster = 443

xHero = 474
yHero = 229

; -----------------------------------------------------------------------------------------
; -- Hotkeys (+=Shift, !=Alt, ^=Ctrl)
; -----------------------------------------------------------------------------------------

; Quick initial tests:
; Shift+F1 should scroll down to the bottom and lvl up the top hero
; Shift+F2 should lvl up the wandering fisherman
; Shift+F3 should switch to the relics tab and then back

+F1::
	scroll_to_bottom()
	click_(xLvl, yLvl)
return

+F2::
	scroll_to_top()
	scroll_down(initDownClicks[1])
	click_(xLvl, yLvl)
return

+F3::
	switch2relic()
	switch2combat()
return

; Show the cursor position with Alt+Middle Mouse Button
!mbutton::
	mousegetpos, xpos, ypos
	msgbox, Cursor position: x%xpos% y%ypos%
return

; Reload script with Alt+F5
!F5::
	show_splash("Reloading...", 2, 0)
	Reload
return

; Calculate browser offsets compared to the Steam client with Alt+F6
!F6::
	winName=Lvl.*Clicker Heroes.*

	IfWinExist, % winName
	{
		show_splash("Calculating browser offsets...")

		WinActivate
		WinGetPos, x, y, winWidth, winHeight

		leftMargin := (winWidth - chWidth) // 2
		leftMarginOffset := leftMargin - chLeftMargin
		topMarginOffset := browserTopMargin - chTopMargin
	} else {
		show_splash("Clicker Heroes started?")
	}
return

; Pause/Unpause script
Pause::Pause
return

; Abort speed/deep runs and auto ascensions with Alt+Pause
!Pause::
	show_splash("Aborting...", 2, 0)
	exitThread = 1
	exitDRThread = 1
return

; Alt+F1 to F4 are here to test the individual parts of the full speed run loop

!F1::
	get_clickable()
    sleep 8000 ; wait 8s to pick up all coins
	toggle_mode() ; toggle back to progression mode
return

!F2::
	init_run()
return

!F3::
	speed_run()
return

!F4::
	ascend(autoAscend)
return

; Speed run loop.
; Use to farm Hero Souls
^F1::
	keywait, ctrl
	show_splash("Starting speed runs...", 2, 0)
	loop
	{
		get_clickable()
	    sleep 8000 ; wait 8s to pick up all coins
		toggle_mode() ; toggle back to progression mode
		init_run()
		if (activateSkillsAtStart) {
			activate_skills()
			activate_edr_skills()
		}
		speed_run()
		ascend(autoAscend)
	}
return

; Deep run.
; Use (after a speed run) to get a few new gilds every now and then
^F2::
	exitDRThread = 0
	monsterClicks = 0

	show_splash("Starting deep run...", 2, 0)
	drStartTime := A_TickCount

	fast_mode()

	setTimer, endDeepRun, % -deepRunTime * 60 * 1000 ; run only once
	setTimer, levelUpHero, % lvlUpDelay * 1000
	if (clickableDelay > 0) {
		setTimer, hunt4Clickable, % clickableDelay * 1000
	}
	setTimer, activateSkills, 1000
	setTimer, slayMonsters, 25
return

; -----------------------------------------------------------------------------------------
; -- Functions
; -----------------------------------------------------------------------------------------

; Level up and upgrade all heroes

init_run()
{
	global

	switch2combat()

	click_(xHero, yHero) ; prevent initial upgrade ctrl_click fails

	upgrade(initDownClicks[1],2,,2) ; cid --> brittany
	upgrade(initDownClicks[2]) ; fisherman --> leon
	upgrade(initDownClicks[3]) ; seer --> mercedes
	upgrade(initDownClicks[4],,,,2) ; bobby --> king
	upgrade(initDownClicks[5],2,,,2) ; ice --> amenhotep
	upgrade(initDownClicks[6],,,2) ; beastlord --> shinatobe
	upgrade(0,,,,,1) ; grant & frostleaf

	buy_available_upgrades()
}

upgrade(times, cc1:=1, cc2:=1, cc3:=1, cc4:=1, skip:=0)
{
	global

	if (!skip) {
		ctrl_click(xLvl, yLvlInit, cc1)
		ctrl_click(xLvl, yLvlInit + oLvl, cc2)
	}
	ctrl_click(xLvl, yLvlInit + oLvl*2, cc3)
	ctrl_click(xLvl, yLvlInit + oLvl*3, cc4)

	scroll_down(times)
}

; All heroes/rangers are expected to "insta-kill" everything at max speed (i.e. around
; 7 minutes per 250 levels). Only the last 2-3 minutes should slow down slightly.
speed_run()
{
	global speedRunTime, irisLevel, gildedRanger, lvl200Threshold
	tMax := 7 * 60
	lMax := 250

	zoneLvl := gildedRanger * lMax + lvl200Threshold ; approx zone lvl where we can buy our gilded ranger @ lvl 200
	lvls := zoneLvl - irisLevel ; lvl's to get there

	firstStintTime := ceil(mod(lvls, lMax) * tMax / lMax)
	if (firstStintTime = 0) {
		firstStintTime := tMax
	}
	lastStintTime := speedRunTime * 60 - firstStintTime - tMax

	switch2combat()
	scroll_to_bottom()

	; Level up in stints. Hop to the next ranger as soon as we start at lvl 200 or higher.
	; The last (500 lvls) stint should, if everything works, always be on your configured gilded ranger.

	if (lvls > 2 * lMax)
	{
		lvlup(firstStintTime, 1, 1)
		scroll_way_down(2)
		lvlup(tMax, 1, 2)
		lastStintTime -= tMax
	} else {
		lvlup(firstStintTime, 1, 2)
	}
	scroll_way_down(2)
	lvlup(tMax, 1, 2)
	scroll_way_down(2)
	lvlup(lastStintTime, 1, 2)

	show_splash("Speed run completed.")
}

lvlup(seconds, buyUpgrades:=0, button:=1)
{
	global
	exitThread = 0
	local y := yLvl + oLvl * (button - 1)

	if (buyUpgrades) {
		ctrl_click(xLvl, y)
		buy_available_upgrades()
	}
	max_click(xLvl, y)

	loop % round(seconds/lvlUpDelay) {
		ctrl_click(xLvl, y)
		sleep % lvlUpDelay * 1000 - zzz ; compensate for the click delay
		if (exitThread) {
			show_splash("Speed run aborted!")
			exit
		}
	}
}

ascend(autoYes:=0)
{
	global
	exitThread = 0
	local y = yAsc - 3 * buttonSize

	if (autoYes) {
		show_splash("10 seconds till ASCENSION! (Abort with Alt+Pause)", 10, 2)
		if (exitThread) {
			show_splash("Ascension aborted!")
			exit
		}
	} else {
		play_warning_sound()
		msgbox, 4,,Salvage Junk Pile & Ascend?
		ifmsgbox no
			exit
	}

	salvage_junk_pile() ; must salvage junk relics before ascending

	switch2combat()

	scroll_down(ascDownClicks)
	sleep % zzz * 2

	; Scrolling is not an exact science, hence we click above, center and below
	loop 7
	{
		click_(xAsc, y)
		y := y + buttonSize
	}
	sleep % zzz * 4
	click_(xYes, yYes)
	sleep % zzz * 2
}

salvage_junk_pile()
{
	global

	switch2relic()
	click_(xSalvageJunk, ySalvageJunk)
	sleep % zzz * 4
	click_(xDestroyYes, yDestroyYes)
	sleep % zzz * 2
}

switch2relic()
{
	global
	click_(xRelicTab, yRelicTab)
	sleep % zzz * 2
}

switch2combat()
{
	global
	click_(xCombatTab, yCombatTab)
	sleep % zzz * 4
}

buy_available_upgrades() {
	global
	scroll_to_bottom()
	click_(xBuy, yBuy)
	sleep % zzz * 3
}

scroll_up(clickCount:=1) {
	global
	fast_mode()
	click_(xScroll, yUp, clickCount)
	slow_mode()
	sleep % zzz * 2
}

scroll_down(clickCount:=1) {
	global
	fast_mode()
	click_(xScroll, yDown, clickCount)
	slow_mode()
	sleep % zzz * 2
}

; Scroll down fix when at bottom and scroll bar don't update correctly
scroll_way_down(clickCount:=1) {
	scroll_up()
	scroll_down(clickCount + 1)
}

scroll_to_top()
{
	global
	scroll_up(top2BottomClicks)
	sleep % 1000 - zzz
}

scroll_to_bottom()
{
	global
	scroll_down(top2BottomClicks)
	sleep % 1000 - zzz
}

max_click(xCoord, yCoord)
{
	global
	ControlSend,, {shift down}{q down}, % winName
	click_(xCoord, yCoord, clickCount)
	ControlSend,, {q up}{shift up}, % winName
	sleep % zzz
}

ctrl_click(xCoord, yCoord, clickCount:=1, sleepSome:=1)
{
	global
	ControlSend,, {ctrl down}, % winName
	click_(xCoord, yCoord, clickCount)
	ControlSend,, {ctrl up}, % winName
	if (sleepSome) {
		sleep % zzz
	}
}

click_(xCoord, yCoord, clickCount:=1)
{
	global
	ControlClick,% "x" xCoord+leftMarginOffset " y" yCoord+topMarginOffset,% winName,,,% clickCount,Pos
}

; Toggle between farm and progression modes
toggle_mode()
{
	global
	ControlSend,, {a down}{a up}, % winName
}

activate_skills()
{
	global
	ControlSend,, {1 down}{1 up}, % winName ; clickstorm
	ControlSend,, {2 down}{2 up}, % winName ; powersurge
	ControlSend,, {3 down}{3 up}, % winName ; lucky strikes
	ControlSend,, {4 down}{4 up}, % winName ; metal detector
	ControlSend,, {5 down}{5 up}, % winName ; golden clicks
	ControlSend,, {7 down}{7 up}, % winName ; super clicks
}

activate_edr_skills()
{
	global
	ControlSend,, {8 down}{8 up}, % winName ; energize
	ControlSend,, {6 down}{6 up}, % winName ; dark ritual
	ControlSend,, {9 down}{9 up}, % winName ; reload
}

activate_er_skills()
{
	global
	ControlSend,, {8 down}{8 up}, % winName ; energize
	ControlSend,, {9 down}{9 up}, % winName ; reload
}

play_warning_sound()
{
	SoundPlay, %A_WinDir%\Media\tada.wav
}

show_splash(text, seconds:=5, sound:=1)
{
	splashtexton,200,40,Auto-clicker,%text%
	if (sound = 1) {
		SoundPlay, %A_WinDir%\Media\Windows User Account Control.wav
	} else if (sound = 2) {
		play_warning_sound()
	}
	sleep % seconds * 1000
	splashtextoff
}

fast_mode() {
	SetControlDelay, -1
}

slow_mode() {
	SetControlDelay, 20
}

; -----------------------------------------------------------------------------------------
; -- Subroutines
; -----------------------------------------------------------------------------------------

endDeepRun:
	exitDRThread = 1
return

levelUpHero:
	ctrl_click(xLvl, yLvl + oLvl, 1, 0)
	if (exitDRThread) {
		elapsedTime := (A_TickCount - drStartTime) / 1000
		clicksPerSecond := round(monsterClicks / elapsedTime, 2)

		setTimer,, off
		setTimer, hunt4Clickable, off
		setTimer, activateSkills, off
		setTimer, slayMonsters, off

		show_splash("Deep run ended (" . clicksPerSecond . " cps)")
	}
return

hunt4Clickable:
	get_clickable()
return

activateSkills:
	cds := coolDownTime * 60 * 1000 + 1000
	activate_skills()
	activate_edr_skills()
	sleep % cds
	activate_er_skills()
	activate_skills()
	sleep % cds
return

slayMonsters:
	click_(xMonster, yMonster)
	monsterClicks++
return
