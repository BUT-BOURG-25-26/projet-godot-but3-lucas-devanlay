class_name BaseBox
extends RigidBody3D

var gameManager : GameManager

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("gameManager")

func _on_body_entered(body: Node3D) -> void:
	print("entered ",body.name)
	if(body is Player):
		gameManager.gameOver()

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print("entered ",body.name)
	if(body is Player):
		gameManager.gameOver()
