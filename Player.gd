extends Node2D

@onready var animation = $CharacterBody2D/AnimatedSprite2D/AnimationPlayer
@onready var body = $CharacterBody2D
@onready var virtualController = $"../VirtualController"
var teste = 1

func _physics_process(delta):
#	print(virtualController)
	pass
