extends Control

# Signals
signal toggle_pause # signal emitted when the pause state is toggled

# Classes
var Statistics = preload("res://scripts/Statistics.gd")
var Settings = preload("res://scripts/Settings.gd")
var Target = preload("res://scenes/Target.tscn")

# Complex Objects
var statistics
var settings
var settingsMenu

# Variables - Live User Data
# tracks the number of lives the player is currently at
var lives: int = 0

# Variables - Timing Data
# keeps track of the length of the game, not including pausing
var entireLengthOfGame: float = -3.0
# HUD timer variables
var seconds: float = 0.0
var minutes: int = 0
# spawn timing variables
var spawnTimerCounter: float = 0.0 # timer that counts the number of seconds since last spawn
var timeUntilNextSpawn: float = 1.0 # defines the length of time that must elapse until next spawn

# Variables - Difficulty Data
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
var activeLifeOfTarget: float = timeUntilNextSpawn

# Variables - Game Over State Data
# flag which signifies if the game has ended or not
var gameHasEnded := false

# Functions - Initialisation
func _ready():
	settings = Settings.new()
	statistics = Statistics.new(settings.lives, settings.time)
	lives = settings.lives
	_updateLivesDisplay()

# Functions - Game Loop
func _process(delta):
	_incrementTimeCounters(delta)
	_updateTimeDisplay()
	if _targetSpawnManager():
		_increaseDifficulty()
	_checkIfGameOver()

# Functions - Timing
func _incrementTimeCounters(delta):
	if !_isPaused():
		entireLengthOfGame += delta
		if entireLengthOfGame >= 0:
			seconds += delta
			spawnTimerCounter += delta

# Functions - Target Management
# returns TRUE if a target was spawned, FALSE if not
func _targetSpawnManager():
	if spawnTimerCounter >= timeUntilNextSpawn:
		# spawn a target here!
		# we should design our code so that we don't have to explicitly store references to targets
		var targetType: int = _generateNewTargetType()
		var targetHealth: int = _generateNewTargetHealth(targetType)
		var targetStartPosition: Vector2 = _generateNewTargetPosition()
		var targetEndPosition: Vector2 = _generateNewTargetPosition() if _newTargetShouldBeAnimate() else targetStartPosition
		var newTarget = Target.instance()
		newTarget.initialiseTarget(targetType, targetHealth, targetStartPosition, targetEndPosition, activeLifeOfTarget)
		get_node("TargetParent").add_child(newTarget)
		var err1 = connect("toggle_pause", newTarget, "_on_Game_TogglePause")
		var err2 = newTarget.connect("target_hit", self, "_on_target_hit")
		var err3 = newTarget.connect("target_miss", self, "_on_target_miss")
		if err1 != OK || err2 != OK || err3 != OK:
			OS.alert("There was a serious error when attempting to create a target. Debug info: " + str(err1) + ", " + str(err2) + ", " + str(err3))
		spawnTimerCounter = 0.0
		return true
	else:
		return false

func _generateNewTargetType():
	var random: int = randi() % 100 + 1 # random number between 1 and 100
	if random <= chanceOfRedTarget:
		return Global.TargetType.RED
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget:
		return Global.TargetType.ORANGE
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget + chanceOfYellowTarget:
		return Global.TargetType.YELLOW
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget + chanceOfYellowTarget + chanceOfGreenTarget:
		return Global.TargetType.GREEN
	elif random <= chanceOfRedTarget + chanceOfOrangeTarget + chanceOfYellowTarget + chanceOfGreenTarget + chanceOfBlueTarget:
		return Global.TargetType.BLUE
	else:
		return Global.TargetType.PURPLE

func _generateNewTargetHealth(targetType: int):
	if settings.isEnemyMode:
		match targetType:
			Global.TargetType.RED, Global.TargetType.ORANGE:
				return 2
			Global.TargetType.YELLOW, Global.TargetType.GREEN:
				return 3
			Global.TargetType.BLUE, Global.TargetType.PURPLE:
				return 4
	else:
		return 1

func _generateNewTargetPosition():
	return Vector2(float(randi() % int(OS.get_window_size().x)), float(randi() % int(OS.get_window_size().y)))

func _newTargetShouldBeAnimate():
	return (randi() % 100 + 1) <= chanceOfStationaryTarget

# Functions - Difficulty Management
func _increaseDifficulty():
	# adjust the following variables:
	# target type chance group - ensure they all add up to 100!!
	# target stationary chance
	# decrease both activeLifeOfTarget and timeUntilNextSpawn by a small random amount
	pass

# Functions - Target Signal Handlers
func _on_target_hit():
	statistics.increasePlayerScore(1)

func _on_target_miss():
	lives -= 1
	if lives < 0:
		lives = 0
	_updateLivesDisplay()

# Functions - Pausing
# Note: Game is also "paused" if it has ended
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if _isPaused():
				_unpause()
			else:
				_pause()

func _isPaused():
	return get_node("GameGUI/PauseMenu").visible || gameHasEnded

func _pause():
	get_node("GameGUI/PauseMenu").visible = true
	emit_signal("toggle_pause")

func _unpause():
	get_node("GameGUI/PauseMenu").visible = false
	emit_signal("toggle_pause")

# Functions - GUI Updating
func _updateLivesDisplay():
	get_node("GameGUI/HUD/LivesLabel").text = "Lives: " + (str(lives) if lives > 0 || settings.lives != settings.INFINITE_LIVES else "Inf")

func _updateTimeDisplay():
	get_node("GameGUI/HUD/TimeLabel").text = "Time: 00:00"
	if entireLengthOfGame < 0:
		get_node("StartCountdown").text = str(abs(int(entireLengthOfGame)))
	else:
		get_node("StartCountdown").text = ""
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

func _makeAllVisible(flag):
	get_node("GameGUI").visible = flag
	get_node("StartCountdown").visible = flag
	get_node("TargetParent").visible = flag

# Functions - Game Over Checking
func _checkIfGameOver():
	# condition 2: if a time limit is set, and the time is up, end game
	# REMEMBER THAT THE TIME VARIABLE STORED IN SETTINGS IS IN __MINUTES__!
	if settings.time != settings.INFINITE_TIME && entireLengthOfGame > settings.time * 60:
		_endGame()
	# condition 3: if a lives limit is set, and lives has reached 0, end game
	if settings.lives != settings.INFINITE_LIVES && lives == 0:
		_endGame()

# should be called when the game is over
func _endGame():
	gameHasEnded = true

# Functions - GUI Signal Handlers
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

func _on_EndButton_pressed():
	_endGame()

func _on_QuitButton_pressed():
	Global.currentMenu = Global.Menu.MAIN
