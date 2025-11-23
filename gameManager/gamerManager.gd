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
var worlManager : WorldManager
var mainScene : Node3D
var musicHanlder : musicHandler
var difficulty : float = 1
var nextTarget = 10
var waiting = false

func _ready() -> void:
	player = $"../player"
	menue = $"../UI/MainMenue"
	gameOverMenue = $"../UI/GameOverMenue"
	worlManager = $"../WorldManager"
	distanceLable = $"../UI/Score"
	mainScene = $".."
	musicHanlder = $"../Music"
	
func _process(delta: float) -> void:
	if(!gameHasStarted):
		if(listenForInputs() and !waiting):
			start()
	elif(gameHasEnded):
		if(listenForInputs()):
			waiting = true
			restart()
			await get_tree().create_timer(0.5).timeout
			waiting = false
	else:
		increaseDistanceTraveled()
		if(updateDifficulty()):
			player.speedUpRunning()
		worlManager.difficulty = difficulty

func preparePlayer()->void:
	player.turningAround = true
	player.gameIsOngoing = true

func prepareWorld()->void:
	worlManager.gameIsOngoing = true
	worlManager.difficulty = difficulty

func resetWorld()->void:
	worlManager.gameIsOngoing = false
	worlManager.difficulty = 0

func listenForInputs():
	if(Input.get_action_strength("ui_accept")
		+Input.get_action_strength("ui_up")
		+Input.get_action_strength("ui_down")
		+Input.get_action_strength("ui_left")
		+Input.get_action_strength("ui_right")
		+Input.get_action_strength("right")
		+Input.get_action_strength("left")
		+Input.get_action_strength("up")
	):
		return true
	return false
	
func gameOver():
	musicHanlder.inMenue = true
	difficulty = 0
	player.kill()
	resetWorld()
	gameOverMenue.updateAndShow(distanceTraveled + externalScore)
	await get_tree().create_timer(0.5).timeout
	gameHasEnded = true

func increaseDistanceTraveled():
	distanceTraveled +=difficulty
	distanceLable.text = "score : "+str(int(distanceTraveled + externalScore))
	
func addToExternalScore(additionScore : float):
	externalScore += additionScore

func updateDifficulty() -> bool:
	if(nextTarget<=distanceTraveled):
		difficulty+=0.1
		if(difficulty >= 15 ):
			return false
		elif(difficulty>10):
			nextTarget=nextTarget + 5000
		elif(difficulty>6):
			nextTarget=nextTarget + 3000
		elif(difficulty>5):
			nextTarget=nextTarget + 2000
		elif(difficulty>4):
			nextTarget=nextTarget + 1000
		elif(difficulty>3):
			nextTarget=nextTarget + 750
		elif(difficulty>2):
			nextTarget=nextTarget + 500
		else:
			nextTarget=nextTarget + 100
		return true
	return true

func start():
	gameHasStarted= true
	prepareWorld()
	preparePlayer()
	menue.hide()
	distanceTraveled = 0
	externalScore = 0
	musicHanlder.inMenue = false
	
func restart():
	gameOverMenue.hide()
	player.resetPlayer()
	worlManager.resetWorld()
	worlManager.restart()
	menue.updateAndShow(distanceTraveled + externalScore)
	resetAttributes()
	print("restarted")
	
func resetAttributes():
	distanceTraveled = 0
	externalScore = 0
	gameHasStarted = false
	difficulty = 1
	gameHasEnded= false

func quite():
	get_tree().quit()
