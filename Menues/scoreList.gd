extends ItemList

var scoreList : Array[float]
@export var numberOfScores : int = 10
#Only to include test data

func addScore(score : float):
	scoreList.append(score)
	scoreList.sort_custom(dessending)
	
func updateScores():
	clear()
	for i in range(len(scoreList)):
		add_item(str(int(scoreList[i])))
		if(i+1>=numberOfScores):
			return 

#Only for custom sort
func dessending(a : float,b : float) -> bool:
	if(a>b):
		return true
	return false
