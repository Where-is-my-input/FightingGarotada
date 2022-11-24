extends KinematicBody2D

var directionX = 0
var facing = 1
var crouching = false
var gravity = 50
var terminalVelocity = 888

var strength = -1000
var attacking = false

#states
var action = 0
var neutral = 0
var attack = 0

#attacks
var LP = 0
var MP = 0
var HP = 0
var LK = 0
var MK = 0
var HK = 0

var velocity:Vector2
var speed = 500;

onready var animatedSprite = $AnimatedSprite
onready var animatedPlayer = $AnimatedSprite/AnimationPlayer
onready var animatedTree = $AnimatedSprite/AnimationTree

#animationTree
onready var A_action = "parameters/Action/current"
onready var A_attacking = "parameters/Attacking/current"
onready var A_neutral = "parameters/Neutral/current"

# Called when the node enters the scene tree for the first time.
func _ready():
	setAnimation()
	
func _physics_process(delta):
	gravity_fall()
	readInput()
	if !attacking:
		attacking = isAttacking()
	
	jump()
	walk()
		
	move_and_slide(velocity, Vector2.UP)
	
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
	if LP == 1:
#		if is_on_floor():
#			animatedPlayer.play("sLP")
		attack = 0
		print("Atacou ", HK)
		return 1
	if MP == 1: 
#		if is_on_floor():
#			animatedPlayer.play("sMP")
		attack = 1
		return 1
	neutralAnimation()
	return 0
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
#	neutralAnimation()
	pass

func neutralAnimation():
	if is_on_floor():
		if crouching:
			neutral = 2
		elif directionX == 0:
			neutral = 0
		else:
			neutral = 1
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
	if Input.is_action_just_pressed("8") and is_on_floor():
		velocity.y = +strength

func setAnimation():
	animatedTree[A_action] = attacking
	animatedTree[A_attacking] = attack
	animatedTree[A_neutral] = neutral
	pass
