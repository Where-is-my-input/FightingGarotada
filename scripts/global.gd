extends Node

signal player1KO()
signal player2KO()
signal debugPause()
signal debugFrameAdvance()

var player1Wins = 0
var player2Wins = 0

var ground = 785

func _input(event):
	if event.is_action_pressed("mainmenu"):
		get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
