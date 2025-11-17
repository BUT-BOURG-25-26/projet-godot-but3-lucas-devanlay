extends Control

var scoreDisplay : Label

func _ready() -> void:
	scoreDisplay = $Scorevalue

func updateAndShow(score : float):
	scoreDisplay.text = (str(int(score)))
	show()
