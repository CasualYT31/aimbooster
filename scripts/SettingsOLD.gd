extends Node2D

class_name SettingsOLD

var soundVolume: float = 100.0
var musicVolume: float = 100.0
var enemyMode: bool = false
var lives: int = 3
var time: float = -1.0

func getSoundVolume():
	return soundVolume

func getMusicVolume():
	return musicVolume
	
func isEnemyMode():
	return enemyMode

func getMaxLives():
	return lives

func getTime():
	return time

func getFullscreen():
	return OS.window_fullscreen

func getShootButton():
	pass

func setSoundVolume(newVolume: float):
	soundVolume = newVolume

func setMusicVolume(newVolume: float):
	musicVolume = newVolume

func setEnemyMode(newMode: bool):
	enemyMode = newMode

func setLives(newLives: int):
	lives = newLives

func setTime(newTime: float):
	time = newTime

func setFullscreen():
	OS.window_fullscreen = !OS.window_fullscreen

# True for left button, False for right button
func setShootButton(newButton: bool):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
