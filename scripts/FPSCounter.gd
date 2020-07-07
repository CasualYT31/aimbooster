extends Label

func _process(delta):
	text = ""
	text += "fps: " + str(Engine.get_frames_per_second())
