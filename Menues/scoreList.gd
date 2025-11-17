extends ItemList

var scoreList : Array[float]

func _ready() -> void:
	addScore(3999)
	addScore(255)
	addScore(3669)
	addScore(2468486)

func addScore(score : float):
	scoreList.append(score)
	scoreList.sort_custom(assending)
	clear()
	for i in range(len(scoreList)):
		add_item(str(int(scoreList[i])))

func assending(a : float,b : float) -> bool:
	if(a>b):
		return true
	return false
