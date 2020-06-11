extends Node

const INFINITE_LIVES: int = 0
const INFINITE_TIME: float = -1.0

export var soundVolume: float = 100.0 setget setSoundVolume, getSoundVolume
export var musicVolume: float = 100.0 setget setMusicVolume, getMusicVolume
export var enemyMode: bool = false setget setEnemyMode, getEnemyMode
export var lives: int = 3 setget setLives, getLives
export var time: float = INFINITE_TIME setget setTime, getTime
export var fullscreen: bool = OS.window_fullscreen setget setFullscreen, getFullscreen

enum Audio {BG, HIT, MISS}
enum Menu {NONE, MAIN, SETTINGS, GAME, STATISTICS}

export var currentMenu: int = Menu.NONE setget setCurrentMenu, getCurrentMenu
export var previousMenu: int = Menu.NONE setget , getPreviousMenu
var menuNode = null

func playAudio(id):
	if (id == Audio.BG):
		get_node("BGM").play()
	elif (id == Audio.HIT):
		get_node("HitShot").play()
	elif (id == Audio.MISS):
		get_node("MissedShot").play()
	else:
		OS.alert("Invalid ID given for playAudio(): " + str(id))

func setSoundVolume(newval):
	if (newval > 100.0):
		newval = 100.0
	elif (newval < 0.0):
		newval = 0.0
	soundVolume = newval
	if (soundVolume >= 1.0):
		get_node("HitShot").pause_mode = false
		get_node("MissedShot").pause_mode = false
		get_node("HitShot").volume_db = -26.0 + soundVolume / 2
		get_node("MissedShot").volume_db = -26.0 + soundVolume / 2
	else:
		get_node("HitShot").pause_mode = true
		get_node("MissedShot").pause_mode = true

func getSoundVolume():
	return soundVolume

func setMusicVolume(newval):
	if (newval > 100.0):
		newval = 100.0
	elif (newval < 0.0):
		newval = 0.0
	musicVolume = newval
	if (musicVolume >= 1.0):
		get_node("BGM").pause_mode = false
		get_node("BGM").volume_db = -26 + musicVolume / 2
	else:
		get_node("BGM").pause_mode = true

func getMusicVolume():
	return musicVolume

func setEnemyMode(newval):
	enemyMode = newval

func getEnemyMode():
	return enemyMode

func setLives(newval):
	if (newval < 0):
		newval = 0
	lives = newval

func getLives():
	return lives

func setTime(newval):
	if (newval < 0.0):
		newval = -1.0
	elif (newval < 1.0):
		newval = 1.0
	time = newval

func getTime():
	return time

func setFullscreen(newval):
	fullscreen = newval
	OS.window_fullscreen = fullscreen

func getFullscreen():
	return fullscreen

func setCurrentMenu(newval):
	call_deferred("_switchToMenu", newval)

func getCurrentMenu():
	return currentMenu

func getPreviousMenu():
	return previousMenu

# use call_deferred() to ensure that this method is called at a later time,
# when deleting the current scene will be OK
# please don't call this outside of this script file...
# wish there was a way to enforce that but oh well... you can't have everything...
func _switchToMenu(id):
	var path = "res://scenes/"
	match id:
		Menu.MAIN:
			path += "MainMenu.tscn"
		Menu.SETTINGS:
			path += "SettingsMenu.tscn"
		Menu.GAME:
			path += "GameMenu.tscn"
		Menu.STATISTICS:
			path += "StatisticsMenu.tscn"
		_:
			OS.alert("Invalid menu ID: " + str(id))
			return
	previousMenu = currentMenu
	currentMenu = id
	if (menuNode != null):
		remove_child(menuNode)
		menuNode.free()
	menuNode = load(path).instance()
	add_child(menuNode)
