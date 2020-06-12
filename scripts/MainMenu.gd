extends Control

func _ready():
	Settings.playAudio(Settings.Audio.BG)

func _on_StartGame_pressed():
	Settings.currentMenu = Settings.Menu.GAME

func _on_Settings_pressed():
	Settings.currentMenu = Settings.Menu.SETTINGS

func _on_EndGame_pressed():
	get_tree().quit()
