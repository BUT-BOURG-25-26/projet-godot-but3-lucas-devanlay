class_name LongBaseBox
extends BaseBox

func _ready() -> void:
	size = size*2
	value = value*2
	breakingSound = "res://ressources/Audio/sfx/wallbreak_stone.wav"
