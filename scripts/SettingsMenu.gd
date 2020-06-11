extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_node("MarginContainer/GridContainer/SoundVolume").value = 100.0
	pass

func _on_SoundVolume_value_changed(value):
	Settings.setSoundVolume(value)

func _draw():
	get_node("GameAudio/HitShot").play()

func _on_BackButton_pressed():
	Settings.currentMenu = Settings.previousMenu
