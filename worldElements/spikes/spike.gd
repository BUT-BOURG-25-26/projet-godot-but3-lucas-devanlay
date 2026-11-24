class_name Spike
extends Node3D

const ANTI_MERG_DISPLACEMENT : float = 4

func _on_body_entered(body: Node3D) -> void:
	if(body is Player):
		var	gameManager : GameManager = get_tree().get_first_node_in_group("gameManager")
		gameManager.gameOver()
	if(body is BaseBox):
		global_position.y += ANTI_MERG_DISPLACEMENT
