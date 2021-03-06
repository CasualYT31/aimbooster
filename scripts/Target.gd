extends Path2D

# these signals are emitted when the target has been either hit or missed
# in both cases, Target.gd deals with the actual removal of the target object
# so other tasks that need to be carried out by Game.gd should be done there,
# using these signals to identify when they need to be carried out
signal target_hit
signal target_miss
signal target_destroy

var internalTimer: float
var referenceToSettings # so that the shoot button can be read via the reference and be up to date always
var timeAtWhichDestroyed: float

export var type: int setget , getType
export var startPosition: Vector2 setget , getStartPosition
export var endPosition: Vector2 setget , getEndPosition
# the number of seconds the target remains on the screen for:
export var activeDuration: float setget , getActiveDuration
export var targetHealth: int setget , getHealth

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

# constructor
func initialiseTarget(settingsReference, targetType: int, health: int, startPos: Vector2, endPos: Vector2, howLongToKeepOnScreen: float):
	if howLongToKeepOnScreen == 0.0:
		return # prevent division by 0 error in _process
	referenceToSettings = settingsReference
	match targetType:
		Global.TargetType.RED:
			$Area2D/Sprite.modulate = ColorN("red", 1.0)
			$Area2D.scale = Vector2(1.5, 1.5)
		Global.TargetType.ORANGE:
			$Area2D/Sprite.modulate = Color("DB7900")
			$Area2D.scale = Vector2(1.4, 1.4)
		Global.TargetType.YELLOW:
			$Area2D/Sprite.modulate = ColorN("yellow", 1.0)
			$Area2D.scale = Vector2(1.3, 1.3)
		Global.TargetType.GREEN:
			$Area2D/Sprite.modulate = ColorN("green", 1.0)
			$Area2D.scale = Vector2(1.2, 1.2)
		Global.TargetType.BLUE:
			$Area2D/Sprite.modulate = ColorN("blue", 1.0)
			$Area2D.scale = Vector2(1.1, 1.1)
		Global.TargetType.PURPLE:
			$Area2D/Sprite.modulate = ColorN("purple", 1.0)
			$Area2D.scale = Vector2(1.0, 1.0)
		_:
			OS.alert("Invalid target type!")
	targetHealth = health
	endPosition = endPos
	activeDuration = howLongToKeepOnScreen
	startPosition = startPos
	# manage positions
	$Area2D.position = startPosition
	var newCurve := Curve2D.new()
	newCurve.add_point(startPosition)
	newCurve.add_point(endPosition)
	set_curve(newCurve)
	# if a moving target, setup destination marker
	if startPosition != endPosition:
		$DestinationMarker.rect_position = endPosition - $DestinationMarker.rect_size / 2.0
		$MarkerOutline.rect_position = endPosition - $DestinationMarker.rect_size / 2.0 - ($MarkerOutline.rect_size - $DestinationMarker.rect_size) / 2.0
		$DestinationMarker.color = $Area2D/Sprite.modulate
		$DestinationMarker.visible = true
		$MarkerOutline.visible = true

func _process(delta):
	internalTimer += delta
	if targetHealth > 0:
		$Area2D.position = curve.interpolate_baked(internalTimer / activeDuration * curve.get_baked_length(), true)
		if internalTimer >= activeDuration:
			emit_signal("target_miss")
			get_parent().remove_child(self)
			queue_free()
	else:
		if internalTimer - timeAtWhichDestroyed >= 1.0:
			get_parent().remove_child(self)
			queue_free()

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if targetHealth > 0 && event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == (BUTTON_LEFT if referenceToSettings.isLeftButtonToShoot else BUTTON_RIGHT):
			targetHealth -= 1
			# move bullet hole graphic and make visible
			get_node("Area2D/BulletHole" + str(0 if targetHealth < 0 else targetHealth)).offset = (event.position - $Area2D.position) / $Area2D.scale
			get_node("Area2D/BulletHole" + str(0 if targetHealth < 0 else targetHealth)).visible = true
			emit_signal("target_hit")
			if targetHealth <= 0:
				$Area2D/Sprite.modulate = Color($Area2D/Sprite.modulate.r, $Area2D/Sprite.modulate.g, $Area2D/Sprite.modulate.b, 0.5)
				timeAtWhichDestroyed = internalTimer
				emit_signal("target_destroy")
