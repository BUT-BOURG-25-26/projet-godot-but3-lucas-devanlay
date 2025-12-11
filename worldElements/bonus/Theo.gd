class_name Theo
extends Bonus

func _ready() -> void:
	super()
	value = 1000
	animationToPlay = "Run"
	audioPlayer = $AudioStreamPlayer3D
