extends CanvasLayer

var scoreList : ItemList

func _ready():
	scoreList = $ScoreList
	
func updateAndShow(score : float = 0):
	if(score>0):
		addScore(score)
	updateScoreList()
	show()

func updateScoreList():
	scoreList.updateScores()
	
func addScore(score : float):
	scoreList.addScore(score)
