class_name BaseBox
extends RigidBody3D

var size : float = 5
var value : int = 100
var breakingSound : String = "res://ressources/Audio/sfx/wallbreakDirt.mp3"

func getSize()->float:
	return size

func getValue()->int:
	return value
	
func playBreakingAudio()->void:
	var breakingSoundPlayer : AudioStreamPlayer3D
	if(self is DirtBox):
		breakingSoundPlayer = get_node_or_null("../breakingSoundDirt")
		if(breakingSoundPlayer == null):
			breakingSoundPlayer = get_node_or_null("../../breakingSoundDirt")
	else:
		breakingSoundPlayer = $"../breakingSoundLongDirt"
	if(breakingSoundPlayer == null):
		return
	breakingSoundPlayer.play()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is Player and body.dashing and (self is DirtBox or self is LongDirtBox)):
			var colision = $CollisionShape3D
			playBreakingAudio()
			PHYSICS_INTERPOLATION_MODE_OFF
			colision.PHYSICS_INTERPOLATION_MODE_OFF
			hide()
			var	gameManager : GameManager = get_tree().get_first_node_in_group("gameManager")
			gameManager.addToExternalScore(getValue())
			body.move_and_slide()
			queue_free()
