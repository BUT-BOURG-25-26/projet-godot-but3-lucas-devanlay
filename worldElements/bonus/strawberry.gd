class_name Strawberry
extends Bonus

func _ready() -> void:
	super()
	animationToPlay = "rotation"
	value = DEFAULT_VALUE
	audioPlayer = $collect	

func _on_area_3d_body_entered(body: Node3D) -> void:
	actOnCollision(body)
