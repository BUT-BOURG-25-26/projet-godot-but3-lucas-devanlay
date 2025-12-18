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
			print("swiping")
			swiping=true
			startPos = get_viewport().get_mouse_position()
	if Input.is_action_pressed("press"):
		if swiping:
			curentPos =  get_viewport().get_mouse_position()
			if startPos.x-curentPos.x>=length:
				print("swiped left!",startPos.x," ",curentPos.x)
				swipingLeft= true
			elif startPos.x-curentPos.x<=-length:
				print("swiped right!",startPos.x," ",curentPos.x)
				swipingRight= true
			elif startPos.y-curentPos.y>=length:
				print("swiped up!",startPos.y," ",curentPos.y)
				swipingUp= true
			elif startPos.y-curentPos.y<=-length:
				print("swiped down!",startPos.y," ",curentPos.y)
				swipingDown= true
	else:
		swiping = false
		swipingRight= false
		swipingLeft= false
		swipingUp= false
		swipingDown= false
