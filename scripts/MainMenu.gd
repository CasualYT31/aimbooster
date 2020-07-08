extends Control

signal open_settings_menu
signal open_game_menu

func _on_StartGame_pressed():
	emit_signal("open_game_menu")

func _on_Settings_pressed():
	emit_signal("open_settings_menu")

func _on_EndGame_pressed():
	Global.retainWindowPosition()
	get_tree().quit()
