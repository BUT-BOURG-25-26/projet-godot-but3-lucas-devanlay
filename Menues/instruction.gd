class_name InstructionLable
extends Label

var shouldDisplay : bool = true
var isDisplayed : bool = false

func _process(delta: float) -> void:
	if(!isDisplayed and shouldDisplay):
		switchDisplay()

func dissableDisplay():
	shouldDisplay = false
	hide()

func enableDisplay():
	shouldDisplay = true
	isDisplayed = true
	show()

func switchDisplay():
	isDisplayed = true
	self.show()
	await get_tree().create_timer(1).timeout
	hide()
	await get_tree().create_timer(1).timeout
	isDisplayed = false
