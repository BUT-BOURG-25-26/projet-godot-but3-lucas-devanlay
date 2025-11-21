class_name WorldGeneration
extends Node3D

var  worldManager : WorldManager
var tileSize : int
var groundTiles : Array[GroundTile]
var boxList : Array[BaseBox]
var strawberryList : Array[Strawberry]
var spikeList : Array[Spike]

var gameSpeed : int =1
@export var pregeneratedTileNumber : int = 10

@export var groundTileScene : PackedScene
@export var dirtBoxScene : PackedScene
@export var concreteBoxScene : PackedScene 
@export var strawberryScene : PackedScene 
@export var spikeBaleScene : PackedScene
@export var strawberrySpawnChance : int = 80

func _ready() -> void:
	worldManager = $".."
	tileSize = worldManager.tileSize
	var childrens = worldManager.get_children()
	for i in range(len(childrens)):
		if(childrens[i] is BaseBox):
			boxList.append(childrens[i])
		elif(childrens[i] is GroundTile):
			groundTiles.append(childrens[i])
		elif(childrens[i] is Strawberry):
			strawberryList.append(childrens[i])
	preGenerateTerraine()

func generateNext(newGameSpeed : int):
	gameSpeed = newGameSpeed
	addGroundTile(pregeneratedTileNumber)
	addObstacles(pregeneratedTileNumber)
	addCollectibles(pregeneratedTileNumber)
	deleteElementsOutideView()

func preGenerateTerraine():
	addGroundTile(-1)
	addGroundTile(0)
	addGroundTile(1)
	print("pregenerating")
	for i in range(2,pregeneratedTileNumber+1):
		addGroundTile(i)
		addObstacles(i)
		addCollectibles(i)

func addObstacles(placement : int =0) ->void:
	var limit : int
	var double : bool = false
	var isSpike : bool
	var lowerLimit = gameSpeed/2-5
	var upperLimit = gameSpeed/2+0.5
	if(lowerLimit<0):
		lowerLimit = 0
	if(upperLimit<1):
		upperLimit=1
	limit  = randi_range(lowerLimit,upperLimit)
	double = randi_range(0,20-gameSpeed)<=5
	for i in range(limit):
		if(i >= gameSpeed/3):
			addSpikeBall(placement)
		addBoxes(placement, double)

func addGroundTile(placement : int =0):
	var tile : GroundTile = groundTileScene.instantiate() 
	groundTiles.append(tile)
	add_child.call_deferred(tile)
	await tile.ready
	tile.global_position.y = 0
	tile.global_position.z = -placement*tileSize
	
func addSpikeBall(placement : int =0):
	var lowerLimit : int =gameSpeed-5
	var multiply : int
	if(lowerLimit<1):
		multiply = randi_range(1,gameSpeed/4)
	else:
		multiply= randi_range(lowerLimit,gameSpeed/4)
	var limitX : float = randf_range(-16,16)
	var limitZ : float = randf_range(0,60)
	for i in range(0,multiply):
		var spike : Spike = spikeBaleScene.instantiate()
		spikeList.append(spike)
		add_child.call_deferred(spike)
		await spike.ready
		spike.global_position.y = randf_range(0,5)
		spike.global_position.z = -placement*tileSize+limitZ+randf_range(-5,5)
		spike.global_position.x = limitX+randf_range(-5,5)
	
func addBoxes(placement : int =0,double : bool =false):
	var lowerLimit : int =gameSpeed-5
	var multiply : int = lowerLimit
	var hasSpikes : bool = false
	if(lowerLimit<0):
		multiply = randi_range(0,gameSpeed/4)
	else:
		if(gameSpeed>2):
			multiply= randi_range(lowerLimit,gameSpeed)
		if(gameSpeed>3):
			hasSpikes = randi_range(0,100)>=100-(gameSpeed-3)*10
	var limitX : float = randf_range(-16,16)
	var limitZ : float = randf_range(0,60)
	var box : BaseBox
	for i in range(0,multiply+1):
		if(hasSpikes):
			box = concreteBoxScene.instantiate()
		else:
			box = dirtBoxScene.instantiate()
		boxList.append(box)
		add_child.call_deferred(box)
		await box.ready
		box.global_position.y = 3*(i+1)
		box.global_position.z = -placement*tileSize+limitZ
		box.global_position.x = limitX
	
func addCollectibles(placement : int =0):
	var success : int = randi_range(gameSpeed,100)
	if(success>=strawberrySpawnChance):
		addStrawberry(placement)

func addStrawberry(placement : int =0):
	var berry : Strawberry = strawberryScene.instantiate()
	strawberryList.append(berry)
	add_child.call_deferred(berry)
	await berry.ready
	var limitX : float = randf_range(-15,15)
	var limitY : float = randf_range(1,6)
	var limitZ : float = randf_range(-30,30)
	berry.global_position.y = limitY
	berry.global_position.z = -placement*tileSize+limitZ
	berry.global_position.x = limitX
	
func deleteElementsOutideView():
	if(!groundTiles.is_empty()):
		if(groundTiles[0].global_position.z>tileSize):
			groundTiles[0].queue_free()
			groundTiles.pop_front()
	while(!boxList.is_empty() and (boxList[0].global_position.z>tileSize or boxList[0].global_position.y<-4)):
			boxList[0].queue_free()
			boxList.pop_front()
	if(!strawberryList.is_empty()):
		if(strawberryList[0].global_position.z>tileSize or strawberryList[0].global_position.y<-4):
			strawberryList[0].queue_free()
			strawberryList.pop_front()

func clearAll():
	for i in range(len(groundTiles)):
		groundTiles[i].queue_free()
	for i in range(len(boxList)):
		boxList[i].queue_free()
	for i in range(len(strawberryList)):
		strawberryList[i].queue_free()
	for i in range(len(spikeList)):
		spikeList[i].queue_free()	
	groundTiles.clear()	
	boxList.clear()
	strawberryList.clear()
	spikeList.clear()
	
