extends CharacterBody2D

@export var gravity = 50
@export var vel = Vector2(250,-250)

func _ready():
	velocity = vel

func _physics_process(_delta):
	velocity.y += gravity
	move_and_slide()
