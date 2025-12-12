class_name WorldGeneration
extends Node3D

var  worldManager : WorldManager
var tileSize : int
var groundTiles : Array[GroundTile]
var strawberryList : Array[Bonus]
var spikeList : Array[Spike]

var difficulty : float =0 #same as gameSpeed from WorldManager
@export var pregeneratedTileNumber : int = 25
var imports : Imports
@export var strawberrySpawnChance : int = 80
		
func _ready() -> void:
	imports = $worldElementsImports
	worldManager = $".."
	tileSize = worldManager.tileSize
	var childrens = worldManager.get_children()
	for i in range(len(childrens)):
		if(childrens[i] is GroundTile):
			groundTiles.append(childrens[i])
		elif(childrens[i] is Strawberry):
			strawberryList.append(childrens[i])
		elif(childrens[i] is Spike):
			spikeList.append(childrens[i])
	preGenerateTerraine()

func generateNext(newdifficulty : int):
	difficulty = newdifficulty+pregeneratedTileNumber/10
	addGroundTile(pregeneratedTileNumber)
	addObstacles(pregeneratedTileNumber)
	addCollectibles(pregeneratedTileNumber)

func preGenerateTerraine():
	addGroundTile(-1)
	addGroundTile(0)
	addGroundTile(1)
	addGroundTile(2)
	print("pregenerating")
	for i in range(3,pregeneratedTileNumber+1):
		difficulty = i/6
		if(i==10):
			addSet(1,i)
		elif(i==20):
			addSet(4,i)
		elif(i==pregeneratedTileNumber-1):
			addSet(2,i)
		elif(i==pregeneratedTileNumber):
			addGroundTile(i)
		else :
			addGroundTile(i)
			addObstacles(i)
			addCollectibles(i)
		
	difficulty = 1

func addObstacles(placement : int =0) ->void:
	var limit : int
	var numberOfDouble : int = 0 

	if(difficulty<=2):
		limit=randi_range(0,1)
	elif(difficulty<=3):
		limit=randi_range(1,2)
		numberOfDouble = randi_range(-5,1)
	elif(difficulty<=4):
		limit=randi_range(1,3)
		numberOfDouble = randi_range(-3,1)
	elif(difficulty<=5):
		limit=randi_range(2,3)
		numberOfDouble = randi_range(-3,2)
	elif(difficulty<=6):
		limit=randi_range(3,4)
		numberOfDouble = randi_range(0,2)
	else:
		limit=randi_range(3,6)
		numberOfDouble = randi_range(1,2)
	for i in range(limit):
		if(difficulty > 2 and randi_range(difficulty,25)>20):
			addSpikeBall(placement,i)
		else:
			if(numberOfDouble>0):
				addBoxes(placement, true,i)
				numberOfDouble-=1
			else:
				addBoxes(placement, false,i)

func addSet(id: int=0,placement : int =0):
	addGroundTile(placement)
	var tile = imports.getSet(id)
	add_child.call_deferred(tile)
	await tile.ready

	tile.global_position.y = 0
	tile.global_position.z = -placement*tileSize

func addGroundTile(placement : int =0):
	var tile : GroundTile = imports.getGroundTile()
	groundTiles.append(tile)
	add_child.call_deferred(tile)
	await tile.ready
	tile.global_position.y = 0
	tile.global_position.z = -placement*tileSize
	
func addSpikeBall(placement : int =0, interiorPlacement : int =0):
	var multiply : int
	if(difficulty<2):
		multiply = 0
	elif(difficulty<3):
		multiply = randi_range(-1,1)
	elif(difficulty<4):
		multiply = randi_range(0,1)
	elif(difficulty<5):
		multiply = randi_range(0,2)
	else:
		multiply = randi_range(1,5)
	var limitX : float = randf_range(-16,16)
	var limitZ : float = randf_range(0,60)
	for i in range(0,multiply):
		var spike : Spike = imports.getSpikeBall()
		spikeList.append(spike)
		add_child.call_deferred(spike)
		await spike.ready
		spike.global_position.y = randf_range(0,3)
		spike.global_position.z = -placement*tileSize+limitZ+randf_range(-5,5)
		spike.global_position.x = limitX+randf_range(-5,5)
	
func addBoxes(placement : int =0,double : bool =false,  interiorPlacement : int =0):
	var lowerLimit : int =difficulty-5
	var hasSpikes : bool = false
	if(difficulty>5):
		hasSpikes = randi_range(0,100)>=70	
	elif(difficulty>4):
		hasSpikes = randi_range(0,100)>=80
	elif(difficulty>3 and !double):
		hasSpikes = randi_range(0,100)>=90
	elif(difficulty>2 and !double):
		hasSpikes = randi_range(0,100)>=95
	var limitZ : float
	var limitX : float
	var box : BaseBox
	if(hasSpikes and double):
		box = imports.getLongConcreteBoxe()
	elif(hasSpikes):
		box = imports.getConcreteBoxe()
	elif(double):
		box = imports.getLongDirtBoxe()
	else:
		box = imports.getDirtBoxe()
	if(box is LongBaseBox):
		limitX = randf_range(-13,13)
		limitZ = 40/(interiorPlacement+1)
	else:
		limitX  = randf_range(-13,13)
		limitZ = 40/(interiorPlacement+1)
	add_child.call_deferred(box)
	await box.ready
	box.global_position.y = box.getSize()/2
	box.global_position.z = -placement*tileSize+limitZ
	box.global_position.x = limitX
	
func addCollectibles(placement : int =0):
	var success : int = randi_range(difficulty,100)
	var bonus : Bonus
	var limitY : float
	var limitX : float = randf_range(-14,14)
	var limitZ : float = randf_range(-20,20)
	if(success>=99):
		bonus = imports.getTheo()
		limitY = 0
	elif(success>=strawberrySpawnChance):
		bonus = imports.getStrawberry()
		limitY = randf_range(1,11)
	else:
		return
	strawberryList.append(bonus)
	add_child.call_deferred(bonus)
	await bonus.ready
	
	bonus.global_position.y = limitY
	bonus.global_position.z = -placement*tileSize+limitZ
	bonus.global_position.x = limitX
	
func deleteElementsOutideView():
	if(!groundTiles.is_empty()):
		if(is_instance_valid(groundTiles[0])):
			if(groundTiles[0].global_position.z>tileSize):
				groundTiles[0].queue_free()
				groundTiles.pop_front()			
		else:
			groundTiles.pop_front()		
	if(!strawberryList.is_empty()):
		if(is_instance_valid(strawberryList[0])):
			if(strawberryList[0].global_position.z>tileSize or strawberryList[0].global_position.y<-4):
				strawberryList[0].queue_free()
				strawberryList.pop_front()
		else:
			strawberryList.pop_front()

func clearAll():
	for i in range(len(groundTiles)):
		if(is_instance_valid(groundTiles[i])):
			groundTiles[i].queue_free()
	for i in range(len(strawberryList)):
		if(is_instance_valid(strawberryList[i])):
			strawberryList[i].queue_free()
	for i in range(len(spikeList)):
		if(is_instance_valid(spikeList[i])):
			spikeList[i].queue_free()
	var childrens : Array[Node] = get_children()
	for i in range(len(childrens)):
		if(childrens[i] is not Imports and childrens[i] is not AudioStreamPlayer3D):
			childrens[i].queue_free()
	
	groundTiles.clear()	
	strawberryList.clear()
	spikeList.clear()	
