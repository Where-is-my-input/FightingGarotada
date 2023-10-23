extends CharacterBody2D
#D:\Games\Game Dev sprites
var crouching = false
var gravity = 50
var terminalVelocity = 888
var knockback = 0
var knockbackVector:Vector2 = Vector2(1,1)

var facing = 1
#var airborne = false

var strength = -900
var attacking = false
var blocking = false

#states
var state = "standing"
var action = "idle"
var movement = "idle"
var attack = "LP"
var jumpState = "rising"
var hit = "hit"
var idleState = "idle"

#cancel states
var normalCancel = false
@export var jumpCancel = false
var specialCancel = true
var superCancel = true

var hitstun = 0
var verticalHitstun = 0

var speed = 500;

@onready var parent = $".."
@onready var animatedSprite = $AnimatedSprite2D
@onready var animatedPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var hitboxes = $AnimatedSprite2D/Hitboxes
@onready var animatedTree = $AnimatedSprite2D/AnimationPlayer/AnimationTree

#animationTree
@onready var A_State = "parameters/State/transition_request"
@onready var A_StandingAction = "parameters/StandingAction/transition_request"
@onready var A_CrouchingAction = "parameters/CrouchingAction/transition_request"
@onready var A_JumpingAction = "parameters/JumpingAction/transition_request"
@onready var A_Jump = "parameters/Jump/transition_request"
@onready var A_Movement = "parameters/Movement/transition_request"
@onready var A_Attacking = "parameters/Attacking/transition_request"
@onready var A_Hit = "parameters/Hit/transition_request"
@onready var A_JumpAttacking = "parameters/JumpAttacking/transition_request"
@onready var A_CrouchAttacking = "parameters/CrouchAttacking/transition_request"
@onready var A_IdleState = "parameters/IdleState/transition_request"
#controller
@onready var virtualController = parent.virtualController

# Called when the node enters the scene tree for the first time.
func _ready():
	setAnimation()
	animatedTree.active = true
	
func _physics_process(_delta):
	endHitstun()
	gravity_fall()
	
	if parent.virtualController != null:
		if (!attacking || normalCancel && action == "attacking") && action != "hit":
			isAttacking()
		jump()
		walk()
		
#	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
#	if move_and_slide():
#		if state == "jumping":
#			velocity.x = speed * facing
#		else:
#			for i in get_slide_collision_count():
#				var collision = get_slide_collision(i)
#				if collision.get_collider().name == "TileMap":
#					airborne = false
#				else:
#					velocity.y = 5000
#					velocity.x = 500 * facing
	flip()
	setAnimation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func gravity_fall():
	velocity.y += gravity
	
	if verticalHitstun > 0:
		verticalHitstun -= 1
	elif velocity.y < 0 && state == "hit":
		velocity.y = 0
	
	if velocity.y > terminalVelocity:
		if state == "hit":
			velocity.y = terminalVelocity / 2
		else:
			velocity.y = terminalVelocity
	elif is_on_floor():
		velocity.y = 5
	if state == "jumping" && is_on_floor():
		state = "standing"
		action = "idle"
		animationFinished()
		

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
		action = "attacking"
		return
	attacking = 0

func animationFinished():
	set_deferred("attacking", 0)
	action = "idle"
	idleState = "idle"
	normalCancel = false

func neutralAnimation():
	blocking = parent.virtualController.directionX * facing < 0
	if attacking:
		return
	if is_on_floor():
		if crouching:
			state = "crouching"
		elif parent.virtualController.directionX == 0:
			state = "standing"
			movement = "idle"
		else:
			state = "standing"
			if parent.virtualController.directionX * facing > 0:
				movement = "walkback"
			else:
				movement = "walk"
				
	
func flip():
	if is_on_floor() && !attacking && parent.facing != facing:
		idleState = "flip"
		scale.x = -1
		facing = parent.facing

func walk():
	#apply movement
	if action == "hit":
		if hit == "block":
			applyKnockback(knockback/2)
		else:
			applyKnockback(knockback)
		return
	crouching = parent.virtualController.directionY > 0
#	if airborne:
#		return
	if is_on_floor() && !crouching && !attacking: 
		velocity.x = parent.virtualController.directionX*speed
	elif abs(velocity.x) > 0 && state != "jumping":
		velocity.x = velocity.x - 150 * (velocity.x/speed)
	elif state != "jumping":
		velocity.x = 0

func applyKnockback(knockbackApplied):
	velocity = knockbackVector
	if abs(knockback) > 0:
		velocity.x = velocity.x+knockbackApplied
		knockback = 0
	elif abs(velocity.x) > 0:
		velocity.x = velocity.x - 1 
	else:
		velocity.x = 0
	return


func jump():
	if action == "hit":
		return
	if parent.virtualController.directionY < 0 && is_on_floor() && (!attacking || jumpCancel):
		velocity.y = +strength
		state = "jumping"
		action = "idle"
		jumpCancel = false
		jumpState = "rising"
		attacking = false
#		airborne = true
	if velocity.y > 0:
		jumpState = "falling"
	else:
		jumpState = "rising"

func setAnimation():
	animatedTree.set(A_State, state)
	animatedTree.set(A_StandingAction, action)
	animatedTree.set(A_CrouchingAction, action)
	animatedTree.set(A_JumpingAction, action)
	animatedTree.set(A_Jump, jumpState)
	animatedTree.set(A_Movement, movement)
	animatedTree.set(A_Attacking, attack)
	animatedTree.set(A_JumpAttacking, attack)
	animatedTree.set(A_CrouchAttacking, attack)
	animatedTree.set(A_Hit, hit)
	animatedTree.set(A_IdleState, idleState)

func _on_hitboxes_area_entered(hitbox):
	if hitbox.get_parent() != animatedSprite:
		hitbox.get_parent().get_parent().getHit(hitboxes.stun, hitboxes.stunVector)
		normalCancel = true
	
func getHit(stun = 19, hitVector = Vector2(100,-500), vstun = 60):
	verticalHitstun = vstun
	hitVector.x = hitVector.x * parent.facing
	knockbackVector = hitVector
	if action == "hit":
		animatedTree.advance(-0.25)
	hitboxes.disableHitboxes()
	action = "hit"
	velocity.x = 0
	velocity.y = 0
	if !blocking:
		parent.HP = parent.HP - 10
		attacking = 0
		hitstun = stun
		knockback = 35 * parent.facing
		hit = "hit"
	else:
		knockback = 35 * parent.facing
		hitstun = stun
		hit = "block"
	
func endHitstun():
	if hitstun == 0 && action == "hit":
		action = "idle"
		hitboxes.enableHitboxes()
	elif hitstun > 0:
		hitstun = hitstun - 1
