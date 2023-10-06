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

#cancel states
var normalCancel = false
var specialCancel = true
var superCancel = true

#attacks
var LP = 0
var MP = 0
var HP = 0
var LK = 0
var MK = 0
var HK = 0

var hitstun = 0

var speed = 500;

@onready var animatedSprite = $AnimatedSprite2D
@onready var animatedPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var animatedTree : AnimationTree = $AnimatedSprite2D/AnimationTree
@onready var hitboxes = $AnimatedSprite2D/Hitboxes
#animationTree
@onready var A_action = "parameters/Action/transition_request"
@onready var A_attacking = "parameters/Attacking/transition_request"
@onready var A_neutral = "parameters/Neutral/transition_request"

# Called when the node enters the scene tree for the first time.
func _ready():
	setAnimation()
	animatedTree.active = true
	
func _physics_process(delta):
	endHitstun()
	gravity_fall()
	readInput()
	if (!attacking || normalCancel && action == "Attacking") && action != "Hitstun":
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
	if LP == 1:
		attack = "LP"
		attacking = 1
	if MP == 1: 
		attack = "MP"
		attacking = 1
	if HP == 1: 
		attack = "HP"
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
		
	if Input.get_action_strength("HP") > 0: 
		HP += Input.get_action_strength("HP")
	else:
		HP = 0
		
	pass

func animationFinished():
	set_deferred("attacking", 0)
	action = "Neutral"
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
	animatedTree.set(A_action, action)
	animatedTree.set(A_neutral, neutral)
	animatedTree.set(A_attacking, attack)
	pass

func _on_hitboxes_area_entered(hitbox):
	if hitbox.get_parent() != animatedSprite:
		hitbox.get_parent().get_parent().getHit()
		normalCancel = true
	pass # Replace with function body.
	
func getHit():
	hitboxes.disableHitboxes()
	action = "Hitstun"
	attacking = 0
	hitstun = 15
	pass
	
func endHitstun():
	if hitstun == 0 && action == "Hitstun":
		action = "Neutral"
		hitboxes.enableHitboxes()
	elif hitstun > 0:
		hitstun = hitstun - 1
