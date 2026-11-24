class_name Bonus
extends Node3D

const BONUS_ANTI_MERG_DISPLACEMENT : float = 2
const SPENT_VALUE : float = 0
const DEFAULT_VALUE : float = 500

var value : float = 0
var animationPlayer : AnimationPlayer
var animationToPlay : String  = ""
var audioPlayer : AudioStreamPlayer3D

func _ready() -> void:
	animationPlayer = $AnimationPlayer
	
func _process(delta: float) -> void:
		if(!animationPlayer.is_playing() and animationToPlay!=""):
			animationPlayer.play(animationToPlay)

func actOnCollision(body: Node3D)-> void:
	if(body is Player):
		var gameManager = get_tree().get_first_node_in_group("gameManager")
		gameManager.addToExternalScore(value)
		audioPlayer.play()
		hide()
		value= SPENT_VALUE
	elif(body is Spike):
		global_position.y += BONUS_ANTI_MERG_DISPLACEMENT * 1.5
	elif(body is BaseBox or body is DirtBox):
		global_position.y += BONUS_ANTI_MERG_DISPLACEMENT
