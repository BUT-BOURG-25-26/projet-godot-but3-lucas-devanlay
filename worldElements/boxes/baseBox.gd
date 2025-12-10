class_name BaseBox
extends RigidBody3D

var size : float = 5
var value : int = 100

func getSize()->float:
	return size

func getValue()->int:
	return value

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is Player and body.dashing):
			var colision = $CollisionShape3D
			PHYSICS_INTERPOLATION_MODE_OFF
			colision.PHYSICS_INTERPOLATION_MODE_OFF
			hide()
			var	gameManager : GameManager = get_tree().get_first_node_in_group("gameManager")
			gameManager.addToExternalScore(getValue())
			body.velocity.z = -body.dashStrength
			body.move_and_slide()
			queue_free()
