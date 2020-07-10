extends Control

signal open_main_menu

func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)

func _on_ReturnButton_pressed():
	emit_signal("open_main_menu")
