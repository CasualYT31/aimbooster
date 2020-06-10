extends Control

func _on_StartGame_pressed():
	Settings.openGame()

func _on_Settings_pressed():
	Settings.openSettingsMenu()

func _on_EndGame_pressed():
	get_tree().quit()
