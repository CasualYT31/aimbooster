extends Control

signal open_previous_menu

export var limit := false

var Settings = preload("res://scripts/Settings.gd")

var settings = Settings.new()

var firstFullscreenPress := true
var firstFPSCounterPress := true

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
	get_node("MarginContainer/VBoxContainer/GridContainer/FPSCounterButton").pressed = settings.fpsCounter
	firstFPSCounterPress = false
	get_node("MarginContainer/VBoxContainer/GridContainer/StartDifficulty").value = settings.startDifficulty
	_updateStartDifficultyLabel()
	if (limit):
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeNormal").disabled = true
		get_node("MarginContainer/VBoxContainer/GridContainer/ModeContainer/ModeEnemy").disabled = true
		get_node("MarginContainer/VBoxContainer/GridContainer/StartDifficulty").editable = false
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

func _updateStartDifficultyLabel():
	var val : String
	if settings.startDifficulty == 4.0:
		val = "Hard"
	elif settings.startDifficulty == 3.0:
		val = "Medium"
	elif settings.startDifficulty == 2.0:
		val = "Easy"
	elif settings.startDifficulty == 1.0:
		val = "Baby's First Game"
	else:
		val = str(settings.startDifficulty)
	get_node("MarginContainer/VBoxContainer/GridContainer/StartDifficultyValueLabel").text = val

func _on_BackButton_pressed():
	emit_signal("open_previous_menu")

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
		# retain window position before switching
		# (automatically doesn't do so if switching from fullscreen)
		Global.retainWindowPosition()
		settings.fullscreen = !settings.fullscreen
		settings.save()

func _on_FPSCounterButton_toggled(_button_pressed):
	if !firstFPSCounterPress:
		settings.fpsCounter = !settings.fpsCounter
		settings.save()

func _on_StartDifficulty_value_changed(newVal):
	settings.startDifficulty = newVal
	_updateStartDifficultyLabel()
	settings.save()
