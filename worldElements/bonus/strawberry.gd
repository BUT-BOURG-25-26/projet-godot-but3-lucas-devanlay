class_name Strawberry
extends Node3D

var value : float = 500
var animationPlayer : AnimationPlayer
func _ready() -> void:
	animationPlayer = $AnimationPlayer
	animationPlayer.play("rotation")
	
func _process(delta: float) -> void:
		if(!animationPlayer.is_playing()):
			animationPlayer.play("rotation")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is Player):
		var gameManager = get_tree().get_first_node_in_group("gameManager")
		gameManager.addToExternalScore(value)
		hide()
		value= 0

func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if(body is Player):
		var gameManager = get_tree().get_first_node_in_group("gameManager")
		gameManager.addToExternalScore(value)
		hide()
		value= 0
