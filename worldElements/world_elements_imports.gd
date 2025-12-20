class_name Imports
extends Node3D

@export var groundTileScene : PackedScene
@export var dirtBoxScene : PackedScene
@export var longDirtBoxScene : PackedScene
@export var concreteBoxScene : PackedScene 
@export var strawberryScene : PackedScene
@export var theoScene : PackedScene 
@export var spikeBallScene : PackedScene
@export var longConcreteBoxScene : PackedScene

@export var set1 : PackedScene
@export var set2 : PackedScene
@export var set3 : PackedScene
@export var set4 : PackedScene
@export var set5 : PackedScene

func getGroundTile()->MeshInstance3D:
	return groundTileScene.instantiate()

func getDirtBoxe()->DirtBox:
	return dirtBoxScene.instantiate()

func getLongDirtBoxe()->LongDirtBox:
	return longDirtBoxScene.instantiate()

func getConcreteBoxe()->ConcreteBox:
	return concreteBoxScene.instantiate()
	
func getLongConcreteBoxe()->LongConcreteBox:
	return longConcreteBoxScene.instantiate()
	
func getStrawberry()->Strawberry:
	return strawberryScene.instantiate()
	
func getTheo()->Theo:
	return theoScene.instantiate()

func getSpikeBall()->Spike:
	return spikeBallScene.instantiate()

func getSet(index: int)->Node3D:
	if index==1:
		return set1.instantiate()
	if index==2:
		return set2.instantiate()
	if index==3:
		return set3.instantiate()
	if index==4:
		return set4.instantiate()
	if index==5:
		return set5.instantiate()
	return set1.instantiate()
