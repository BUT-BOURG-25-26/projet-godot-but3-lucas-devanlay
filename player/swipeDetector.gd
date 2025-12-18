class_name SwipeDetector
extends Node3D

var length =40
var startPos : Vector2
var curentPos : Vector2
var swiping : bool = false
var swipingLeft : bool = false
var swipingRight : bool = false
var swipingUp: bool = false
var swipingDown: bool = false

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("press")):
		if(!swiping):
			swiping=true
			startPos = get_viewport().get_mouse_position()
	if Input.is_action_pressed("press"):
		if swiping:
			curentPos =  get_viewport().get_mouse_position()
			if startPos.x-curentPos.x>=length:
				swipingLeft= true
			elif startPos.x-curentPos.x<=-length:
				swipingRight= true
			elif startPos.y-curentPos.y>=length:
				swipingUp= true
			elif startPos.y-curentPos.y<=-length:
				swipingDown= true
	else:
		swiping = false
		swipingRight= false
		swipingLeft= false
		swipingUp= false
		swipingDown= false

func getSwippingInAnyDirections()->bool:
	return (swipingRight or swipingLeft or swipingUp or swipingDown)
