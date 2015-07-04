; -----------------------------------------------------------------------------------------
; Clicker Heroes Monster Clicker
; v1.0
; by Sw1ftb

; Shift+F6 to start
; Shift+F7 to stop
; Shift+F8 to reload

; Built in click speed throttle when moving mouse cursor inside the Clicker Heroes window.

; -----------------------------------------------------------------------------------------

#Persistent
#NoEnv
#InstallKeybdHook

SetControlDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 3 ; Steam (3) or browser (regex) version?

winName=Clicker Heroes
; winName=Lvl.*Clicker Heroes.*

xMonster = 860
yMonster = 420

short := 21 ; ms
long := 2000
clickDelay := short

+F6::
	duration := 0 ; minutes (set to zero for manual/remote operation)
	keepOnClicking = 1
	monsterClicks = 0

	showSplash("Starting...")

	drStartTime := A_TickCount
	if (duration > 0) {
		setTimer, stopClicking, % -duration * 60 * 1000 ; run only once
	}
	setTimer, checkMouse, 1000

	while(keepOnClicking) {
		ControlClick,% "x" xMonster " y" yMonster,% winName,,,,Pos
		monsterClicks++
	    sleep % clickDelay
	}

	setTimer, checkMouse, off

	elapsedTime := (A_TickCount - drStartTime) / 1000
	clicksPerSecond := round(monsterClicks / elapsedTime, 2)
	showSplash("Average CPS: " . clicksPerSecond, 5)
return

+F7::
	keepOnClicking = 0
return

+F8::
	showSplash("Reloading clicker...", 1)
	Reload
return

checkMouse:
	MouseGetPos,,, window
	if (window = WinExist(winName)) {
		clickDelay := long
	} else {
		clickDelay := short
	}
return

stopClicking:
	keepOnClicking = 0
return

showSplash(text, seconds:=2)
{
	yPos := A_ScreenHeight // 2 + 50
	progress,% "w200 y" yPos " zh0 fs10", %text%,, Monster Clicker v1.0
	sleep % seconds * 1000
	progress, off
}
