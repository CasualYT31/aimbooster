extends Control

signal open_main_menu

func _on_RichTextLabel_meta_clicked(meta):
	var code = OS.shell_open(meta)
	if code != 0:
		OS.alert("Failed to open link. Error code: " + str(code))

func _on_ReturnButton_pressed():
	emit_signal("open_main_menu")
