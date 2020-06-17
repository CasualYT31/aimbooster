extends MarginContainer

signal show_settings_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ContinueButton_pressed():
	visible = false

func _on_SettingsButton_pressed():
	emit_signal("show_settings_menu")

func _on_QuitButton_pressed():
	Global.currentMenu = Global.Menu.MAIN
