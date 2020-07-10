extends Node

var Settings = preload("res://scripts/Settings.gd")

var MainMenuScene = preload("res://scenes/MainMenu.tscn")
var SettingsScene = preload("res://scenes/SettingsMenu.tscn")
var GameScene = preload("res://scenes/GameMenu.tscn")
var HelpScene = preload("res://scenes/HelpMenu.tscn")

var tracker := false
var errorTracker := false

var mainMenu
var settingsMenu
var gameMenu
var helpMenu

func _on_MainMenu_open_settings_menu():
	_close(mainMenu)
	_openSettingsMenu()

func _on_MainMenu_open_game_menu():
	_close(mainMenu)
	_openGameMenu()

func _on_MainMenu_open_help_menu():
	_close(mainMenu)
	_openHelpMenu()

func _on_SettingsMenu_open_previous_menu():
	_close(settingsMenu)
	_openMainMenu()

func _on_GameMenu_open_main_menu():
	_close(gameMenu)
	_openMainMenu()

func _on_HelpMenu_open_main_menu():
	_close(helpMenu)
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
	mainMenu.connect("open_help_menu", self, "_on_MainMenu_open_help_menu")
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

func _openHelpMenu():
	helpMenu = HelpScene.instance()
	helpMenu.connect("open_main_menu", self, "_on_HelpMenu_open_main_menu")
	add_child(helpMenu)

# manages background music and FPS counter visibility continuously
func _process(_delta):
	var settings = Settings.new()
	if settings.errorCount < 2:
		$BGM.volume_db = settings.getMusicVolumeAsDb()
		if settings.musicVolume < 1.0:
			$BGM.stop()
			tracker = false
		else:
			if (!tracker):
				$BGM.play()
				tracker = true
	elif !errorTracker:
		# prevent endless cicle of error dialogs
		errorTracker = true
	$FPSCounter.visible = settings.getFPSVisible()

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		Global.retainWindowPosition()
		get_tree().quit()
