class_name GameManager
extends Node

@export var worldScene : PackedScene
var distanceTraveled : float =0
var gameHasStarted : bool = false
var gameHasEnded : bool = false

var player : Player
var menue : CanvasLayer
var distanceLable : Label
var worldElem : WorldElement
var mainScene : Node3D
var gameSpeed : float = 1
var nextTarget = 500

func _ready() -> void:
	player = $"../player"
	menue = $"../UI/MainMenue"
	worldElem = $"../WorldElement"
	distanceLable = $"../UI/Label"
	mainScene = $".."
	
func _process(delta: float) -> void:
	if(!gameHasStarted):
		print("hasn't started")
		if(listenForInputs()):
			gameHasStarted= true
			prepareWorld()
			preparePlayer()
			menue.hide()	
			distanceTraveled = 0
	elif(gameHasEnded):
		print("ended")
		if(listenForInputs()):
			restart()
	else:
		increaseDistanceTraveled()
		if(updateGameSpeed()):
			player.speedUpRunning()
		worldElem.gameSpeed = gameSpeed
		distanceLable.text = "score : "+str(int(distanceTraveled))

func preparePlayer()->void:
	player.turningAround = true
	player.gameIsOngoing = true

func prepareWorld()->void:
	worldElem.gameIsOngoing = true
	worldElem.gameSpeed = gameSpeed
	
func endPlayer()->void:
	player.gameIsOngoing = false
	player.turningAround = true
	
func endWorld()->void:
	worldElem.gameIsOngoing = false
	worldElem.gameSpeed = 0

func listenForInputs():
	if(Input.get_action_strength("ui_accept")
		+Input.get_action_strength("ui_up")
		+Input.get_action_strength("ui_down")
		+Input.get_action_strength("ui_left")
		+Input.get_action_strength("ui_right")
	):
		return true
	return false
	
func gameOver():
	gameHasEnded = true
	gameSpeed = 0
	endPlayer()
	endWorld()
	get_tree().get_first_node_in_group("scoreList").addScore(distanceTraveled)
	distanceTraveled = 0
	menue.show()
	Engine.time_scale=1

func increaseDistanceTraveled():
	distanceTraveled +=gameSpeed

func updateGameSpeed() -> bool:
	if(nextTarget<=distanceTraveled):
		gameSpeed+=0.5
		if(gameSpeed>20):
			nextTarget=nextTarget*5
		elif(gameSpeed>10):
			nextTarget=nextTarget*4
		else:
			nextTarget=nextTarget*3
		return true
	return false
	
func restart():
	player.model.show()
	gameHasEnded= false
	player.global_position.z = 0
	player.global_position.x = 0
	worldElem.global_position = Vector3(0,0,0)
	worldElem.gameSpeed = 1
	worldElem.restart()
	gameHasStarted = false
	gameSpeed = 1
	print("restarted")

func quite():
	get_tree().quit()
