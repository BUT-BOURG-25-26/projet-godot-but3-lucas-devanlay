class_name  musicHandler
extends Node

var inMenue : bool = true
var menuAudioPlayer : AudioStreamPlayer
var playingAudioPlayer : AudioStreamPlayer

func _ready() -> void:
	menuAudioPlayer = $menuMusic
	playingAudioPlayer = $playingMusic

func _process(delta: float) -> void:
	if inMenue == false :
		if playingAudioPlayer.playing == false :
			playingAudioPlayer.play(0)
			menuAudioPlayer.stop()
	else :
		if menuAudioPlayer.playing == false :
			menuAudioPlayer.play(0)
			playingAudioPlayer.stop()

func changeState():
	inMenue = !inMenue
