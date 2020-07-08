extends Area2D

# these signals are emitted when the target has been either hit or missed
# in both cases, Target.gd deals with the actual removal of the target object
# so other tasks that need to be carried out by Game.gd should be done there,
# using these signals to identify when they need to be carried out
signal target_hit
# warning-ignore:unused_signal
signal target_miss

var leftToShoot: bool
var buttonToShoot
var internalTimer: float
var inPausedState: bool = false

var Settings = preload("res://scripts/Settings.gd")

export var type: int setget , getType
export var startPosition: Vector2 setget , getStartPosition
export var endPosition: Vector2 setget , getEndPosition
# the number of seconds the target remains on the screen for:
export var activeDuration: float setget , getActiveDuration
export var targetHealth: int setget , getHealth

func _ready():
	pass

func getType():
	return type

func getStartPosition():
	return startPosition

func getEndPosition():
	return endPosition

func getActiveDuration():
	return activeDuration

func getHealth():
	return targetHealth

# call this method to "hit" the target
# if the health is at or below 0, it will remove itself
func hit():
	targetHealth -= 1
	if targetHealth <= 0:
		get_parent().remove_child(self)
		emit_signal("target_hit")

# constructor
func initialiseTarget(targetType: int, health: int, startPos: Vector2, endPos: Vector2, howLongToKeepOnScreen: float):
	match targetType:
		Global.TargetType.RED:
			modulate = ColorN("red", 1.0)
			# no scaling applied to the biggest size
		Global.TargetType.ORANGE:
			modulate = ColorN("orange", 1.0)
			scale = Vector2(0.9, 0.9)
		Global.TargetType.YELLOW:
			modulate = ColorN("yellow", 1.0)
			scale = Vector2(0.8, 0.8)
		Global.TargetType.GREEN:
			modulate = ColorN("green", 1.0)
			scale = Vector2(0.7, 0.7)
		Global.TargetType.BLUE:
			modulate = ColorN("blue", 1.0)
			scale = Vector2(0.6, 0.6)
		Global.TargetType.PURPLE:
			modulate = ColorN("purple", 1.0)
			scale = Vector2(0.5, 0.5)
		_:
			OS.alert("Invalid target type!")
	targetHealth = health
	endPosition = endPos
	activeDuration = howLongToKeepOnScreen
	position = startPos

func _process(delta):
	if !inPausedState:
		internalTimer += delta
	if internalTimer >= activeDuration:
		get_parent().remove_child(self)
		emit_signal("target_miss")

func _on_Game_TogglePause():
	inPausedState = !inPausedState


func _on_Area2D_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Object hit")
		else:
			print("Object released")
