extends Control

var Statistics = preload("res://scripts/Statistics.gd")
var Settings = preload("res://scripts/Settings.gd")

var statistics
# keeps track of the length of the game, not including pausing
var currentTime: int = OS.get_unix_time()

var settingsMenu

func _isPaused():
	return get_node("PauseMenu").visible

func _pause():
	get_node("PauseMenu").visible = true
	get_node("SecondCounter").stop()

func _unpause():
	get_node("PauseMenu").visible = false
	get_node("SecondCounter").start()

# Called when the node enters the scene tree for the first time.
func _ready():
	var settings = Settings.new()
	statistics = Statistics.new(settings.lives, settings.time)

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
	get_node("PauseMenu").visible = flag

func _on_SecondCounter_timeout():
	currentTime += 1
	get_node("Label").text = str(currentTime)

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
