extends Control

signal open_main_menu

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)

func _on_ReturnButton_pressed():
	emit_signal("open_main_menu")
