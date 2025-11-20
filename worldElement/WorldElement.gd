class_name WorldElement
extends Node3D

var gameSpeed : float = 5
var distanceUntilNextTile : int
const tileSize : int = 60
var worldGeneration : Node3D
var gameIsOngoing : bool = false

func _ready() -> void:
	worldGeneration = $worldGeneration
	distanceUntilNextTile= tileSize

#Moves the entire map backward by the set speed
func _physics_process(delta: float) -> void:
	if(gameIsOngoing):
		global_position.z+=gameSpeed
		distanceUntilNextTile -= gameSpeed

func _process(delta: float) -> void:
	if(distanceUntilNextTile<=0 and gameIsOngoing):
		worldGeneration.generateNext(gameSpeed)
		distanceUntilNextTile = tileSize - gameSpeed
		
func restart():
	worldGeneration.clearAll()
	distanceUntilNextTile= tileSize
	worldGeneration.preGenerateTerraine()
	
func resetWorld():
	global_position = Vector3(0,0,0)
	gameIsOngoing = 0
	gameSpeed = 1
