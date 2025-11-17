class_name Player
extends CharacterBody3D

var gameIsOngoing = false
var turningAround : bool =false	
var gameManager : GameManager

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("gameManager")
	
func _physics_process(delta: float) -> void:
	if(gameIsOngoing):
		if(!is_on_floor()):
			velocity.y -= 2
		if(is_on_floor()):
			velocity.y +=  Input.get_action_strength("ui_up")*40
		velocity.x = (-Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right") )*20
		move_and_slide()
		if(global_position.z>0):
			print("game over")
			gameManager.gameOver()
			global_position.z = 0

func _process(delta: float) -> void:
	if(turningAround):
		var turnAroundStrength : float = 0.2
		rotate_y(turnAroundStrength)
		if(global_rotation.y==PI or global_rotation.y<= -2):
			global_rotation.y=PI
			turningAround =false

func speedUpRunning():
	var model = $playerModel
	model.speedUpRun()
	
