extends Control

var Statistics = preload("res://scripts/Statistics.gd")
var Settings = preload("res://scripts/Settings.gd")

var statistics
# keeps track of the length of the game, not including pausing
# should be initialised to OS.get_unix_time() in _ready(),
# and a signal should be sent every second to this script,
# which increments this value by 1 if unpaused
# NOTE: IN THE NEW GAME SCENE, A TIMER NODE IS REQUIRED
var currentTime: int

var settingsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	# load game settings ONCE at the beginning and disregard for the rest of
	# execution: this means that, even if a player were to edit the script
	# mid-game, the game will run as expected and will not change
	var settings = Settings.new()
	# initialise statistics object
	statistics = Statistics.new(settings.lives, settings.time)
	# start the time counter
	currentTime = OS.get_unix_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PauseMenu_show_settings_menu():
	_makeAllVisible(false)
	settingsMenu = load("res://scenes/SettingsMenu.tscn").instance()
	settingsMenu.connect("go_back_to_game_menu", self, "_on_SettingsMenu_go_back_to_game_menu")
	get_node("SettingsMenu").add_child(settingsMenu)

func _on_SettingsMenu_go_back_to_game_menu():
	call_deferred("_removeSettingsMenu")

func _removeSettingsMenu():
	get_node("SettingsMenu").remove_child(settingsMenu)
	settingsMenu.free()
	# some sort of reloading of settings here ...
	_makeAllVisible(true)

func _makeAllVisible(flag):
	get_node("PauseMenu").visible = flag
