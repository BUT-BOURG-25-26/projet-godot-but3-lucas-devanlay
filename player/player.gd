class_name Player
extends CharacterBody3D

var gameIsOngoing : bool = false
var turningAround : bool =false	
var gameManager : GameManager
var deathVFX : DeathVfx = null
var canDash : bool = true
@export var deathVFXScene : PackedScene
var model : Node3D
var respawnSFX : AudioStreamPlayer

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("gameManager")
	setUpVFX()
	model = $playerModel
	respawnSFX= $respawn
	
func _physics_process(delta: float) -> void:
	if(gameIsOngoing):
		if(!is_on_floor()):
			velocity.y -= 2
		if(is_on_floor()):
			velocity.y +=  getInputUp()*40
		velocity.x = (-(getInputLeft()) + (getInputRight()))*20
		move_and_slide()
		if(global_position.z>1):
			gameManager.gameOver()
		elif(global_position.z>0):
			velocity.z = -0.01
		elif(global_position.z<0):
			velocity.z = 0.1

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
	
func resetPlayer():
	global_position = Vector3(0,0,0)
	velocity = Vector3(0,0,0)
	turningAround =false
	gameIsOngoing = false
	setUpVFX()
	respawnSFX.play(0)
	model.show()
	rotate_y(PI)
	
func kill():
	deathVFX.emit()
	model.hide() 
	gameIsOngoing = false
	global_position.z = 0
	
func setUpVFX():
	if(deathVFX!=null):
		deathVFX.free()
	deathVFX = deathVFXScene.instantiate()
	add_child(deathVFX)
	
func getInputUp() -> float:
	if(Input.get_action_strength("ui_up")>0):
		return Input.get_action_strength("ui_up")
	elif(Input.get_action_strength("up")>0):
		return Input.get_action_strength("up")
	else: 
		return 0
		
func getInputLeft() -> float:
	if(Input.get_action_strength("ui_left")>0):
		return Input.get_action_strength("ui_left")
	elif(Input.get_action_strength("left")>0):
		return Input.get_action_strength("left")
	else: 
		return 0

func getInputRight() -> float:
	if(Input.get_action_strength("ui_right")>0):
		return Input.get_action_strength("ui_right")
	elif(Input.get_action_strength("right")>0):
		return Input.get_action_strength("right")
	else: 
		return 0
