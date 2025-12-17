class_name ScoreBoard
extends ItemList

var scoreList : Array[float]
var lable

@export var numberOfScores : int = 10
#Only to include test data

func _ready() -> void:
	lable = $"../ScoreBoardLable"
	loadScoreFromFile()
	hideWithLable()

func saveScoreToFile():
	var file = FileAccess.open("res://savedData/save_game.txt", FileAccess.WRITE)
	var scoreListString : String =""
	for score in range (len(scoreList)) :
		if(scoreList[score]>0):
			scoreListString += str(int(scoreList[score]))+";"
	file.store_string(scoreListString)

func loadScoreFromFile():
	var file = FileAccess.open("res://savedData/save_game.txt", FileAccess.READ)
	if(file!=null):
		var contents : String = file.get_as_text()
		var stringScoreList = contents.split(";")
		for score in range (len(stringScoreList)) :
			print(stringScoreList[score])
			scoreList.append(float(stringScoreList[score]))

func hideWithLable():
	hide()
	lable.hide()
	
func showWithLable():
	if(len(scoreList)>0):
		show()
		lable.show()

func addScore(score : float):
	scoreList.append(score)
	scoreList.sort_custom(dessending)
	
func updateScores():
	clear()
	saveScoreToFile()
	if(len(scoreList)==0):
		hideWithLable()
		return
	elif(len(scoreList)>=1):
		showWithLable()
	for i in range(len(scoreList)):
		add_item(str(int(scoreList[i])))
		if(i+1>=numberOfScores):
			return 

#Only for custom sort
func dessending(a : float,b : float) -> bool:
	if(a>b):
		return true
	return false
