extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundVolume").value = Settings.soundVolume
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(Settings.soundVolume)
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicVolume").value = Settings.musicVolume
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(Settings.musicVolume)
	#Lives
	#LivesValueLabel
	get_node("MarginContainer/VBoxContainer/GridContainer/Time").value = Settings.time
	get_node("MarginContainer/VBoxContainer/GridContainer/TimeValueLabel").text = str(Settings.time) + " Mins"

func _on_BackButton_pressed():
	Settings.currentMenu = Settings.previousMenu

func _on_SoundVolume_value_changed(value):
	Settings.soundVolume = value
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(value)

func _on_MusicVolume_value_changed(value):
	Settings.musicVolume = value
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(value)

func _on_Fullscreen_toggled(button_pressed):
	Settings.fullscreen = !Settings.fullscreen


func _on_Lives_value_changed(value):
	Settings.lives = value
	get_node("MarginContainer/VBoxContainer/GridContainer/LivesValueLabel").text = str(value)


func _on_Time_value_changed(value):
	Settings.time = value
	get_node("MarginContainer/VBoxContainer/GridContainer/TimeValueLabel").text = str(value) + " Mins"
