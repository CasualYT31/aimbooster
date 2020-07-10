extends Node

enum TargetType {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE}

func recallWindowPosition():
	var file = File.new()
	if file.file_exists("res://window_size.json"):
		if file.open("res://window_size.json", File.READ) == 0:
			var data = parse_json(file.get_line())
			if (!data.has("w")):
				data["w"] = 1920
			if (!data.has("h")):
				data["h"] = 1080
			if (!data.has("x")):
				data["x"] = 0
			if (!data.has("y")):
				data["y"] = 0
			if (!data.has("max")):
				data["max"] = true
			OS.set_window_size(Vector2(data["w"], data["h"]))
			OS.set_window_position(Vector2(data["x"], data["y"]))
			OS.set_window_maximized(data["max"])
			file.close()

func retainWindowPosition():
	# don't retain window position if in full screen mode
	var settings = preload("res://scripts/Settings.gd").new()
	if settings.fullscreen:
		return
	# only retain window position if in windowed mode
	var data = {
		x = OS.get_window_position().x,
		y = OS.get_window_position().y,
		w = OS.get_window_size().x,
		h = OS.get_window_size().y,
		max = OS.is_window_maximized()
	}
	var file = File.new()
	if file.open("res://window_size.json", File.WRITE) == 0:
		file.store_line(to_json(data))
		file.close()
