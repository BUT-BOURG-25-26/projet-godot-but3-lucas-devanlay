class_name WorldElement
extends Node3D

var gameIsOngoing : bool = false
var groundTiles : Array[GroundTile]
var boxList : Array[BaseBox]

@export var groundTileScene : PackedScene
@export var dirtBoxScene : PackedScene 

var gameSpeed : float = 1
var distanceUntilNextTile : int
const tileSize : int = 60
@export var pregeneratedTileNumber : int = 50

func _ready() -> void:
	distanceUntilNextTile= tileSize
	preGenerateTerraine()

#Moves the entire map backward by the set speed
func _physics_process(delta: float) -> void:
	if(gameIsOngoing):
		global_position.z+=gameSpeed
		distanceUntilNextTile -= gameSpeed

func _process(delta: float) -> void:
	if(distanceUntilNextTile<=0 and gameIsOngoing):
		addGroundTile(pregeneratedTileNumber)
		addObstacles(pregeneratedTileNumber)
		deleteElementsOutideView()
		distanceUntilNextTile = tileSize - gameSpeed

func preGenerateTerraine():
	addGroundTile(-1)
	addGroundTile(0)
	addGroundTile(1)
	print("pregenerating")
	for i in range(2,pregeneratedTileNumber):
		addGroundTile(i)
		addObstacles(i)

func addObstacles(placement : int =0) ->void:
	var limit : int = randi_range(0,gameSpeed)
	for i in range(limit):
		addBoxes(placement)

func addGroundTile(placement : int =0):
	var tile : GroundTile = groundTileScene.instantiate() 
	groundTiles.append(tile)
	add_child.call_deferred(tile)
	await tile.ready
	tile.global_position.y = 0
	tile.global_position.z = -placement*tileSize

func addBoxes(placement : int =0):
	var box : BaseBox = dirtBoxScene.instantiate()
	boxList.append(box)
	add_child.call_deferred(box)
	await box.ready
	var limitX : float = randf_range(-15,15)
	var limitZ : float = randf_range(0,60)
	box.global_position.y = 1
	box.global_position.z = -placement*tileSize+limitZ
	box.global_position.x = limitX
		
func deleteElementsOutideView():
	if(groundTiles!=[] ):
		if(groundTiles[0].global_position.z>tileSize):
			groundTiles[0].queue_free()
			groundTiles.pop_front()
	if(boxList!=[]):
		if(boxList[0].global_position.z>tileSize or boxList[0].global_position.y<-4):
			boxList[0].queue_free()
			boxList.pop_front()

func clearAll():
	for i in range(len(groundTiles)):
		groundTiles[i].queue_free()
	for i in range(len(boxList)):
		boxList[i].queue_free()
	groundTiles.clear()	
	boxList.clear()
	
func restart():
	clearAll()
	distanceUntilNextTile= tileSize
	preGenerateTerraine()
