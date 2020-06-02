extends Settings

enum Menu {NONE, MAIN, SETTINGS, GAME, STATISTICS}

var currentMenu: int = Menu.NONE
var previousMenu: int = Menu.NONE
var menuNode = null

func _ready():
	openMainMenu()

func openMainMenu():
	switchToMenu(Menu.MAIN)

func openSettingsMenu():
	switchToMenu(Menu.SETTINGS)

func openGame():
	switchToMenu(Menu.GAME)

func openStatisticsMenu():
	switchToMenu(Menu.STATISTICS)

func switchToMenu(id):
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
	previousMenu = currentMenu
	currentMenu = id
	# usually, we'd use queue_free()
	# however, I need to be sure that the previous menu has been freed before allocating the new one
	# is using free() over queue_free() here the right thing to do?
	if (menuNode != null):
		remove_child(menuNode)
		menuNode.free()
	menuNode = load(path).instance()
	add_child(menuNode)
