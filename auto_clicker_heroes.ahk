#Persistent
SetTitleMatchMode 3 ; 1 - must start with, 2 - can contain anywhere, 3 - must exactly match
winName=Clicker Heroes

zzz = 300 ; sleep delay (in ms) after a click

; Coordinates taken from the Steam client, in windowed mode, using Window Spy's relative mouse position

; Top LVL UP button (center) coordinates
x = 100
y = 285
o = 107 ; offset to next button

; Script pause toggle
Pause::Pause
return

!Pause::
	global exitThread = 1
	show_splash("Run aborted!")
return

; Alt+F1 to F3 are here for testing purposes before running the full speed run loop (Ctrl+F1)

!F1::
	init_run()
return

!F2::
	speed_run()
return

!F3::
	ascend()
return

^F1::
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
	loop
	{
		lvlup(10)
		toggle_mode()
	}
return

; Level heroes to 100 and buy all upgrades
; Assumption: Iris at a high enough level (140ish), plus a "clickable" to unlock everything we upgrade

init_run()
{
	scroll_to_top()

	upgrade(7) ; cid --> brittany
	upgrade(7) ; fisherman --> leon
	upgrade(7) ; seer --> mercedes
	upgrade(8) ; bobby --> king
	upgrade(7) ; ice --> amenhotep
	upgrade(3) ; beastlord --> shinatobe
	upgrade(0, 1) ; grant & frostleaf

	buy_available_upgrades()
}

; Tune the scroll down click count (to 7 or 8) above and try to adjust the
; local y coordinate below to keep itself inside the top lvl up button

; Tips:
; * Temporarily change the "ctrl_click" function to "clicky"
; * Right-click the AutoHotkey script in the task bar and start Windows Spy
; * After an ascension + "clickable":
;   * Position your mouse pointer at relative coordinates 100, 273
;   * Hit Alt+F1 and see if the pointer stays inside the lvl up button
;   * Adjust when needed

upgrade(timesDown, skip:=0)
{
	global
	local ly = 273

	if (!skip) {
		ctrl_click(x, ly)
		ctrl_click(x, ly+o)
	}
	ctrl_click(x, ly+o*2)
	ctrl_click(x, ly+o*3)

	scroll_down(timesDown)
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

	show_splash("Speed run completed!")
}

ascend(autoYes:=0)
{
	global
	scroll_to_top()
	scroll_down(24) ; <-- adjust as needed

	ctrl_click(x, 575) ; lvl up amenhotep
	clicky(310, 590) ; ascend
	if (autoYes) {
		clicky(500, 445) ; yes
	}
}

; Click'em all!
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

; Level up the hero at position 1 (default) to 4 every 10s during the minutes given
; Note that the loop can be aborted with Alt+Pause
lvlup(minutes, clickCount:=1, buyUpgrades:=0, button:=1)
{
	global
	exitThread = 0
	local ly = y + o * (button - 1)

	ctrl_click(x, ly, clickCount)
	if (buyUpgrades) {
		buy_available_upgrades()
	}

	loop % minutes * 6 {
		ctrl_click(x, ly)
		sleep 10000
		if (exitThread) {
			exit
		}
	}
}

buy_available_upgrades() {
	scroll_to_bottom()
	clicky(300, 580)
}

scroll_up(clickCount:=1) {
	global
	clicky(555, 220, clickCount)
	sleep % zzz * 2
}

scroll_down(clickCount:=1) {
	global
	clicky(555, 650, clickCount)
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

show_splash(text)
{
	splashtexton,200,40,Auto-clicker,%text%
	SoundPlay, %A_WinDir%\Media\tada.wav
	sleep 5000
	splashtextoff
}