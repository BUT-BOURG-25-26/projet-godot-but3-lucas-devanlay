class_name WorldGeneration
extends Node3D

var  worldManager : WorldManager
var tileSize : int
var groundTiles : Array[GroundTile]
var boxList : Array[BaseBox]
var strawberryList : Array[Strawberry]
var spikeList : Array[Spike]

var difficulty : float =0 #same as gameSpeed from WorldManager
@export var pregeneratedTileNumber : int = 25

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

func generateNext(newdifficulty : int):
	difficulty = newdifficulty
	addGroundTile(pregeneratedTileNumber)
	addObstacles(pregeneratedTileNumber)
	addCollectibles(pregeneratedTileNumber)
	deleteElementsOutideView()

func preGenerateTerraine():
	addGroundTile(-1)
	addGroundTile(0)
	addGroundTile(1)
	addGroundTile(2)
	print("pregenerating")
	for i in range(3,pregeneratedTileNumber+1):
		difficulty = i/10
		addGroundTile(i)
		addObstacles(i)
		addCollectibles(i)
	difficulty = 1

func addObstacles(placement : int =0) ->void:
	var limit : int
	var double : int = 0
	if(difficulty<=2):
		limit=randi_range(0,1)
	elif(difficulty<=3):
		limit=randi_range(1,2)
		double = randi_range(0,2)
	elif(difficulty<=4):
		limit=randi_range(1,3)
		double = randi_range(1,2)
	elif(difficulty<=5):
		limit=randi_range(2,3)
		double = randi_range(2,3)
	else:
		limit=randi_range(2,4)
		double = 3
		
	for i in range(limit):
		if(i > limit/2):
			addSpikeBall(placement)
		else:
			if(double>0):
				addBoxes(placement, true)
				double-=1
			else:
				addBoxes(placement, false)

func addGroundTile(placement : int =0):
	var tile : GroundTile = groundTileScene.instantiate() 
	groundTiles.append(tile)
	add_child.call_deferred(tile)
	await tile.ready
	tile.global_position.y = 0
	tile.global_position.z = -placement*tileSize
	
func addSpikeBall(placement : int =0):
	var lowerLimit : int =difficulty-5
	var multiply : int
	if(lowerLimit<1):
		multiply = randi_range(1,difficulty/4)
	else:
		multiply= randi_range(lowerLimit,difficulty/4)
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
	var lowerLimit : int =difficulty-5
	var multiply : int = 0
	var hasSpikes : bool = false
	if(double):
		if(difficulty>4):
			multiply= randi_range(1,3)
		elif(difficulty>3):
			multiply= 1
		elif(difficulty>2):
			multiply= randi_range(0,1)
		if(difficulty>4):
			hasSpikes = randi_range(0,100)>=85
		elif(difficulty>3):
			hasSpikes = randi_range(0,100)>=90
		elif(difficulty>2):
			hasSpikes = randi_range(0,100)>=95

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
		box.global_position.y = 3.5*(i+1)
		box.global_position.z = -placement*tileSize+limitZ
		box.global_position.x = limitX
	
func addCollectibles(placement : int =0):
	var success : int = randi_range(difficulty,100)
	if(success>=strawberrySpawnChance):
		addStrawberry(placement)

func addStrawberry(placement : int =0):
	var berry : Strawberry = strawberryScene.instantiate()
	strawberryList.append(berry)
	add_child.call_deferred(berry)
	await berry.ready
	var limitX : float = randf_range(-14,14)
	var limitY : float = randf_range(1,11)
	var limitZ : float = randf_range(-20,20)
	berry.global_position.y = limitY
	berry.global_position.z = -placement*tileSize+limitZ
	berry.global_position.x = limitX
	
func deleteElementsOutideView():
	if(!groundTiles.is_empty()):
		if(groundTiles[0].global_position.z>tileSize):
			groundTiles[0].queue_free()
			groundTiles.pop_front()
	if(is_instance_valid(boxList[0])):
		if(!boxList.is_empty()  and (boxList[0].global_position.z>tileSize or boxList[0].global_position.y<-4)):
			if(is_instance_valid(boxList[0])):
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
		if(is_instance_valid(boxList[i])):
			boxList[i].queue_free()
	for i in range(len(strawberryList)):
		strawberryList[i].queue_free()
	for i in range(len(spikeList)):
		spikeList[i].queue_free()	
	groundTiles.clear()	
	boxList.clear()
	strawberryList.clear()
	spikeList.clear()
	
