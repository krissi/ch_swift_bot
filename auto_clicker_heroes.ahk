#Persistent
SetTitleMatchMode 3 ; 1 - must start with, 2 - can contain anywhere, 3 - must exactly match
winName=Clicker Heroes

zzz = 300 ; sleep delay (in ms) after a click
exitThread = 0

; -----------------------------------------------------------------------------------------
; Configuration
; -----------------------------------------------------------------------------------------

; Use Windows Spy or click Alt+MiddleMouseButton to tune the below (relative) coordinates:

; Top LVL UP button when scrolled to the bottom
xLvl = 100
yLvl = 285

yLvlInit = 273 ; adjusted y position used during the init run

oLvl = 107 ; offset to next lvl up button

; Up and down arrows
xScroll = 555
yUp = 220
yDown = 650

; Buy Available Upgrades button
xBuy = 300
yBuy = 580

; Ascension button
ascDownClicks = 24 ; # of down clicks needed to spot the button after a speed run
xAsc = 310
yAsc = 591

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

    sleep 10000 ; wait 10s to pick up all coins
}

; Important! Configure your gilded heroes in the speed_run() function.

; -----------------------------------------------------------------------------------------
; Hotkeys
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
	init_run()
return

!F2::
	speed_run()
return

!F3::
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
; Functions
; -----------------------------------------------------------------------------------------

; Level heroes to 100 and buy all upgrades
; Assumption: Iris at a high enough level (140ish), plus a "clickable" to unlock everything we upgrade

init_run()
{
	scroll_to_top()

	upgrade() ; cid --> brittany
	upgrade() ; fisherman --> leon (change to 8 if needed)
	upgrade() ; seer --> mercedes
	upgrade(8) ; bobby --> king
	upgrade() ; ice --> amenhotep
	upgrade(3) ; beastlord --> shinatobe
	upgrade(0, 1) ; grant & frostleaf

	buy_available_upgrades()
}

upgrade(times:=7, skip:=0) ; usually 7 scroll down clicks to reach the next 4 heroes, override above when needed
{
	global

	if (!skip) {
		ctrl_click(xLvl, yLvlInit)
		ctrl_click(xLvl, yLvlInit + oLvl)
	}
	ctrl_click(xLvl, yLvlInit + oLvl*2)
	ctrl_click(xLvl, yLvlInit + oLvl*3)

	scroll_down(times)
}

; http://s3-us-west-2.amazonaws.com/clickerheroes/ancientssoul.html
; Adjust to optimal level runs (usually 30-40 minutes)
; First (one or) two heroes are expected to insta-kill everything with little to no gilds
; at a speed of around 7 minutes per 250 levels
speed_run()
{
	; scroll_to_top()
	; scroll_down(9)
	; lvlup(9, 10) ; samurai

	scroll_to_bottom()
	lvlup(7, 4) ; frostleaf to lvl 550+

	; Not yet upgraded ranger(s) at 2nd button position
	scroll_down(4)
	lvlup(7, 1, 1, 2) ; atlas to lvl 800+
	scroll_down(2)
	lvlup(20, 1, 1, 2) ; terra

	show_splash("Speed run completed.")
}

ascend(autoYes:=0)
{
	global
	exitThread = 0

	show_splash("10 seconds to ASCENSION! (Abort with Alt+Break)", 10)
	if (exitThread) {
		show_splash("Ascension aborted!")
		exit
	}
	scroll_to_top()
	scroll_down(ascDownClicks)

	ctrl_click(xLvl, yAsc) ; lvl up amenhotep to unlock the ascension button
	clicky(xAsc, yAsc)
	if (autoYes) {
		clicky(xYes, yYes)
	}
}

; Level up the hero at positions 1 (default) to 4 once every 10s during the minutes given
lvlup(minutes, clickCount:=1, buyUpgrades:=0, button:=1)
{
	global
	exitThread = 0
	local y := yLvl + oLvl * (button - 1)

	ctrl_click(xLvl, y, clickCount)
	if (buyUpgrades) {
		buy_available_upgrades()
	}

	loop % minutes * 6 {
		ctrl_click(xLvl, y)
		sleep 10000
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

show_splash(text, seconds:=5, soundOn:=1)
{
	splashtexton,200,40,Auto-clicker,%text%
	if (soundOn) {
		SoundPlay, %A_WinDir%\Media\tada.wav
	}
	sleep % seconds * 1000
	splashtextoff
}