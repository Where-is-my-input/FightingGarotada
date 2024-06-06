extends Camera2D

@onready var player_1 = $"../VirtualController/Player"
@onready var player_2 = $"../VirtualController2/Player2"


func _process(_delta):
	var target_pos = (player_1.getGlobalPos() + player_2.getGlobalPos()) * 0.5
	global_position = target_pos
