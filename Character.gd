extends CharacterBody2D

var directionX = 0
var directionY
var facing = 1
var gravity = 50
var terminalVelocity = 888
var strength = -1000

var speed = 500;

@onready var animatedSprite = $sprJill
@onready var body = $"."

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
func _physics_process(delta):
	#apply gravity
	velocity.y += gravity
	if velocity.y > terminalVelocity:
		velocity.y = terminalVelocity
	elif is_on_floor():
		velocity.y = 5

		#apply jump
	if Input.is_action_just_pressed("8") and is_on_floor():
		velocity.y = +strength
	
		#apply movement
	directionX = Input.get_action_strength("6")-Input.get_action_strength("4")
	if is_on_floor(): velocity.x = directionX*speed
	
	#apply movement
#	directionY = Input.get_action_strength("8")
#	velocity.y = directionY*speed
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
#	animatedSprite.scale.x = 1
	if is_on_floor():
		if directionX > 0:
			animatedSprite.play("6")
			facing = -1
		elif directionX < 0:
			animatedSprite.play("6")
			facing = 1
		else:
			animatedSprite.play("default")
	else:
		animatedSprite.play("8")
#	elif directionY == 0:
#		if facing == 0:
#			animatedSprite.play("default_down")
#		else:
#			animatedSprite.play("default_up")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
