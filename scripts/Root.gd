extends Node

var Settings = preload("res://scripts/Settings.gd")

var tracker: bool = false

func _ready():
	# remember old window size
	var file = File.new()
	if file.file_exists("res://window_size.json"):
		if file.open("res://window_size.json", File.READ) == 0:
			var data = parse_json(file.get_line())
			OS.set_window_size(Vector2(data["x"], data["y"]))
			file.close()
	# open main menu
	Global.currentMenu = Global.Menu.MAIN

# manages background music continuously.
# there is a danger that alert dialogs will be produced continuously
# if loading settings fails, then the subsequent saving fails, continuously...
# see Settings._init() and Settings.save()
func _process(_delta):
	var settings = Settings.new() # calls Settings._init()
	var musicNode = get_node("BGM")
	musicNode.volume_db = settings.getMusicVolumeAsDb()
	if settings.musicVolume < 1.0:
		musicNode.stop()
		tracker = false
	else:
		if (!tracker):
			musicNode.play()
			tracker = true
