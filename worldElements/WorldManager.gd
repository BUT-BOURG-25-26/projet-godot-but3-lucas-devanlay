class_name WorldManager
extends Node3D

var difficulty : float = 1
var distanceUntilNextTile : int
const tileSize : int = 60
var worldGeneration : WorldGeneration
var gameIsOngoing : bool = false

func _ready() -> void:
	worldGeneration = $worldGeneration
	distanceUntilNextTile= tileSize

#Moves the entire map backward by the set speed
func _physics_process(delta: float) -> void:
	if(gameIsOngoing):
		if(difficulty>5):
			global_position.z+=5
			distanceUntilNextTile -= 5
		else:
			global_position.z+=difficulty
			distanceUntilNextTile -= difficulty

func _process(delta: float) -> void:
	if(distanceUntilNextTile<=0 and gameIsOngoing):
		worldGeneration.generateNext(difficulty)
		distanceUntilNextTile = tileSize - difficulty
		
func restart():
	worldGeneration.clearAll()
	distanceUntilNextTile= tileSize
	worldGeneration.preGenerateTerraine()
	
func resetWorld():
	global_position = Vector3(0,0,0)
	gameIsOngoing = 0
	difficulty = 1
