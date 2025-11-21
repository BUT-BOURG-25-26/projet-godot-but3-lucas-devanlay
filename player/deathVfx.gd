class_name DeathVfx
extends Area3D

var deathSFX : AudioStreamPlayer
var particules : Array[GPUParticles3D]

func _ready() -> void:
	var childrens = get_children()
	deathSFX = $deathSFX
	for i in range(len(childrens)):
		if(childrens[i] is GPUParticles3D):
			particules.append(childrens[i])
	
func emit():
	show()
	for i in range(len(particules)):
		particules[i].emitting = true
	deathSFX.play(0)
