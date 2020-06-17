extends Control

func _on_StartGame_pressed():
	Global.currentMenu = Global.Menu.GAME

func _on_Settings_pressed():
	Global.currentMenu = Global.Menu.SETTINGS

func _on_EndGame_pressed():
	_retainWindowPosition()
	get_tree().quit()

# I don't think this works across all scripts...
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		_on_EndGame_pressed()

func _retainWindowPosition():
	var data = {
		x = OS.get_window_size().x,
		y = OS.get_window_size().y
	}
	var file = File.new()
	if file.open("res://window_size.json", File.WRITE) == 0:
		file.store_line(to_json(data))
		file.close()
