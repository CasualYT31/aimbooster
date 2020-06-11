extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundVolume").value = Settings.soundVolume
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(Settings.soundVolume)
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicVolume").value = Settings.musicVolume
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(Settings.musicVolume)
	Settings.playAudio(Settings.Audio.BG)

func _on_BackButton_pressed():
	Settings.currentMenu = Settings.previousMenu

func _on_SoundVolume_value_changed(value):
	Settings.soundVolume = value
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(value)

func _on_MusicVolume_value_changed(value):
	Settings.musicVolume = value
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(value)
