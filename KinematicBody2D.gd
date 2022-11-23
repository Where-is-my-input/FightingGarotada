extends KinematicBody2D

var directionX = 0
var directionY
var facing = 1
var crouching = false
var gravity = 50
var terminalVelocity = 888

var strength = -1000
var attacking = false
var LP = 0
var MP = 0

var velocity:Vector2
var speed = 500;

onready var animatedSprite = $AnimatedSprite
onready var animatedPlayer = $AnimatedSprite/AnimationPlayer
#onready var position2D = $Position2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	animatedPlayer.play("Idle")
	pass
func _physics_process(delta):
	print(crouching)
	gravity()
	readInput()
	if !attacking: attacking = isAttacking()
	
		#apply jump
	if Input.is_action_just_pressed("8") and is_on_floor():
		velocity.y = +strength
	
		#apply movement
	directionX = Input.get_action_strength("6")-Input.get_action_strength("4")
	if is_on_floor(): velocity.x = directionX*speed
	
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() && !attacking:
		if directionX > 0:
			facing = -1
		elif directionX < 0:
			facing = 1
			
	animatedSprite.scale.x = facing
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gravity():
	velocity.y += gravity
	
	if velocity.y > terminalVelocity:
		velocity.y = terminalVelocity
	elif is_on_floor():
		velocity.y = 5
	pass

func isAttacking():
	if LP == 1:
		if is_on_floor():
			animatedPlayer.play("sLP")
		return true
	if MP == 1:
		if is_on_floor():
			animatedPlayer.play("sMP")
		return true
	neutralAnimation()
	return false
	pass

func readInput():
	crouching = Input.get_action_strength("2")
	if Input.get_action_strength("LP") > 0: 
		LP += Input.get_action_strength("LP")
	else:
		LP = 0
		
	if Input.get_action_strength("MP") > 0: 
		MP += Input.get_action_strength("MP")
	else:
		MP = 0
		
	pass

func animationFinished():
	attacking = 0
	neutralAnimation()
	pass

func neutralAnimation():
	if is_on_floor():
		if directionX == 0:
			if crouching:
				animatedPlayer.play("crouch")
			else:
				animatedPlayer.play("Idle")
		else:
			animatedPlayer.play("WalkForward")
	pass
	
