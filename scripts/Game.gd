extends Control

var Statistics = preload("res://scripts/Statistics.gd")
var Settings = preload("res://scripts/Settings.gd")

var statistics
var settings
# keeps track of the length of the game, not including pausing
var seconds: float = 0.0
var minutes: int = 0
var spawnTimerVal: int
var lives: int

var settingsMenu

func _isPaused():
	return get_node("GameGUI/PauseMenu").visible

func _pause():
	get_node("GameGUI/PauseMenu").visible = true

func _unpause():
	get_node("GameGUI/PauseMenu").visible = false

func _updateLivesDisplay():
	get_node("GameGUI/HUD/LivesLabel").text = "Lives: " + (str(lives) if lives > 0 else "Inf")

# Called when the node enters the scene tree for the first time.
func _ready():
	settings = Settings.new()
	statistics = Statistics.new(settings.lives, settings.time)
	lives = settings.lives
	_updateLivesDisplay()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if _isPaused():
				_unpause()
			else:
				_pause()

func _makeAllVisible(flag):
	get_node("GameGUI").visible = flag

func _process(delta):
	# HUD timer
	if !_isPaused():
		seconds += delta
	var strSeconds = str(int(seconds))
	if int(seconds) == 60:
		seconds = 0.0
		minutes += 1
	var strMinutes = str(minutes)
	if len(strMinutes) == 1:
		strMinutes = "0" + strMinutes
	if len(strSeconds) == 1:
		strSeconds = "0" + strSeconds
	get_node("GameGUI/HUD/TimeLabel").text = "Time: " + strMinutes + ":" + strSeconds

func _on_ContinueButton_pressed():
	_unpause()

func _on_SettingsButton_pressed():
	_makeAllVisible(false)
	settingsMenu = load("res://scenes/SettingsMenu.tscn").instance()
	settingsMenu.connect("go_back_to_game_menu", self, "_on_SettingsMenu_go_back_to_game_menu")
	add_child(settingsMenu)

func _on_SettingsMenu_go_back_to_game_menu():
	call_deferred("_removeSettingsMenu")

func _removeSettingsMenu():
	remove_child(settingsMenu)
	settingsMenu.free()
	# reload settings here
	# we must ensure that certain settings remain the same,
	# so temporarily store them now then apply them to the new settings object
	var currentEnemyModeSetting = settings.isEnemyMode
	var currentLivesSetting = settings.lives
	var currentTimeSetting = settings.time
	settings = Settings.new()
	settings.isEnemyMode = currentEnemyModeSetting
	settings.lives = currentLivesSetting
	settings.time = currentTimeSetting
	_makeAllVisible(true)

func _on_QuitButton_pressed():
	Global.currentMenu = Global.Menu.MAIN
