class_name PlayerModel
extends Node3D

var animationPlayer : playerAnimation
var hairs : Array[MeshInstance3D]
@export var redHaireMaterialScene : Material
@export var blueHaireMaterialScene : Material

func _ready() -> void:
	animationPlayer = $AnimationPlayer
	hairs.append($Armature/Skeleton3D/Cube_001)
	hairs.append($Armature/Skeleton3D/Cube_006)
	hairs.append($Armature/Skeleton3D/Cube_007)
	hairs.append($Armature/Skeleton3D/Cube_008)
	hairs.append($Armature/Skeleton3D/Cube_009)
	hairs.append($Armature/Skeleton3D/Cube_010)
	hairs.append($Armature/Skeleton3D/Cube_011)
	
func setHairToBlue():
	for i in range(len(hairs)):
		hairs[i].set_surface_override_material(0,blueHaireMaterialScene)
		
func setHairToRed():
	for i in range(len(hairs)):
		hairs[i].set_surface_override_material(0,redHaireMaterialScene)

func speedUpRun():
	animationPlayer.runningSpeed+=1
	
