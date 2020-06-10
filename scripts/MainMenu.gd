extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartGame_pressed():
	emit_signal("open_game_menu")

func _on_Settings_pressed():
	emit_signal("open_settings_menu")

func _on_EndGame_pressed():
	pass
