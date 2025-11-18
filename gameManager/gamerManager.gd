class_name GameManager
extends Node

@export var worldScene : PackedScene
var distanceTraveled : float =0
var externalScore : float = 0
var gameHasStarted : bool = false
var gameHasEnded : bool = false

var player : Player
var menue : CanvasLayer
var gameOverMenue : Control
var distanceLable : Label
var worldElem : WorldElement
var mainScene : Node3D
var gameSpeed : float = 1
var nextTarget = 10

func _ready() -> void:
	player = $"../player"
	menue = $"../UI/MainMenue"
	gameOverMenue = $"../UI/GameOverMenue"
	worldElem = $"../WorldElement"
	distanceLable = $"../UI/Score"
	mainScene = $".."
	
func _process(delta: float) -> void:
	if(!gameHasStarted):
		if(listenForInputs()):
			start()
	elif(gameHasEnded):
		if(listenForInputs()):
			restart()
	else:
		increaseDistanceTraveled()
		if(updateGameSpeed()):
			player.speedUpRunning()
		worldElem.gameSpeed = gameSpeed

func preparePlayer()->void:
	player.turningAround = true
	player.gameIsOngoing = true

func prepareWorld()->void:
	worldElem.gameIsOngoing = true
	worldElem.gameSpeed = gameSpeed

func resetWorld()->void:
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
	player.kill()
	resetWorld()
	gameOverMenue.updateAndShow(distanceTraveled + externalScore)

func increaseDistanceTraveled():
	distanceTraveled +=gameSpeed
	distanceLable.text = "score : "+str(int(distanceTraveled + externalScore))
	
func addToExternalScore(additionScore : float):
	externalScore += additionScore

func updateGameSpeed() -> bool:
	if(nextTarget<=distanceTraveled):
		gameSpeed+=0.1
		if(gameSpeed >= 15 ):
			return false
		elif(gameSpeed>10):
			nextTarget=nextTarget*4
		elif(gameSpeed>5):
			nextTarget=nextTarget*3
		else:
			nextTarget=nextTarget*2
		return true
	return true

func start():
	gameHasStarted= true
	prepareWorld()
	preparePlayer()
	menue.hide()
	distanceTraveled = 0
	externalScore = 0
	
func restart():
	gameOverMenue.hide()
	player.model.show()
	player.resetPlayer()
	worldElem.resetWorld()
	worldElem.restart()
	menue.updateAndShow(distanceTraveled + externalScore)
	resetAttributes()
	print("restarted")
	
func resetAttributes():
	distanceTraveled = 0
	externalScore = 0
	gameHasStarted = false
	gameSpeed = 1
	gameHasEnded= false

func quite():
	get_tree().quit()
