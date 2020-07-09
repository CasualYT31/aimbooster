extends Node

export var livesStartedAt: int setget , getLivesStartedAt
export var livesEndedAt: int setget , getLivesEndedAt
export var scheduledLength: int setget , getScheduledLength
export var actualLength: int setget , getActualLength
export var totalHits: int setget , getTotalHits
export var totalMisses: int setget , getTotalMisses
export var totalClicks: int setget , getTotalClicks
export var totalPoints: int setget , getTotalPoints
export var maximumPoints: int setget , getMaximumPoints
export var totalTargetsDestroyed: int setget , getTotalTargetsDestroyed
export var totalTargets: int setget , getTotalTargets

# instantiates the class, ready for live tracking of stats
# length is in MINUTES: just use settings value directly here
func _init(initLives: int, initLength: int):
	livesStartedAt = initLives
	scheduledLength = initLength

# supposed to be called once the game is over
# you provide the lives the player ended up with,
# as well as the time (OS.get_unix_time() value) it took to complete the game
# most other stats are calculated via interactions with the class
func finishGame(finalLives: int, finalLength: int):
	livesEndedAt = finalLives
	actualLength = finalLength

# supposed to be called when a click in-game is made
func aClickWasMade():
	totalClicks += 1

# supposed to be called when a hit is made
func aHitWasMade():
	totalHits += 1
	# disregard registered miss
	totalMisses -= 1

# supposed to be called when a miss is registered in any way
func aMissWasMade():
	totalMisses += 1

# supposed to be called when a target's health reaches 0
func aTargetWasDestroyed():
	totalTargetsDestroyed += 1

# supposed to be called when a target has been spawned
func aTargetHasBeenSpawned():
	totalTargets += 1

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
# warning-ignore:integer_division
	var minutes = actualLength / 60
	var seconds = actualLength % 60
	return "%02d : %02d" % [minutes, seconds]

func getTotalHits():
	return totalHits

func getTotalMisses():
	return totalMisses

func getTotalClicks():
	return totalClicks

func getTotalPoints():
	return totalPoints

func getMaximumPoints():
	return maximumPoints

func getTotalTargetsDestroyed():
	return totalTargetsDestroyed

func getTotalTargets():
	return totalTargets

func calculateAccuracy():
	if self.totalMisses + self.totalHits == 0:
		return 0.0
	return float(self.totalHits) / float(self.totalMisses + self.totalHits) * 100.0

func calculatePointPercentage():
	if self.maximumPoints == 0:
		return 0.0
	return float(self.totalPoints) / float(self.maximumPoints) * 100.0
