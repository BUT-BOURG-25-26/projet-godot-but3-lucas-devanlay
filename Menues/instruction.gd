extends Label

var isDisplayed : bool = false

func _process(delta: float) -> void:
	if(!isDisplayed):
		switchDisplay()

func switchDisplay():
	isDisplayed = true
	show()
	await get_tree().create_timer(1).timeout
	hide()
	await get_tree().create_timer(1).timeout
	isDisplayed = false
