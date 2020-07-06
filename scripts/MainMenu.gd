extends Control

func _on_StartGame_pressed():
	Global.currentMenu = Global.Menu.GAME

func _on_Settings_pressed():
	Global.currentMenu = Global.Menu.SETTINGS

func _on_EndGame_pressed():
	Global.retainWindowPosition()
	get_tree().quit()
