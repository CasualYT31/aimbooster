extends Control

# Called when the node enters the scene tree for the first time.

var multiLives: = "lives"
var multiMins: = " min"

func _ready():
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundVolume").value = Settings.soundVolume
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(Settings.soundVolume)
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicVolume").value = Settings.musicVolume
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(Settings.musicVolume)
	get_node("MarginContainer/VBoxContainer/GridContainer/Lives").value = Settings.lives
	get_node("MarginContainer/VBoxContainer/GridContainer/LivesValueLabel").text = str(Settings.lives) + multiLives
	get_node("MarginContainer/VBoxContainer/GridContainer/Time").value = Settings.time
	get_node("MarginContainer/VBoxContainer/GridContainer/TimeValueLabel").text = str(Settings.time) + multiMins

func _on_BackButton_pressed():
	Settings.currentMenu = Settings.previousMenu

func _on_SoundVolume_value_changed(value):
	Settings.soundVolume = value
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(value)

func _on_MusicVolume_value_changed(value):
	Settings.musicVolume = value
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(value)

func _on_Fullscreen_toggled(_button_pressed):
	Settings.fullscreen = !Settings.fullscreen


func _on_Lives_value_changed(value):
	Settings.lives = value
	
	if (value == 1):
		multiLives = " life"
	else:
		multiLives = " lives"
		
	get_node("MarginContainer/VBoxContainer/GridContainer/LivesValueLabel").text = str(value) + multiLives


func _on_Time_value_changed(value):
	Settings.time = value
	
	if (value == 1):
		multiMins = " min"
	else:
		multiMins = " mins"
	
	get_node("MarginContainer/VBoxContainer/GridContainer/TimeValueLabel").text = str(value) + multiMins
