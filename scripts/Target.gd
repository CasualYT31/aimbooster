extends Area2D

var Settings = preload("res://scripts/Settings.gd")
var leftToShoot: bool
var buttonToShoot

enum Type {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE}

var type: int setget , getType

func _ready():
	var settings = Settings.new()
	settings.isLeftButtonToShoot()
	
	if settings.isLeftButtonToShoot == true:
		buttonToShoot = BUTTON_LEFT
	else:
		buttonToShoot = BUTTON_RIGHT

func getType():
	return type
	
	
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _init(targetType: int, health: int, x: float, y: float):
	match targetType:
		Type.RED:
			modulate = ColorN("red", 1.0)
# warning-ignore:unused_variable
			var targetHealth: int = health
		Type.ORANGE:
			modulate = ColorN("orange", 1.0)
			scale = Vector2(0.9, 0.9)
# warning-ignore:unused_variable
			var targetHealth: int = health
		Type.YELLOW:
			modulate = ColorN("yellow", 1.0)
			scale = Vector2(0.8, 0.8)
# warning-ignore:unused_variable
			var targetHealth: int = health
		Type.GREEN:
			modulate = ColorN("green", 1.0)
			scale = Vector2(0.7, 0.7)
# warning-ignore:unused_variable
			var targetHealth: int = health
		Type.BLUE:
			modulate = ColorN("blue", 1.0)
			scale = Vector2(0.6, 0.6)
# warning-ignore:unused_variable
			var targetHealth: int = health
		Type.PURPLE:
			modulate = ColorN("purple", 1.0)
			scale = Vector2(0.5, 0.5)
# warning-ignore:unused_variable
			var targetHealth: int = health
		_:
			OS.alert("Invalid target type!")
