extends Control

var Statistics = preload("res://scripts/Statistics.gd")
var Settings = preload("res://scripts/Settings.gd")
var Target = preload("res://scenes/Target.tscn")

var statistics
var settings
var settingsMenu

var lives: int = 0

# keeps track of the length of the game, not including pausing
var seconds: float = 0.0
var minutes: int = 0

# spawning timing variables
var spawnTimerCounter: float = 0.0
var timeUntilNextSpawn: float = 3.25
# variables that define difficulty
# chance variables will be a %age from 0-100
# they represent a chance of a property being a certain way
# i.e. "50% chance of target being red,
#       45% chance of it being orange,
#       5% chance of it being yellow,
#       0% chance of it being green, etc."
# each group of chance variables should add up to 100
# this is the target type group
var chanceOfRedTarget: int = 100
var chanceOfOrangeTarget: int = 0
var chanceOfYellowTarget: int = 0
var chanceOfGreenTarget: int = 0
var chanceOfBlueTarget: int = 0
var chanceOfPurpleTarget: int = 0
# chance of a target being stationary
# if not stationary, position will be totally random yet confined within the screen
var chanceOfStationaryTarget: int = 100
# how long the target should remain on screen for
# this value is to be gradually made smaller when adjusting difficulty
var activeLifeOfTarget: float = 3.0

func _isPaused():
	return get_node("GameGUI/PauseMenu").visible

func _pause():
	get_node("GameGUI/PauseMenu").visible = true

func _unpause():
	get_node("GameGUI/PauseMenu").visible = false

func _updateLivesDisplay():
	get_node("GameGUI/HUD/LivesLabel").text = "Lives: " + (str(lives) if lives > 0 else "Inf")

func _updateTimeDisplay():
	var strSeconds = str(int(seconds))
	if int(seconds) == 60:
		seconds = 0.0
		minutes += 1
	var strMinutes = str(minutes)
	if len(strMinutes) == 1:
		strMinutes = "0" + strMinutes
	if len(strSeconds) == 1:
		strSeconds = "0" + strSeconds
	get_node("GameGUI/HUD/TimeLabel").text = "Time: " + strMinutes + ":" + strSeconds

# Called when the node enters the scene tree for the first time.
func _ready():
	settings = Settings.new()
	statistics = Statistics.new(settings.lives, settings.time)
	lives = settings.lives
	_updateLivesDisplay()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if _isPaused():
				_unpause()
			else:
				_pause()

func _makeAllVisible(flag):
	get_node("GameGUI").visible = flag

func _process(delta):
	_incrementTimeCounters(delta)
	_updateTimeDisplay()
	_targetSpawnManager()

func _targetSpawnManager():
	if spawnTimerCounter >= timeUntilNextSpawn:
		# spawn a target here!
		# we should design our code so that we don't have to explicitly store references to targets
		var targetType: int = _generateNewTargetType()
		var targetHealth: int = _generateNewTargetHealth(targetType)
		var targetStartPosition: Vector2 = _generateNewTargetPosition()
		var targetEndPosition: Vector2
		if _newTargetShouldBeAnimate():
			targetEndPosition = targetStartPosition
		else:
			targetEndPosition = _generateNewTargetPosition()
		var newTarget = Target.new(targetType, targetHealth, targetStartPosition, targetEndPosition, activeLifeOfTarget)
		get_node("TargetParent").add_child(newTarget)
		
		# probably connect a signal here which is sent by Target when it is killed
		spawnTimerCounter = 0.0
		_increaseDifficulty()

func _increaseDifficulty():
	# adjust the following variables:
	# target type chance group - ensure they all add up to 100!!
	# target stationary chance
	# decrease both activeLifeOfTarget and timeUntilNextSpawn by a small random amount
	pass

func _generateNewTargetType():
	var random: int = randi() % 100 + 1 # random number between 1 and 100
	if random <= chanceOfRedTarget:
		return Target.Type.RED
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget:
		return Target.Type.ORANGE
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget + chanceOfYellowTarget:
		return Target.Type.YELLOW
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget + chanceOfYellowTarget + chanceOfGreenTarget:
		return Target.Type.GREEN
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget + chanceOfYellowTarget + chanceOfGreenTarget + chanceOfBlueTarget:
		return Target.Type.BLUE
	else:
		return Target.Type.PURPLE

func _generateNewTargetHealth(targetType: int):
	if settings.isEnemyMode:
		match targetType:
			Target.Type.RED, Target.Type.ORANGE:
				return 2
			Target.Type.YELLOW, Target.Type.GREEN:
				return 3
			Target.Type.BLUE, Target.Type.PURPLE:
				return 4
	else:
		return 1

func _generateNewTargetPosition():
	return Vector2(randi() % int(OS.get_window_size().x), randi() % int(OS.get_window_size().y))

func _newTargetShouldBeAnimate():
	return (randi() % 100 + 1) <= chanceOfStationaryTarget

func _incrementTimeCounters(delta: float):
	if !_isPaused():
		seconds += delta
		spawnTimerCounter += delta

func _on_ContinueButton_pressed():
	_unpause()

func _on_SettingsButton_pressed():
	_makeAllVisible(false)
	settingsMenu = load("res://scenes/SettingsMenu.tscn").instance()
	settingsMenu.connect("go_back_to_game_menu", self, "_on_SettingsMenu_go_back_to_game_menu")
	add_child(settingsMenu)

func _on_SettingsMenu_go_back_to_game_menu():
	call_deferred("_removeSettingsMenu")

func _removeSettingsMenu():
	remove_child(settingsMenu)
	settingsMenu.free()
	# reload settings here
	# we must ensure that certain settings remain the same,
	# so temporarily store them now then apply them to the new settings object
	var currentEnemyModeSetting = settings.isEnemyMode
	var currentLivesSetting = settings.lives
	var currentTimeSetting = settings.time
	settings = Settings.new()
	settings.isEnemyMode = currentEnemyModeSetting
	settings.lives = currentLivesSetting
	settings.time = currentTimeSetting
	_makeAllVisible(true)

func _on_QuitButton_pressed():
	Global.currentMenu = Global.Menu.MAIN
