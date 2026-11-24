class_name GameManager
extends Node

@export var worldScene : PackedScene
const DEFAULT_DIFFICULTY : float = 1
const DEFAULT_NEXT_TARGET : float = 100
const DEFAULT_DIFFICULTY_STEP : float = 0.1
const DEFAULT_TRAVELED_DISTANCE: float = 0
const DEFAULT_EXTERNAL_SCORE: float = 0
const TREE_SEARCH_TIME_SC: float = 0.5

var distanceTraveled : float
var externalScore : float
var gameHasStarted : bool = false
var gameHasEnded : bool = false

var player : Player
var menue : CanvasLayer
var gameOverMenue : Control
var scoreLabel : Label
var difficultyLabel : Label
var worlManager : WorldManager
var mainScene : Node3D
var musicHanlder : musicHandler
var global_difficulty : float
var nextTarget : float
var waiting : bool = false

func _ready() -> void:
	player = $"../player"
	menue = $"../UI/MainMenue"
	gameOverMenue = $"../UI/GameOverMenue"
	worlManager = $"../WorldManager"
	scoreLabel = $"../UI/Score"
	difficultyLabel = $"../UI/Difficulty"
	mainScene = $".."
	musicHanlder = $"../Music"
	distanceTraveled = DEFAULT_TRAVELED_DISTANCE
	externalScore = DEFAULT_EXTERNAL_SCORE
	global_difficulty = DEFAULT_DIFFICULTY
	nextTarget = DEFAULT_NEXT_TARGET
	hideIngameInfo(true)
	
func _process(delta: float) -> void:
	if(!gameHasStarted):
		distanceTraveled = DEFAULT_TRAVELED_DISTANCE
		if(getStartingInputs() and !waiting):
			start()
			hideIngameInfo(false)
	elif(gameHasEnded):
		if(Input.is_anything_pressed()):
			waiting = true
			restart()
			await get_tree().create_timer(TREE_SEARCH_TIME_SC).timeout
			waiting = false
	else:
		distanceTraveled +=  global_difficulty 
		updateScoreLabel()
		updateDifficultyLabel()
		if(updateDifficulty()):
			player.speedUpRunning()
		worlManager.global_difficulty = global_difficulty

func getStartingInputs()->bool:
	if(
		Input.get_action_strength("left")+
		Input.get_action_strength("right")+
		Input.get_action_strength("up")+
		Input.get_action_strength("dash")+
		Input.get_action_strength("ui_left")+
		Input.get_action_strength("ui_right")+
		Input.get_action_strength("ui_accept")
	):
		return true
	return player.SwipeDectector!= null and player.SwipeDectector.getSwippingInAnyDirections()

func preparePlayer()->void:
	player.turningAround = true
	player.gameIsOngoing = true

func prepareWorld()->void:
	worlManager.gameIsOngoing = true
	worlManager.global_difficulty = global_difficulty

func resetWorld()->void:
	worlManager.gameIsOngoing = false
	worlManager.global_difficulty = DEFAULT_DIFFICULTY

func gameOver():
	musicHanlder.inMenue = true
	gameHasEnded = true
	player.kill()
	resetWorld()
	gameOverMenue.updateAndShow(distanceTraveled + externalScore)
	hideIngameInfo()
	await get_tree().create_timer(TREE_SEARCH_TIME_SC).timeout
	
func hideIngameInfo(hide:bool =true):
	if(hide):
		scoreLabel.hide()
		difficultyLabel.hide()
	else:
		scoreLabel.show()
		difficultyLabel.show()
		
func updateScoreLabel():
	scoreLabel.text = "Score : "+str(int(distanceTraveled + externalScore))

func updateDifficultyLabel():
	difficultyLabel.text = "Difficulty : "+str(float(global_difficulty))
	
func addToExternalScore(additionScore : float):
	externalScore += additionScore * global_difficulty/2

func updateDifficulty() -> bool:
	if(nextTarget<=distanceTraveled):
		global_difficulty += DEFAULT_DIFFICULTY_STEP
		if(global_difficulty >= 15 ):
			return false
		elif(global_difficulty>10):
			nextTarget += 20000
		elif(global_difficulty>6):
			nextTarget += 10000
		elif(global_difficulty>5):
			nextTarget += 5000
		elif(global_difficulty>4):
			nextTarget += 2000
		elif(global_difficulty>3):
			nextTarget += 1000
		elif(global_difficulty>2):
			nextTarget += 500
		else:
			nextTarget += 200
		return true
	return true

func start():
	gameHasStarted= true
	prepareWorld()
	preparePlayer()
	menue.hide()
	distanceTraveled = DEFAULT_TRAVELED_DISTANCE
	externalScore = DEFAULT_EXTERNAL_SCORE
	musicHanlder.inMenue = false
	
func restart():
	gameOverMenue.hide()
	player.resetPlayer()
	worlManager.resetWorld()
	worlManager.restart()
	menue.updateAndShow(distanceTraveled + externalScore)
	resetAttributes()
	updateScoreLabel()
	updateDifficultyLabel()
	
func resetAttributes():
	distanceTraveled = DEFAULT_TRAVELED_DISTANCE
	externalScore = DEFAULT_EXTERNAL_SCORE
	gameHasStarted = false
	global_difficulty = DEFAULT_DIFFICULTY
	gameHasEnded= false
	nextTarget = DEFAULT_NEXT_TARGET

func quite():
	get_tree().quit()
