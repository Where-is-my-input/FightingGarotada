extends Node

enum mode {VERSUS, TRAINING}
enum hitType {NORMAL, LAUNCHER, KNOCKDOWN, GRAB} #STAGGER, BOUNCES
enum blockType {MID, LOW, HIGH, UNBLOCKABLE}

signal player1KO()
signal player2KO()
signal debugPause()
signal debugFrameAdvance()

var player1Wins = 0
var player2Wins = 0

var ground = 785

var gameMode = mode.VERSUS

func _input(event):
	if event.is_action_pressed("mainmenu"):
		get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func setGameMode(v):
	print("game mode set to - ", v)
	gameMode = v
