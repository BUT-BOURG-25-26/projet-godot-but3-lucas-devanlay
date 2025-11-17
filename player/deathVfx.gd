extends Area3D


var particules : Array[GPUParticles3D]

func _ready() -> void:
	var childrens = get_children()
	for i in range(len(childrens)):
		if(childrens[i] is GPUParticles3D):
			particules.append(childrens[i])
	
func emit():
	for i in range(len(particules)):
		particules[i].emitting = true
	
