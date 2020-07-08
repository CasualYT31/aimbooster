extends Node

enum Menu {NONE, MAIN, SETTINGS, GAME, STATISTICS}
enum TargetType {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE}

export var currentMenu: int = Menu.NONE setget setCurrentMenu, getCurrentMenu
export var previousMenu: int = Menu.NONE setget , getPreviousMenu
var menuNode = null

func setCurrentMenu(newval):
	call_deferred("_switchToMenu", newval)

func getCurrentMenu():
	return currentMenu

func getPreviousMenu():
	return previousMenu

# use call_deferred() to ensure that this method is called at a later time,
# when deleting the current scene will be OK
# please don't call this outside of this script file...
# wish there was a way to enforce that but oh well... you can't have everything...
func _switchToMenu(id):
	var path = "res://scenes/"
	match id:
		Menu.MAIN:
			path += "MainMenu.tscn"
		Menu.SETTINGS:
			path += "SettingsMenu.tscn"
		Menu.GAME:
			path += "GameMenu.tscn"
		Menu.STATISTICS:
			path += "StatisticsMenu.tscn"
		_:
			OS.alert("Invalid menu ID: " + str(id))
			return
	previousMenu = currentMenu
	currentMenu = id
	if (menuNode != null):
		remove_child(menuNode)
		menuNode.free()
	menuNode = load(path).instance()
	add_child(menuNode)
	var test = load("res://scenes/Target.tscn").instance()
	add_child(test)
	# menuNode.raise() # not even sure if this is necessary anymore?

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
			OS.set_window_size(Vector2(data["w"], data["h"]))
			OS.set_window_position(Vector2(data["x"], data["y"]))
			file.close()

func retainWindowPosition():
	var data = {
		x = OS.get_window_position().x,
		y = OS.get_window_position().y,
		w = OS.get_window_size().x,
		h = OS.get_window_size().y
	}
	var file = File.new()
	if file.open("res://window_size.json", File.WRITE) == 0:
		file.store_line(to_json(data))
		file.close()
