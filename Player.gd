extends Node2D

@onready var body = $CharacterBody2D
#@onready var virtualController = $"../VirtualController"
#var teste = 1
var virtualController
var HP = 100
var playerGroup
var nearestPlayer
var facing = 1

var nearestPlayerX = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	virtualController = get_parent()
	playerGroup = get_tree().get_nodes_in_group("Player")
	pass

func _physics_process(_delta):
	getNearesPlayer()
	flip()
	pass

func getNearesPlayer():
	for player in playerGroup:
		if player == self:
			continue
		if nearestPlayer == null:
			nearestPlayer = player
		elif player.global_position.distance_to(body.global_position) < nearestPlayer.global_position.distance_to(body.global_position):
			nearestPlayer = player
	if nearestPlayer != null:
		var child = nearestPlayer.get_child(0)
		nearestPlayerX = child.global_position.x
			
func flip():
	#TODO flip facing the closest player
	if nearestPlayerX > body.global_position.x:
		facing = -1
	else:
		facing = 1
	
