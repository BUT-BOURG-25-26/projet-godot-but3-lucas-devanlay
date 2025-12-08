class_name BaseBox
extends RigidBody3D

var size : float = 5
var value : int = 100

func getSize()->float:
	return size

func getValue()->int:
	return value

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is Player):
		if(body.dashing):
			physics_interpolation_mode=Node.PHYSICS_INTERPOLATION_MODE_OFF
			queue_free()
			hide()
			var	gameManager : GameManager = get_tree().get_first_node_in_group("gameManager")
			gameManager.addToExternalScore(getValue())
			body.velocity.z+= -body.dashStrength
