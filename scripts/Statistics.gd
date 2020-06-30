extends Node

export var livesStartedAt: int setget , getLivesStartedAt
export var livesEndedAt: int setget , getLivesEndedAt
export var scheduledLength: int setget , getScheduledLength
export var actualLength: int setget , getActualLength
export var totalHits: int setget , getTotalHits
export var totalClicks: int setget , getTotalClicks
export var totalPoints: int setget , getTotalPoints
export var maximumPoints: int setget , getMaximumPoints

var timeStart = 0

# instantiates the class, ready for live tracking of stats
# length is in MINUTES: just use settings value directly here
func _init(initLives: int, initLength: int):
	livesStartedAt = initLives
	scheduledLength = initLength
	timeStart = OS.get_unix_time()

# supposed to be called once the game is over
# you provide the lives the player ended up with,
# as well as the time (OS.get_unix_time() value) it took to complete the game
# most other stats are calculated via interactions with the class
func finishGame(finalLives: int, finalLength: int):
	livesEndedAt = finalLives
	actualLength = finalLength

# supposed to be called when a click in-game is made
# the game calculates whether it was a hit or not,
# then informs the statistics object of this
func aClickWasMade(wasAHit: bool):
	totalClicks += 1
	if wasAHit:
		totalHits += 1

# supposed to be called every time a target is created
# this keeps track of the max number of points that a player could earn in this
# specific game
func increaseMaxScore(byValue: int):
	maximumPoints += byValue

# supposed to be called every time a target is hit
# its point value should be given to this method
func increasePlayerScore(byValue: int):
	totalPoints += byValue

func getLivesStartedAt():
	return livesStartedAt

func getLivesEndedAt():
	return livesEndedAt

func getScheduledLength():
	return "%02d : 00" % [scheduledLength]

# thanks to volzhs:
# https://godotengine.org/qa/3641/how-display-elapsed-time-in-game?show=3642#a3642
func getActualLength():
	var minutes = actualLength / 60
	var seconds = actualLength % 60
	return "%02d : %02d" % [minutes, seconds]

func getTotalHits():
	return totalHits

func getTotalClicks():
	return totalClicks

func getTotalPoints():
	return totalPoints

func getMaximumPoints():
	return maximumPoints

func calculateAccuracy():
	return self.totalHits / self.totalClicks

func calculatePointPercentage():
	return self.totalPoints / self.maximumPoints
