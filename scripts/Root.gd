extends Node

var Settings = preload("res://scripts/Settings.gd")

var MainMenuScene = preload("res://scenes/MainMenu.tscn")
var SettingsScene = preload("res://scenes/SettingsMenu.tscn")
var GameScene = preload("res://scenes/GameMenu.tscn")

var tracker: bool = false

onready var musicNode = get_node("BGM")
onready var fpsNode = get_node("FPSCounter")

var mainMenu
var settingsMenu
var gameMenu

func _on_MainMenu_open_settings_menu():
	_close(mainMenu)
	_openSettingsMenu()

func _on_MainMenu_open_game_menu():
	_close(mainMenu)
	_openGameMenu()

func _on_SettingsMenu_open_previous_menu():
	_close(settingsMenu)
	_openMainMenu()

func _on_GameMenu_open_main_menu():
	_close(gameMenu)
	_openMainMenu()

func _ready():
	Global.recallWindowPosition()
	randomize()
	_openMainMenu()

func _close(menu):
	remove_child(menu)
	menu.queue_free()

func _openMainMenu():
	mainMenu = MainMenuScene.instance()
	mainMenu.connect("open_settings_menu", self, "_on_MainMenu_open_settings_menu")
	mainMenu.connect("open_game_menu", self, "_on_MainMenu_open_game_menu")
	add_child(mainMenu)

func _openSettingsMenu():
	settingsMenu = SettingsScene.instance()
	settingsMenu.limit = false
	settingsMenu.connect("open_previous_menu", self, "_on_SettingsMenu_open_previous_menu")
	add_child(settingsMenu)

func _openGameMenu():
	gameMenu = GameScene.instance()
	gameMenu.connect("open_main_menu", self, "_on_GameMenu_open_main_menu")
	add_child(gameMenu)

# manages background music continuously.
# there is a danger that alert dialogs will be produced continuously
# if loading settings fails, then the subsequent saving fails, continuously...
# see Settings._init() and Settings.save()
func _process(_delta):
	var settings = Settings.new()
	musicNode.volume_db = settings.getMusicVolumeAsDb()
	if settings.musicVolume < 1.0:
		musicNode.stop()
		tracker = false
	else:
		if (!tracker):
			musicNode.play()
			tracker = true
	fpsNode.visible = settings.getFPSVisible()

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		Global.retainWindowPosition()
		get_tree().quit()
