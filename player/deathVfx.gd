extends Area3D

@onready var particule =$deathparticles

func emit():
	particule.emitting = true
	
