extends CanvasLayer

var scoreBoard : ScoreBoard
var guide : Control
var instruction : InstructionLable
var guideIsShown : bool = false

func _ready():
	scoreBoard = $ScoreBoard
	guide = $Guide
	instruction = $instruction
	
func updateAndShow(score : float = 0):
	if(score>0):
		addScore(score)
	updatescoreBoard()
	show()

func updatescoreBoard():
	scoreBoard.updateScores()
	
func addScore(score : float):
	scoreBoard.addScore(score)

func _on_guide_button_pressed() -> void:
	if(!guideIsShown):
		scoreBoard.hideWithLable()
		instruction.hide()
		instruction.dissableDisplay()
		guide.show()
		guideIsShown=true
	else:
		scoreBoard.showWithLable()
		instruction.show()
		instruction.enableDisplay()
		guide.hide()
		guideIsShown=false
