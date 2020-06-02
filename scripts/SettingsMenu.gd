extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_node("MarginContainer/GridContainer/SoundVolume").value = 100.0
	pass

func _on_SoundVolume_value_changed(value):
	if value <= 1.0:
		get_node("GameAudio/HitShot").pause_mode(true)
		get_node("GameAudio/MissedShot").pause_mode(true)
	else:
		get_node("GameAudio/HitShot").pause_mode(false)
		get_node("GameAudio/MissedShot").pause_mode(false)
		get_node("GameAudio/HitShot").volume_db = -26.0 + value / 2
		get_node("GameAudio/MissedShot").volume_db = -26.0 + value / 2

func _draw():
	get_node("GameAudio/HitShot").play()
