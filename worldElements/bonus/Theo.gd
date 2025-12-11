class_name Theo
extends Bonus

func _ready() -> void:
	super()
	value = 1000
	animationToPlay = "Run"
	audioPlayer = $AudioStreamPlayer3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	actOnCollision(body)
