extends Node

signal player1KO()
signal player2KO()
signal debugPause()
signal debugFrameAdvance()

var player1Wins = 0
var player2Wins = 0

func _input(event):
	if event.is_action_pressed("mainmenu"):
		get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
		
	#if get_tree().paused == false and nextFrame == true:
		#get_tree().paused = true

	#if Input.is_action_just_pressed("pause"):
		#if get_tree().paused == false:
			#get_tree().paused = true
		#elif get_tree().paused == true:
			#nextFrame = false
			#get_tree().paused = false
	#
	#if get_tree().paused == true and Input.is_action_just_pressed("frameAdvance"):
		#nextFrame = true
		#get_tree().paused = false
		#print("next frame")
#
#var nextFrame = false

