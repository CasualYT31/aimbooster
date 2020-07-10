extends Control

# Signals
signal open_main_menu

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
# keeps track of how long the game is running after unpausing
# helps combat a "bug" within the Godot engine (input events queuing up in pause mode)
var targetParentReappearDelay: float = 0.0
# because there doesn't seem to be an easy way to separate hit and miss mouse click collisions
# we have to delay game over checking to ensure that when a hit-and-miss is registered and one life is left
# the game doesn't game over before the hit code portion runs which counteracts the miss
var gameOverCheckingDelay: float = 0.0
# HUD timer variables
var seconds: float = 0.0
var minutes: int = 0
# spawn timing variables
var spawnTimerCounter: float = 0.0 # timer that counts the number of seconds since last spawn
var timeUntilNextSpawn: float = 3.0 # <<<defined value in _ready

# Variables - Difficulty Data
var decreaseDiffucultyDivisor: float = 0.0
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
var activeLifeOfTarget: float = 3.0 # check _ready for value changes <<<< IMPORTANT

# Variables - Game Over State Data
# flag which signifies if the game has ended or not
var gameHasEnded := false

# Functions - Initialisation
func _ready():
	settings = Settings.new()
	statistics = Statistics.new(settings.lives, settings.time)
	lives = settings.lives
	$GameGUI/HUD/ModeLabel.text = "Enemy Mode" if settings.isEnemyMode else "Normal Mode"
	_updateLivesDisplay()
	_determineDifficulty()

# Functions - Game Loop
func _process(delta):
	#delta*=10 # time multiplier
	
	# delay reappearing targets when unpausing so that the input event queue can be cleared out
	if targetParentReappearDelay > 0.0 && entireLengthOfGame - targetParentReappearDelay >= 0.0001:
		$TargetParent.show()
		targetParentReappearDelay = 0.0
	
	_incrementTimeCounters(delta)
	_updateTimeDisplay()
	if _targetSpawnManager():
		_increaseDifficulty()
	if entireLengthOfGame - gameOverCheckingDelay >= 0.1:
		_checkIfGameOver(delta)
		gameOverCheckingDelay = entireLengthOfGame
	
	# if game has ended, increment internal timer anyway so that we can time Game Over! segment
	# (_incrementTimers() prevents incrementing timers if game is over)
	if gameHasEnded:
		entireLengthOfGame += delta
		if entireLengthOfGame >= 3.0:
			$GameGUI/StatisticsMenu.visible = true
	
	# manage sound volumes
	$HitSound.volume_db = settings.getSoundVolumeAsDb()
	$MissSound.volume_db = settings.getSoundVolumeAsDb()

# Functions - Timing
func _incrementTimeCounters(delta):
	if !_isPaused(): # not likely required but include just to be extra safe...
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
		var targetEndPosition: Vector2 = targetStartPosition if _newTargetShouldBeStationary() else _generateNewTargetPosition()
		statistics.increaseMaxScore(targetHealth)
		var newTarget = Target.instance()
		newTarget.initialiseTarget(settings, targetType, targetHealth, targetStartPosition, targetEndPosition, activeLifeOfTarget)
		$TargetParent.add_child(newTarget)
		statistics.aTargetHasBeenSpawned()
		var err = str(newTarget.connect("target_hit", self, "_on_target_hit")) + ","
		err += str(newTarget.connect("target_miss", self, "_on_target_miss")) + ","
		err += str(newTarget.connect("target_destroy", self, "_on_target_destroy"))
		if err != "0,0,0": # remember to update this if more connect() statements are issued!
			OS.alert("There was a serious error when attempting to create a target. Debug info: " + err)
		spawnTimerCounter = 0.0
		return true
	else:
		return false

func _generateNewTargetType():
	var random: int = (randi() % 100) + 1 # random number between 1 and 100
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

func _newTargetShouldBeStationary():
	return false if settings.isEnemyMode else (randi() % 100 + 1) <= chanceOfStationaryTarget

# Functions - Difficulty Management
	# adjust the following variables:
	# target type chance group - ensure they all add up to 100!!
	# target stationary chance
	# decrease both activeLifeOfTarget and timeUntilNextSpawn by a small random amount
func _increaseDifficulty():
	if timeUntilNextSpawn >= 0.2:
		timeUntilNextSpawn -= randf() / int(decreaseDiffucultyDivisor)
	elif timeUntilNextSpawn < 0.2:
		timeUntilNextSpawn = 0.2
	if activeLifeOfTarget >= 0.3:
		activeLifeOfTarget -= randf() / int(decreaseDiffucultyDivisor)
	elif activeLifeOfTarget < 0.3:
		activeLifeOfTarget = 0.3
	
	if chanceOfStationaryTarget >= 10:
		chanceOfStationaryTarget -= randi()%3
	elif activeLifeOfTarget < 10:
		chanceOfStationaryTarget = 10
	
	decreaseDiffucultyDivisor -= int(decreaseDiffucultyDivisor * 0.02)
	
	if chanceOfRedTarget >= chanceOfOrangeTarget:
		chanceOfRedTarget -= 2
		chanceOfOrangeTarget += 2
	elif chanceOfOrangeTarget >= chanceOfYellowTarget:
		chanceOfOrangeTarget -= 2
		chanceOfYellowTarget += 2
	elif chanceOfYellowTarget >= chanceOfGreenTarget:
		chanceOfYellowTarget -= 2
		chanceOfGreenTarget += 2
	elif chanceOfGreenTarget >= chanceOfBlueTarget:
		chanceOfGreenTarget -= 2
		chanceOfBlueTarget += 2
	else:
		chanceOfBlueTarget -= 2
		chanceOfPurpleTarget += 2

func _determineDifficulty():
	var difficultyMultiplier: float = settings.startDifficulty
	
	if difficultyMultiplier == 4:
		difficultyMultiplier = 1
	elif difficultyMultiplier == 3.5:
		difficultyMultiplier = 1.5
	elif difficultyMultiplier == 3.0:
		difficultyMultiplier = 2.0
	elif difficultyMultiplier == 2.0:
		difficultyMultiplier = 3.0
	elif difficultyMultiplier == 1.5:
		difficultyMultiplier = 3.5
	elif difficultyMultiplier == 1.0:
		difficultyMultiplier = 4.0
	decreaseDiffucultyDivisor = 25 * difficultyMultiplier

# Functions - Target Signal Handlers
func _on_target_hit():
	if settings.soundVolume >= 1.0 && !gameHasEnded:
		$MissSound.seek(0.55) # prevents miss sound from playing since a miss is registered if a hit is registered, too :(
		$HitSound.play()
	statistics.increasePlayerScore(1)
	statistics.aHitWasMade()
	# undo "target miss" that registers in _unhandled_input()
	if settings.lives != settings.INFINITE_LIVES:
		lives += 1
	_updateLivesDisplay()

func _on_target_miss():
	if settings.soundVolume >= 1.0 && !gameHasEnded:
		$MissSound.play()
	statistics.aMissWasMade()
	if settings.lives != settings.INFINITE_LIVES:
		lives -= 1
		if lives < 0:
			lives = 0
	_updateLivesDisplay()

func _on_target_destroy():
	statistics.aTargetWasDestroyed()

# Functions - Pausing and Click Handling
# Note: Game is also "paused" if it has ended
func _unhandled_input(event):
	if !_isPaused(): # not likely required but include just to be extra safe...
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_ESCAPE:
				_pause() # user can no longer press Escape to unpause once paused...
		if event is InputEventMouseButton:
			if entireLengthOfGame >= 0.0 && event.is_pressed() && event.button_index == (BUTTON_LEFT if settings.isLeftButtonToShoot else BUTTON_RIGHT):
				statistics.aClickWasMade()
				_on_target_miss()

func _isPaused():
	return get_tree().paused || gameHasEnded

func _pause():
	$TargetParent.hide()
	get_node("GameGUI/PauseMenu").visible = true
	get_tree().paused = true

func _unpause():
	targetParentReappearDelay = entireLengthOfGame # delay reappearing of TargetParent
	get_node("GameGUI/PauseMenu").visible = false
	get_tree().paused = false

# Functions - GUI Updating
func _updateLivesDisplay():
	get_node("GameGUI/HUD/LivesLabel").text = "Lives: " + (str(lives) if lives > 0 || settings.lives != settings.INFINITE_LIVES else "Inf")

func _updateTimeDisplay():
	get_node("GameGUI/HUD/TimeLabel").text = "Time: 00:00"
	if entireLengthOfGame < 0:
		get_node("StartCountdown").text = str(abs(int(entireLengthOfGame)) + 1)
	else:
		if $StartCountdown.text == "1": # not the best way of doing it...
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

func _setupStatisticsMenu():
	$GameGUI/StatisticsMenu/StatisticsContainer/LivesStartedAtValue.text = str(statistics.livesStartedAt) if settings.lives != settings.INFINITE_LIVES else "N/A"
	$GameGUI/StatisticsMenu/StatisticsContainer/LivesEndedAtValue.text = str(statistics.livesEndedAt) if settings.lives != settings.INFINITE_LIVES else "N/A"
	$GameGUI/StatisticsMenu/StatisticsContainer/ScheduledTimeValue.text = str(statistics.scheduledLength) if settings.time != settings.INFINITE_TIME else "N/A"
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalTimeValue.text = str(statistics.actualLength)
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalHitsValue.text = str(statistics.totalHits)
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalMissesValue.text = str(statistics.totalMisses)
	$GameGUI/StatisticsMenu/StatisticsContainer/AccuracyValue.text = str(stepify(statistics.calculateAccuracy(), 0.01)) + "%"
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalClicksValue.text = str(statistics.totalClicks)
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalTargetsDestroyedValue.text = str(statistics.totalTargetsDestroyed)
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalTargetsValue.text = str(statistics.totalTargets)
	$GameGUI/StatisticsMenu/StatisticsContainer/TotalPointsValue.text = str(statistics.totalPoints)
	$GameGUI/StatisticsMenu/StatisticsContainer/MaxPointsValue.text = str(statistics.maximumPoints)
	$GameGUI/StatisticsMenu/StatisticsContainer/PercentageValue.text = str(stepify(statistics.calculatePointPercentage(), 0.01)) + "%"

func _makeAllVisible(flag):
	get_node("GameGUI").visible = flag
	get_node("StartCountdown").visible = flag

# Functions - Game Over Checking
func _checkIfGameOver(delta):
	# condition 1: see _on_EndButton_pressed
	# condition 2: if a time limit is set, and the time is up, end game
	# REMEMBER THAT THE TIME VARIABLE STORED IN SETTINGS IS IN __MINUTES__!
	if settings.time != settings.INFINITE_TIME && entireLengthOfGame > settings.time * 60:
		_endGame("Time's Up!")
	# condition 3: if a lives limit is set, and lives has reached 0, end game
	if settings.lives != settings.INFINITE_LIVES && lives == 0:
		_endGame("Game Over!")

# should be called when the game is over
func _endGame(gameOverText: String):
	if !gameHasEnded:
		gameHasEnded = true
		$StartCountdown.text = gameOverText
		$TargetParent.visible = false
		$GameGUI/HUD.visible = false
		statistics.finishGame(lives, entireLengthOfGame)
		_setupStatisticsMenu()
		entireLengthOfGame = 0.0 # reset internal timer so that game over! segment can be timed from 0.0

# Functions - GUI Signal Handlers
func _on_ContinueButton_pressed():
	_unpause()

func _on_SettingsButton_pressed():
	_makeAllVisible(false)
	settingsMenu = load("res://scenes/SettingsMenu.tscn").instance()
	settingsMenu.limit = true
	settingsMenu.connect("open_previous_menu", self, "_on_SettingsMenu_go_back_to_game_menu")
	add_child(settingsMenu)

func _on_SettingsMenu_go_back_to_game_menu():
	call_deferred("_removeSettingsMenu")

func _removeSettingsMenu():
	remove_child(settingsMenu)
	settingsMenu.queue_free()
	# reload settings here
	# we must ensure that certain settings remain the same,
	# so temporarily store them now then apply them to the new settings object
	var currentEnemyModeSetting = settings.isEnemyMode
	var currentLivesSetting = settings.lives
	var currentTimeSetting = settings.time
	var currentDifficultSetting = settings.startDifficulty
	settings = Settings.new()
	settings.isEnemyMode = currentEnemyModeSetting
	settings.lives = currentLivesSetting
	settings.time = currentTimeSetting
	settings.startDifficulty = currentDifficultSetting
	_makeAllVisible(true)

func _on_EndButton_pressed():
	_endGame("Game Ended")
	_unpause()

func _on_QuitButton_pressed():
	get_tree().paused = false
	emit_signal("open_main_menu")
