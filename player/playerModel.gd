class_name PlayerModel
extends Node3D

var animationPlayer : playerAnimation

func _ready() -> void:
	animationPlayer = $AnimationPlayer

func speedUpRun():
	animationPlayer.runningSpeed+=1
	
