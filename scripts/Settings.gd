extends Node

class_name Settings

const INFINITE_LIVES: int = 0
const INFINITE_TIME: float = -1.0

export var soundVolume: float = 100.0 setget setSoundVolume, getSoundVolume
export var musicVolume: float = 100.0 setget setMusicVolume, getMusicVolume
export var enemyMode: bool = false setget setEnemyMode, getEnemyMode
export var lives: int = 3 setget setLives, getLives
export var time: float = INFINITE_TIME setget setTime, getTime
export var fullscreen: bool = OS.window_fullscreen setget setFullscreen, getFullscreen

enum Audio {BG, HIT, MISS}

func playAudio(id):
	if (id == Audio.BG):
		get_node("BGM").play()
	elif (id == Audio.HIT):
		get_node("HitShot").play()
	elif (id == Audio.MISS):
		get_node("MissedShot").play()

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
