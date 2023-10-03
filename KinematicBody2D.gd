extends CharacterBody2D

var directionX = 0
var facing = 1
var crouching = false
var gravity = 50
var terminalVelocity = 888

var strength = -1000
var attacking = false

#states
var action = "Neutral"
var neutral = "idle"
var attack = "LP"

#attacks
var LP = 0
var MP = 0
var HP = 0
var LK = 0
var MK = 0
var HK = 0

var speed = 500;

@onready var animatedSprite = $AnimatedSprite2D
@onready var animatedPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var animatedTree : AnimationTree = $AnimatedSprite2D/AnimationTree

#animationTree
@onready var A_action = "parameters/Action/transition_request"
@onready var A_attacking = "parameters/Attacking/transition_request"
@onready var A_neutral = "parameters/Neutral/transition_request"

# Called when the node enters the scene tree for the first time.
func _ready():
	setAnimation()
	
func _physics_process(delta):
	gravity_fall()
	readInput()
	if !attacking:
		isAttacking()
	
	jump()
	walk()
		
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	
	setAnimation()
	flip()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gravity_fall():
	velocity.y += gravity
	
	if velocity.y > terminalVelocity:
		velocity.y = terminalVelocity
	elif is_on_floor():
		velocity.y = 5
	pass

func isAttacking():
	action = "Neutral"
	if LP == 1:
		attack = "LP"
		attacking = 1
	if MP == 1: 
		attack = "MP"
		attacking = 1
	neutralAnimation()
	if attacking:
		action = "Attacking"
		return
	attacking = 0

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
	print("finished")
	pass

func neutralAnimation():
	if is_on_floor():
		if crouching:
			neutral = "crouch"
		elif directionX == 0:
			neutral = "idle"
		else:
			neutral = "walk"
	pass
	
func flip():
	if is_on_floor() && !attacking:
		if directionX > 0:
			facing = -1
		elif directionX < 0:
			facing = 1
	animatedSprite.scale.x = facing

func walk():
	#apply movement
	directionX = Input.get_action_strength("6")-Input.get_action_strength("4")
	if is_on_floor() && !crouching: 
		velocity.x = abs(directionX*speed)*-facing
	else:
		if (velocity.x * -facing) > 0: 
			velocity.x -= (speed/10) * -facing
		else:
			velocity.x = 0

func jump():
	if Input.get_action_strength("8") > 0 and is_on_floor() and !attacking:
		velocity.y = +strength

func setAnimation():
#	print(LP)
	animatedTree.set(A_action, action)
	animatedTree.set(A_neutral, neutral)
	animatedTree.set(A_attacking, attack)
	
	pass
