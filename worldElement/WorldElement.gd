class_name WorldElement
extends Node3D

var gameIsOngoing : bool = false
var groundTiles : Array[GroundTile]
var boxList : Array[BaseBox]
var strawberryList : Array[Strawberry]

@export var groundTileScene : PackedScene
@export var dirtBoxScene : PackedScene 
@export var strawberryScene : PackedScene 

@export var strawberrySpawnChance : int = 90

var gameSpeed : float = 1
var distanceUntilNextTile : int
const tileSize : int = 60
@export var pregeneratedTileNumber : int = 15

func _ready() -> void:
	var childrens = get_children()
	for i in range(len(childrens)):
		if(childrens[i] is BaseBox):
			boxList.append(childrens[i])
		elif(childrens[i] is GroundTile):
			groundTiles.append(childrens[i])
		elif(childrens[i] is Strawberry):
			strawberryList.append(childrens[i])
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
	print("Boxes :",len(boxList)," Strawberry :",len(strawberryList)," tiles :",len(groundTiles), " speed :",gameSpeed)

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
	if(gameSpeed<2):
		limit  = randi_range(0,1)
	elif(gameSpeed<4):
		limit  = randi_range(0,2)
		double = randi_range(0,15)>=15
	elif(gameSpeed<5):
		limit  = randi_range(0,3)
		double = randi_range(0,10)>=10
	elif(gameSpeed<8):
		limit  = randi_range(1,5)
		double = randi_range(0,5)>=5
	elif(gameSpeed<14):
		limit  = randi_range(3,8)
		double = randi_range(0,5)>=4
	else:
		limit  = randi_range(5,8)
		double = randi_range(0,1)
	for i in range(limit):
		addBoxes(placement, double)

func addGroundTile(placement : int =0):
	var tile : GroundTile = groundTileScene.instantiate() 
	groundTiles.append(tile)
	add_child.call_deferred(tile)
	await tile.ready
	tile.global_position.y = 0
	tile.global_position.z = -placement*tileSize

func addBoxes(placement : int =0,double : bool =false):
	var box : BaseBox = dirtBoxScene.instantiate()
	var box2 : BaseBox
	boxList.append(box)
	add_child.call_deferred(box)
	if(double):
		box2 = dirtBoxScene.instantiate()
		boxList.append(box2)
		add_child.call_deferred(box2)
	await box.ready
	var limitX : float = randf_range(-16,16)
	var limitZ : float = randf_range(0,60)
	box.global_position.y = 3.5
	box.global_position.z = -placement*tileSize+limitZ
	box.global_position.x = limitX
	if(double):
		await box2.ready
		box2.global_position.y = 7
		box2.global_position.z = -placement*tileSize+limitZ
		box2.global_position.x = limitX
		box2.gravity_scale=0.5	
	
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
	groundTiles.clear()	
	boxList.clear()
	strawberryList.clear()
	
func restart():
	clearAll()
	distanceUntilNextTile= tileSize
	preGenerateTerraine()
	
func resetWorld():
	global_position = Vector3(0,0,0)
	gameIsOngoing = 0
	gameSpeed = 1
