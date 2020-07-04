extends Control

var Statistics = preload("res://scripts/Statistics.gd")
var Settings = preload("res://scripts/Settings.gd")

var statistics
# keeps track of the length of the game, not including pausing
var startTime: int = OS.get_unix_time()
var currentTime: int
var lives: int

var settingsMenu

func _isPaused():
	return get_node("GameGUI/PauseMenu").visible

func _pause():
	get_node("GameGUI/PauseMenu").visible = true
	get_node("SecondCounter").stop()

func _unpause():
	get_node("GameGUI/PauseMenu").visible = false
	get_node("SecondCounter").start()

func _updateLivesDisplay():
	get_node("GameGUI/HUD/LivesLabel").text = "Lives: " + (str(lives) if lives > 0 else "Inf")

# Called when the node enters the scene tree for the first time.
func _ready():
	var settings = Settings.new()
	statistics = Statistics.new(settings.lives, settings.time)
	currentTime = startTime - 1
	_on_SecondCounter_timeout()
	lives = settings.lives
	_updateLivesDisplay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if _isPaused():
				_unpause()
			else:
				_pause()

func _makeAllVisible(flag):
	get_node("GameGUI/PauseMenu").visible = flag

func _on_SecondCounter_timeout():
	currentTime += 1
	var minutes: String = str((currentTime - startTime) / 60)
	if len(minutes) == 1:
		minutes = "0" + minutes
	var seconds: String = str((currentTime - startTime) % 60)
	if len(seconds) == 1:
		seconds = "0" + seconds
	get_node("GameGUI/HUD/TimeLabel").text = "Time: " + minutes + ":" + seconds

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
	# some sort of reloading of settings here ...
	_makeAllVisible(true)

func _on_QuitButton_pressed():
	Global.currentMenu = Global.Menu.MAIN
