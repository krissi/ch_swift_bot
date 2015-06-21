#Persistent
SetTitleMatchMode 3 ; 1 - must start with, 2 - can contain anywhere, 3 - must exactly match
winName=Clicker Heroes

zzz = 300 ; sleep delay (in ms) after a click
exitThread = 0

; -----------------------------------------------------------------------------------------
;   Configuration
; -----------------------------------------------------------------------------------------

; http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html
; speed_run config

optimalLevel = 1670
irisLevel = 540

; Lvl needed to immediately start leveling a ranger at 200 or above:
; Atlas (540), Terra (790), Phthalo (1040), Didensy (1290)

firstStintLevel = 790 ; when Iris is equal or higher, hop to the next in the list

initialHero = 2 ; when scrolling to the bottom, start level up the 1st or 2nd hero?
heroCount = 3 ; number of heroes (minimum 2) we will use to reach our optimal level

extraTime = 0 ; if the script can't reach set level at max speed, add a little extra time (in minutes)

; With the above settings, the script will do the following:
; Start level with Atlas from 540 to 790, then Terra till ~1040 and lastly Phthalo till 1670

; -----------------------------------------------------------------------------------------

; Use Windows Spy or click Alt+MiddleMouseButton to tune the below (relative) coordinates.
; Client size -- w: 1136, h: 640

; Top LVL UP button when scrolled to the bottom
xLvl = 100
yLvl = 285

yLvlInit = 240 ; adjusted y position used during the init run

oLvl = 107 ; offset to next lvl up button

; Up and down arrows
xScroll = 555
yUp = 220
yDown = 650

; Buy Available Upgrades button
xBuy = 300
yBuy = 580

; Ascension button
ascDownClicks = 23 ; # of down clicks needed to spot the button after a speed run
xAsc = 310
yAsc = 600

; Ascend Yes button
xYes = 500
yYes = 445

; No smart image recognition, so we click'em all!
get_clickables()
{
    clicky(524, 487)
    clicky(747, 431)
    clicky(755, 480)
    clicky(760, 380)
    clicky(873, 512)
    clicky(1005, 453)
    clicky(1053, 443)

    sleep 8000 ; wait 8s to pick up all coins
}

; -----------------------------------------------------------------------------------------
;   Hotkeys
; -----------------------------------------------------------------------------------------

; Show the cursor position with Alt+MiddleMouseButton
!mbutton::
	mousegetpos, xpos, ypos
	msgbox, Cursor position: x%xpos% y%ypos%
return

; Script pause toggle
Pause::Pause
return

; Script abort
!Pause::
	show_splash("Aborting...", 5, 0)
	exitThread = 1
return

; Alt+F1 to F3 are here for testing purposes before running the full speed run loop

!F1::
	keywait, alt
	init_run()
return

!F2::
	keywait, alt
	speed_run()
return

!F3::
	keywait, alt
	ascend()
return

; The main speed run loop! Start with Ctrl+F1
^F1::
	keywait, ctrl
	loop
	{
		init_run()
		speed_run()
		ascend(1) ; auto-click yes
		get_clickables()
		toggle_mode() ; toggle back to progression mode
	}
return

; Simple long run embryo that loops 10 minutes of progression and farm mode till aborted (Alt+Pause)
; Use to get a few new gilds every now and then
^F2::
	keywait, ctrl
	loop
	{
		lvlup(10)
		toggle_mode()
	}
return

; -----------------------------------------------------------------------------------------
;   Functions
; -----------------------------------------------------------------------------------------

; Level Cid --> Amenhotep to 200, Beastlord --> Frostleaf to 100 and buy all upgrades.
; Assumption: Iris above level 140, plus a "clickable" to unlock everything we upgrade

init_run()
{
	sleep 1000
	scroll_to_top()

	; Iris level dictates how many scroll down clicks we need to reach the next four heroes
	upgrade(7, 2) ; cid --> brittany
	upgrade(7, 2) ; fisherman --> leon (change to 8 if needed)
	upgrade(7, 2) ; seer --> mercedes
	upgrade(7, 2) ; bobby --> king (change to 8 if needed)
	upgrade(7, 2) ; ice --> amenhotep
	upgrade(3, 1) ; beastlord --> shinatobe
	upgrade(0, 1, 1) ; grant & frostleaf

	buy_available_upgrades()
}

upgrade(times, clickCount, skip:=0)
{
	global

	if (!skip) {
		ctrl_click(xLvl, yLvlInit, clickCount)
		ctrl_click(xLvl, yLvlInit + oLvl, clickCount)
	}
	ctrl_click(xLvl, yLvlInit + oLvl*2, clickCount)
	ctrl_click(xLvl, yLvlInit + oLvl*3, clickCount)

	scroll_down(times)
}

; All heroes/rangers are expected to "insta-kill" everything at max speed (i.e. around
; 7 minutes per 250 levels). Only the last 2-3 minutes should slow down slightly.
speed_run()
{
	global
	middleStints := heroCount - 2
	runTime := ceil((optimalLevel - irisLevel) * 7 / 250)
	firstStintTime := ceil((firstStintLevel - irisLevel) * 7 / 250)
	middleStintTime = 7
	lastStintTime := runTime - firstStintTime - middleStintTime*middleStints + extraTime

	scroll_to_bottom()
	lvlup(firstStintTime, 1, initialHero)
	loop % middleStints
	{
		scroll_way_down(2)
		lvlup(middleStintTime, 1, 2)
	}
	scroll_way_down(2)
	lvlup(lastStintTime, 1, 2)

	show_splash("Speed run completed.")
}

ascend(autoYes:=0)
{
	global
	exitThread = 0

	show_splash("10 seconds till ASCENSION! (Abort with Alt+Pause)", 10, 2)
	if (exitThread) {
		show_splash("Ascension aborted!")
		exit
	}
	scroll_to_top()
	scroll_down(ascDownClicks)

	clicky(xAsc, yAsc)
	if (autoYes) {
		clicky(xYes, yYes)
	}
}

; Level up the hero at positions 1 (default) to 4 once every 10s during the minutes given
lvlup(minutes, buyUpgrades:=0, button:=1)
{
	global
	exitThread = 0
	local y := yLvl + oLvl * (button - 1)

	if (buyUpgrades) {
		ctrl_click(xLvl, y)
		buy_available_upgrades()
	}
	max_click(xLvl, y)

	loop % minutes * 6 {
		ctrl_click(xLvl, y)
		sleep % 10000 - zzz ; compensate for the click delay
		if (exitThread) {
			show_splash("Run aborted!")
			exit
		}
	}
}

buy_available_upgrades() {
	global
	scroll_to_bottom()
	clicky(xBuy, yBuy)
}

scroll_up(clickCount:=1) {
	global
	clicky(xScroll, yUp, clickCount)
	sleep % zzz * 2
}

scroll_down(clickCount:=1) {
	global
	clicky(xScroll, yDown, clickCount)
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
	ControlClick,,% winName,,wheelup,20
	sleep % zzz * 3
}

scroll_to_bottom()
{
	global
	ControlClick,,% winName,,wheeldown,20
	sleep % zzz * 3
}

max_click(xCoord, yCoord)
{
	global
	ControlSend,, {shift down}{q down}, % winName
	ControlClick,% "x" xCoord " y" yCoord,% winName,,,,Pos
	ControlSend,, {q up}{shift up}, % winName
	sleep % zzz
}

ctrl_click(xCoord, yCoord, clickCount:=1)
{
	global
	ControlSend,, {ctrl down}, % winName
	ControlClick,% "x" xCoord " y" yCoord,% winName,,,% clickCount,Pos
	ControlSend,, {ctrl up}, % winName
	sleep % zzz
}

clicky(xCoord, yCoord, clickCount:=1)
{
	global
	ControlClick,% "x" xCoord " y" yCoord,% winName,,,% clickCount,Pos
	sleep % zzz
}

; Toggle between farm and progression modes
toggle_mode()
{
	global
	ControlSend,, {a down}{a up}, % winName
	sleep % zzz
}

show_splash(text, seconds:=5, sound:=1)
{
	splashtexton,200,40,Auto-clicker,%text%
	if (sound = 1) {
		SoundPlay, %A_WinDir%\Media\Windows User Account Control.wav
	} else if (sound = 2) {
		SoundPlay, %A_WinDir%\Media\tada.wav
	}
	sleep % seconds * 1000
	splashtextoff
}