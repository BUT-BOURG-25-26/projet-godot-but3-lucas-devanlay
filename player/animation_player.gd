class_name playerAnimation
extends AnimationPlayer

var player : Player
var runningSpeed : float = 1

func _ready() -> void:
		play("Idle")
		player = $"../.."

func _process(delta: float) -> void:
		if(!player.gameIsOngoing):
			play("Idle")
		elif(player.turningAround):
			play("Turn_L")
		elif(player.velocity.y>0):
			play("Jump")
		else:
			play("Run")
