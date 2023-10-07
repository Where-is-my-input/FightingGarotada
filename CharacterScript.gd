extends CharacterBody2D
#D:\Games\Game Dev sprites
var crouching = false
var gravity = 50
var terminalVelocity = 888
var knockback = 0

var strength = -1000
var attacking = false

#states
var action = "Neutral"
var neutral = "idle"
var attack = "LP"
var jumpState = "rising"

#cancel states
var normalCancel = false
var specialCancel = true
var superCancel = true

var hitstun = 0

var speed = 500;

@onready var parent = $".."
@onready var animatedSprite = $AnimatedSprite2D
@onready var animatedPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var animatedTree : AnimationTree = $AnimatedSprite2D/AnimationTree
@onready var hitboxes = $AnimatedSprite2D/Hitboxes
#animationTree
@onready var A_action = "parameters/Action/transition_request"
@onready var A_attacking = "parameters/Attacking/transition_request"
@onready var A_neutral = "parameters/Neutral/transition_request"
@onready var A_jump = "parameters/Jump/transition_request"
@onready var virtualController = parent.virtualController

# Called when the node enters the scene tree for the first time.
func _ready():
	setAnimation()
	animatedTree.active = true
	
func _physics_process(delta):
	endHitstun()
	gravity_fall()
	
	if parent.virtualController != null:
		if (!attacking || normalCancel && action == "Attacking") && action != "Hitstun":
			isAttacking()
		jump()
		walk()
		
	set_velocity(velocity)
#	set_up_direction(Vector2.UP)
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

func isAttacking():
	if parent.virtualController.LP == 1:
		attack = "LP"
		attacking = 1
	if parent.virtualController.MP == 1: 
		attack = "MP"
		attacking = 1
	if parent.virtualController.HP == 1: 
		attack = "HP"
		attacking = 1
	neutralAnimation()
	if attacking:
		action = "Attacking"
		return
	attacking = 0

func animationFinished():
	set_deferred("attacking", 0)
	action = "Neutral"
	normalCancel = false

func neutralAnimation():
	if is_on_floor():
		if crouching:
			neutral = "crouch"
		elif parent.virtualController.directionX == 0:
			neutral = "idle"
		else:
			neutral = "walk"
	
func flip():
	if is_on_floor() && !attacking:
		animatedSprite.scale.x = parent.facing

func walk():
	#apply movement
	if action == "Hitstun":
		if knockback > 0:
			velocity.x = velocity.x+knockback
			knockback = 0
		elif abs(velocity.x) > 0:
			velocity.x = velocity.x - 1 * parent.facing
		else:
			velocity.x = 0
		return
	crouching = parent.virtualController.directionY > 0
	if is_on_floor() && !crouching && !attacking: 
		velocity.x = parent.virtualController.directionX*speed
	elif abs(velocity.x) > 0 && neutral != "jumping":
		velocity.x = velocity.x - 150 * (velocity.x/speed)
	elif neutral != "jumping":
		velocity.x = 0
#	else:
#		if (velocity.x * -facing) > 0: 
#			velocity.x -= (speed/10) * -facing
#		else:
#			velocity.x = 0

func jump():
	if action == "Hitstun":
		return
	if parent.virtualController.directionY < 0 and is_on_floor() and !attacking:
		velocity.y = +strength
		neutral = "jumping"
	if velocity.y > 0:
		jumpState = "falling"
	else:
		jumpState = "rising"

func setAnimation():
	animatedTree.set(A_action, action)
	animatedTree.set(A_neutral, neutral)
	animatedTree.set(A_attacking, attack)
	animatedTree.set(A_jump, jumpState)

func _on_hitboxes_area_entered(hitbox):
	if hitbox.get_parent() != animatedSprite:
		hitbox.get_parent().get_parent().getHit()
		normalCancel = true
	
func getHit():
	if action == "Hitstun":
		#TODO loop hit animation
		print(animatedTree)
	hitboxes.disableHitboxes()
	action = "Hitstun"
	parent.HP = parent.HP - 10
	attacking = 0
	hitstun = 19
	knockback = 35 * parent.facing
	
func endHitstun():
	if hitstun == 0 && action == "Hitstun":
		action = "Neutral"
		hitboxes.enableHitboxes()
	elif hitstun > 0:
		hitstun = hitstun - 1
