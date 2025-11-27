class_name Player
extends CharacterBody3D

var gameIsOngoing : bool = false
var turningAround : bool =false
@export var turnAroundStrength : float = 0.2
@export var dashStrength : float = 50
var gameManager : GameManager
var deathVFX : DeathVfx = null
var canDash : bool = true
var dashing : bool = false
@export var deathVFXScene : PackedScene
var model : PlayerModel
var respawnSFX : AudioStreamPlayer

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("gameManager")
	setUpVFX()
	model = $playerModel
	respawnSFX= $respawn
	model.setHairToRed()
	
func _physics_process(delta: float) -> void:
	if(gameIsOngoing):
		if(!is_on_floor()):
			velocity.y -= 2
		if(is_on_floor()):
			velocity.y +=  getInputUp()*40
		velocity.x = (-(getInputLeft()) + (getInputRight()))*20
		if(canDash && Input.get_action_strength("dash")):
			dash()
		if(global_position.z>2):
			gameManager.gameOver()
		elif(global_position.z>=1):
			velocity.z = -0.5
		elif(global_position.z<-5):
			velocity.z += 1
		checkCollission()
		move_and_slide()
		if(global_position.z>-0.1 and global_position.z<0.1):
			global_position.z = 0


func _process(delta: float) -> void:
	if(turningAround):
		turnAround()

func speedUpRunning():
	var model = $playerModel
	model.speedUpRun()
	
func resetPlayer():
	model.setHairToRed()
	global_position = Vector3(0,0,0)
	velocity = Vector3(0,0,0)
	turningAround =false
	gameIsOngoing = false
	dashing = false
	canDash = true
	setUpVFX()
	respawnSFX.play(0)
	rotate_y(PI)
	model.show()
	
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

func turnAround()->void:
	rotate_y(turnAroundStrength)
	if(global_rotation.y==PI or global_rotation.y<= -2):
		global_rotation.y=PI
		turningAround =false
		
func dash()->void:
	canDash = false
	dashing = true
	model.setHairToBlue()
	velocity.z = -dashStrength
	await get_tree().create_timer(0.5).timeout
	dashing = false
	await get_tree().create_timer(0.2).timeout
	model.setHairToRed()
	canDash = true
	
func  checkCollission()->void:
	var obstacles : Array[Node] = get_tree().get_nodes_in_group("obstacle")
	for i in range(len(obstacles)):
		if((obstacles[i].global_position.z < global_position.z + 3) 
		and (obstacles[i].global_position.z > global_position.z -10)
		and (obstacles[i].global_position.x > global_position.x -3)
		and (obstacles[i].global_position.x < global_position.x +3)
		and (obstacles[i].global_position.y > global_position.y-3)
		and (obstacles[i].global_position.y < global_position.y+3)):
			if(obstacles[i].is_in_group("destroyable") and dashing):
				obstacles[i].physics_interpolation_mode=Node.PHYSICS_INTERPOLATION_MODE_OFF
				obstacles[i].queue_free()
				velocity.z+=-5
			
