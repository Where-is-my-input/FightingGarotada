extends Node2D

@onready var animation = $CharacterBody2D/AnimatedSprite2D/AnimationPlayer
@onready var body = $CharacterBody2D
#@onready var virtualController = $"../VirtualController"
#var teste = 1
var virtualController
var HP = 100
var playerGroup
var nearestPlayer
var facing = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	virtualController = get_parent()
#	if virtualController.name != "VirtualController":
#		virtualController = null
	pass

func _physics_process(delta):
	playerGroup = get_tree().get_nodes_in_group("Player")
	for player in playerGroup:
		if nearestPlayer == null:
			nearestPlayer = player
		elif player.global_position.distance_to(self.global_position) < nearestPlayer.global_position.distance_to(self.global_position):
				nearestPlayer = player
	print(nearestPlayer.position.x)
	if nearestPlayer.position.x > self.position.x:
		facing = -1
	else:
		facing = 1
#	virtualController = get_parent()
#	if virtualController.name != "VirtualController":
#		virtualController = null
	pass
