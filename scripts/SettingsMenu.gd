extends Control

signal go_back_to_game_menu

var Settings = preload("res://scripts/Settings.gd")

var settings = Settings.new()

var firstFullscreenPress := true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundVolume").value = settings.soundVolume
	_updateSoundLabel()
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicVolume").value = settings.musicVolume
	_updateMusicLabel()
	_updateShootButtons()
	_updateModeButtons()
	get_node("MarginContainer/VBoxContainer/GridContainer/Lives").value = settings.lives
	_updateLivesLabel()
	get_node("MarginContainer/VBoxContainer/GridContainer/Time").value = settings.time
	_updateTimeLabel()
	get_node("MarginContainer/VBoxContainer/GridContainer/Fullscreen").pressed = settings.fullscreen
	firstFullscreenPress = false
	# if coming from the game menu, we need to DISABLE certain setting controls
	# I've used CURRENT menu, not PREVIOUS menu, because I realised that if we
	# switched to the settings menu from the games menu using Global.setCurrentMenu(),
	# then the state of the game would be lost, which we don't want
	# instead we can instance this settings menu from the games menu and retain game state
	# this means that Global "thinks" we are still in the game menu, so currentMenu is used
	# please also see _on_BackButton_pressed()
	if (Global.currentMenu == Global.Menu.GAME):
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").disabled = true
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").disabled = true
		get_node("MarginContainer/VBoxContainer/GridContainer/Lives").editable = false
		get_node("MarginContainer/VBoxContainer/GridContainer/Time").editable = false

func _updateSoundLabel():
	get_node("MarginContainer/VBoxContainer/GridContainer/SoundValueLabel").text = str(settings.soundVolume)

func _updateMusicLabel():
	get_node("MarginContainer/VBoxContainer/GridContainer/MusicValueLabel").text = str(settings.musicVolume)

func _updateShootButtons():
	if settings.isLeftButtonToShoot:
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootLeft").set("custom_colors/font_color", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootLeft").set("custom_colors/font_color_hover", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootLeft").set("custom_colors/font_color_pressed", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootRight").set("custom_colors/font_color", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootRight").set("custom_colors/font_color_hover", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootRight").set("custom_colors/font_color_pressed", null)
	else:
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootLeft").set("custom_colors/font_color", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootLeft").set("custom_colors/font_color_hover", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootLeft").set("custom_colors/font_color_pressed", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootRight").set("custom_colors/font_color", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootRight").set("custom_colors/font_color_hover", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ShootContainer/ShootRight").set("custom_colors/font_color_pressed", Color(0,0,0))

func _updateModeButtons():
	if settings.isEnemyMode:
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color_hover", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color_disabled", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color_pressed", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color_hover", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color_disabled", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color_pressed", Color(0,0,0))
	else:
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color_hover", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color_disabled", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").set("custom_colors/font_color_pressed", Color(0,0,0))
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color_hover", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color_disabled", null)
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").set("custom_colors/font_color_pressed", null)

func _updateLivesLabel():
	if (settings.lives == settings.INFINITE_LIVES):
		get_node("MarginContainer/VBoxContainer/GridContainer/LivesValueLabel").text = "Inf"
	else:
		get_node("MarginContainer/VBoxContainer/GridContainer/LivesValueLabel").text = str(settings.lives) + (" life" if settings.lives == 1 else " lives")

func _updateTimeLabel():
	if (settings.time == settings.INFINITE_TIME):
		get_node("MarginContainer/VBoxContainer/GridContainer/TimeValueLabel").text = "Inf"
	else:
		get_node("MarginContainer/VBoxContainer/GridContainer/TimeValueLabel").text = str(settings.time) + (" min" if settings.time == 1 else " mins")

func _on_BackButton_pressed():
	if (Global.currentMenu == Global.Menu.GAME):
		# send some signal or something which the game scene listens for:
		# sending this signal should signify that the instanced settings menu
		# is to be destroyed
		# please also see _ready()
		emit_signal("go_back_to_game_menu")
	else:
		Global.currentMenu = Global.previousMenu

func _on_SoundVolume_value_changed(value):
	settings.soundVolume = value
	_updateSoundLabel()
	settings.save()

func _on_MusicVolume_value_changed(value):
	settings.musicVolume = value
	_updateMusicLabel()
	settings.save()

func _on_ShootLeft_pressed():
	settings.isLeftButtonToShoot = true
	_updateShootButtons()
	settings.save()

func _on_ShootRight_pressed():
	settings.isLeftButtonToShoot = false
	_updateShootButtons()
	settings.save()

func _on_ModeNormal_pressed():
	settings.isEnemyMode = false
	_updateModeButtons()
	settings.save()

func _on_ModeEnemy_pressed():
	settings.isEnemyMode = true
	_updateModeButtons()
	settings.save()

func _on_Lives_value_changed(value):
	settings.lives = value
	_updateLivesLabel()
	settings.save()

func _on_Time_value_changed(value):
	settings.time = value
	_updateTimeLabel()
	settings.save()

func _on_Fullscreen_toggled(_button_pressed):
	if !firstFullscreenPress:
		settings.fullscreen = !settings.fullscreen
		settings.save()
