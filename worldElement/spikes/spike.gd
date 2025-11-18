class_name Spike
extends Node3D

func _on_body_entered(body: Node3D) -> void:
	if(body is Player):
		get_tree().get_first_node_in_group("gameManager").gameOver()
