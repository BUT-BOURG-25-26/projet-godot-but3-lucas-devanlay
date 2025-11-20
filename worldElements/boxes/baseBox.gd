class_name BaseBox
extends RigidBody3D

var gameManager : GameManager

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("gameManager")
