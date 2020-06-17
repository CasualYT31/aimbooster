extends Control

var settingsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	_makeAllVisible(true)

func _makeAllVisible(flag):
	get_node("PauseMenu").visible = flag
