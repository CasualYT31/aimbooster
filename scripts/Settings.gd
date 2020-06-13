extends Node

const INFINITE_LIVES: int = 0
const INFINITE_TIME: float = 0.0

export var soundVolume: float = 50.0 setget setSoundVolume, getSoundVolume
export var musicVolume: float = 50.0 setget setMusicVolume, getMusicVolume
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
		menuNode.get_node("GameAudio/BGM").play()
	elif (id == Audio.HIT):
		menuNode.get_node("GameAudio/HitShot").play()
	elif (id == Audio.MISS):
		menuNode.get_node("GameAudio/MissedShot").play()
	else:
		OS.alert("Invalid ID given for playAudio(): " + str(id))

func setSoundVolume(newval):
	if (newval > 100.0):
		newval = 100.0
	elif (newval < 0.0):
		newval = 0.0
	soundVolume = newval
	if (soundVolume >= 1.0):
		menuNode.get_node("GameAudio/HitShot").pause_mode = false
		menuNode.get_node("GameAudio/MissedShot").pause_mode = false
		menuNode.get_node("GameAudio/HitShot").volume_db = -50.0 + soundVolume / 2
		menuNode.get_node("GameAudio/MissedShot").volume_db = -50.0 + soundVolume / 2
	else:
		menuNode.get_node("GameAudio/HitShot").pause_mode = true
		menuNode.get_node("GameAudio/MissedShot").pause_mode = true

func getSoundVolume():
	return soundVolume

func setMusicVolume(newval):
	if (newval > 100.0):
		newval = 100.0
	elif (newval < 0.0):
		newval = 0.0
	musicVolume = newval
	if (musicVolume >= 1.0):
		menuNode.get_node("GameAudio/BGM").pause_mode = false
		menuNode.get_node("GameAudio/BGM").volume_db = -50.0 + musicVolume / 2
	else:
		menuNode.get_node("GameAudio/BGM").pause_mode = true

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
