extends CharacterBody2D

@export var gravity = 15
@export var velX = 450
@export var velY = -400

@onready var vel = Vector2(velX,velY)

var globalPos = global_position

func _ready():
	velocity = vel
	global_position = globalPos

func _physics_process(_delta):
	velocity.y += gravity
	move_and_slide()


func _on_hurtbox_body_exited(body):
	if body.is_in_group("ground"):
		queue_free()
