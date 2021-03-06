extends Reference

const INFINITE_LIVES: int = 0
const INFINITE_TIME: int = 0
const SETTINGS_FILE_PATH: String = "res://settings.json"

export var soundVolume: float = 50.0 setget setSoundVolume, getSoundVolume
export var musicVolume: float = 50.0 setget setMusicVolume, getMusicVolume
export var isLeftButtonToShoot: bool = true setget setShootButton, getShootButton
export var isEnemyMode: bool = false setget setEnemyMode, getEnemyMode
export var lives: int = 3 setget setLives, getLives
export var time: int = INFINITE_TIME setget setTime, getTime
export var fullscreen: bool = OS.window_fullscreen setget setFullscreen, getFullscreen
export var fpsCounter: bool = false setget setFPSVisible, getFPSVisible
export var startDifficulty: float = 2.0 setget setStartDifficulty, getStartDifficulty
export var errorCount := 0 setget , getErrorCount

# constructor: loads settings file and updates variables
func _init():
	read()

func read():
	var file = File.new()
	if !file.file_exists(SETTINGS_FILE_PATH):
		OS.alert("Settings file does not yet exist: reverting to defaults and saving...")
		errorCount += 1
		save()
	else:
		if file.open(SETTINGS_FILE_PATH, File.READ) != 0:
			OS.alert("Error opening settings file: reverting to defaults...")
			errorCount += 1
			save()
		else:
			var data = parse_json(file.get_line())
			# using self here will call the setget methods
			if (data.has("sound")):
				self.soundVolume = float(data["sound"])
			if (data.has("music")):
				self.musicVolume = float(data["music"])
			if (data.has("lefttoshoot")):
				self.isLeftButtonToShoot = bool(data["lefttoshoot"])
			if (data.has("enemymode")):
				self.isEnemyMode = bool(data["enemymode"])
			if (data.has("lives")):
				self.lives = int(data["lives"])
			if (data.has("time")):
				self.time = int(data["time"])
			if (data.has("fullscreen")):
				self.fullscreen = bool(data["fullscreen"])
			if (data.has("fpscounter")):
				self.fpsCounter = bool(data["fpscounter"])
			if (data.has("startdifficulty")):
				self.startDifficulty = int(data["startdifficulty"])
			file.close()

# saves settings to file
func save():
	var data = {
		sound = self.soundVolume,
		music = self.musicVolume,
		lefttoshoot = self.isLeftButtonToShoot,
		enemymode = self.isEnemyMode,
		lives = self.lives,
		time = self.time,
		fullscreen = self.fullscreen,
		fpscounter = self.fpsCounter,
		startdifficulty = self.startDifficulty
	}
	var file = File.new()
	if file.open(SETTINGS_FILE_PATH, File.WRITE) != 0:
		OS.alert("Error writing settings file")
		errorCount += 1
	else:
		file.store_line(to_json(data))
		file.close()

func setSoundVolume(newval):
	if (newval > 100.0):
		newval = 100.0
	elif (newval < 0.0):
		newval = 0.0
	soundVolume = newval

func getSoundVolume():
	return soundVolume

func getSoundVolumeAsDb():
	return -40.0 + soundVolume / 2

func setMusicVolume(newval):
	if (newval > 100.0):
		newval = 100.0
	elif (newval < 0.0):
		newval = 0.0
	musicVolume = newval

func getMusicVolume():
	return musicVolume

func getMusicVolumeAsDb():
	return -50.0 + musicVolume / 2

func setShootButton(newval):
	isLeftButtonToShoot = newval

func getShootButton():
	return isLeftButtonToShoot

func setEnemyMode(newval):
	isEnemyMode = newval

func getEnemyMode():
	return isEnemyMode

func setLives(newval):
	if (newval < 0):
		newval = 0
	lives = newval

func getLives():
	return lives

func setTime(newval):
	if (newval < 0):
		newval = 0
	time = newval

func getTime():
	return time

func setFullscreen(newval):
	fullscreen = newval
	OS.window_fullscreen = fullscreen

func getFullscreen():
	return fullscreen

func setFPSVisible(newval):
	fpsCounter = newval

func getFPSVisible():
	return fpsCounter

func setStartDifficulty(newval):
	if (newval < 1.0):
		newval = 1.0
	elif (newval > 4.0):
		newval = 4.0
	startDifficulty = newval

func getStartDifficulty():
	return startDifficulty

func getErrorCount():
	return errorCount
