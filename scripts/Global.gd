extends Node

enum Menu {NONE, MAIN, SETTINGS, GAME, STATISTICS}

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
	menuNode.raise()
