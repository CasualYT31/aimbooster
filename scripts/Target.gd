extends Sprite

enum Type {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE}

var type: int setget , getType

func getType():
	return type

func _init(targetType: int, health: int, x: float, y: float):
	match targetType:
		Type.RED:
			modulate = ColorN("red", 1.0)
		Type.ORANGE:
			modulate = ColorN("orange", 1.0)
			scale = Vector2(0.9, 0.9)
		Type.YELLOW:
			modulate = ColorN("yellow", 1.0)
			scale = Vector2(0.8, 0.8)
		Type.GREEN:
			modulate = ColorN("green", 1.0)
			scale = Vector2(0.7, 0.7)
		Type.BLUE:
			modulate = ColorN("blue", 1.0)
			scale = Vector2(0.6, 0.6)
		Type.PURPLE:
			modulate = ColorN("purple", 1.0)
			scale = Vector2(0.5, 0.5)
		_:
			OS.alert("Invalid target type!")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	pass

# on click within defined area, it will print "Clicked"
#func _on_Area2D_input_event(viewport, event, shape_idx):
	 #if event.type == InputEvent.MOUSE_BUTTON \
	#and event.button_index == BUTTON_LEFT \
	#and event.pressed:
		#print("Clicked")
