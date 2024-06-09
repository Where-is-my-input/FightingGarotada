extends CharacterBody2D
#D:\Games\Game Dev sprites
var crouching = false
var gravity = 50
var terminalVelocity = 888
var maxSpeed = 500
var deceleration = 150
var knockback = 0
var knockbackVector:Vector2 = Vector2(1,1)

var motionForward = [Vector2(0,1), Vector2(1,1), Vector2(1,0)]
var motionBackwards = [Vector2(1,0), Vector2(1,1), Vector2(0,1)]

var facing = 1
var grounded = true
var knockdown = false
var jumpStartUp = false
var jumping = false
#var airborne = false

var strength = -900
var attacking = false
var blocking = false
var lowBlock = false
var isBlocking = false

#states
var state = "standing"
var action = "idle"
var movement = "idle"
var attack = "LP"
var jumpState = "rising"
var hit = "hit"
var idleState = "idle"
var knockdownState = "airborne"

#cancel states
var normalCancel = false
@export var jumpCancel = false
var specialCancel = true
var superCancel = true
var gatlingPriority = 0
@export var disableGravity = false

@export var moveSpeed = Vector2(0,0)
var hitstun = 0
var verticalHitstun = 0
var hitstop = 0

var speed = 250;
var jumpSpeed = 200
var jumpDirection = 0

@onready var parent = $".."
@onready var animatedSprite = $AnimatedSprite2D
@onready var hitboxes = $AnimatedSprite2D/Hitboxes
@onready var animatedTree = $AnimatedSprite2D/AnimationPlayer/AnimationTree
@onready var collision_box = $CollisionBox
@onready var collision_area = $collisionArea
@onready var marker_2d = $anchorPoint/Marker2D
@onready var anchor_point = $anchorPoint
@onready var tmr_knockdown = $tmrKnockdown

#animationTree
@onready var A_State = "parameters/State/transition_request"
@onready var A_StandingAction = "parameters/StandingAction/transition_request"
@onready var A_CrouchingAction = "parameters/CrouchingAction/transition_request"
@onready var A_JumpingAction = "parameters/JumpingAction/transition_request"
@onready var A_Jump = "parameters/Jump/transition_request"
@onready var A_Movement = "parameters/Movement/transition_request"
@onready var A_Attacking = "parameters/Attacking/transition_request"
@onready var A_Hit = "parameters/Hit/transition_request"
@onready var A_JumpHit = "parameters/JumpHit/transition_request"
@onready var A_CrouchHit = "parameters/CrouchHit/transition_request"
@onready var A_JumpAttacking = "parameters/JumpAttacking/transition_request"
@onready var A_CrouchAttacking = "parameters/CrouchAttacking/transition_request"
@onready var A_IdleState = "parameters/IdleState/transition_request"
@onready var A_TimeScale = "parameters/TimeScale/scale"
@onready var A_KnockDownAction = "parameters/knockDownAction/transition_request"
#controller
@onready var virtualController = parent.virtualController

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.y = Global.ground
	if randi_range(0,100) > 50:
		var palette = load("res://Characters/Jill Valentine/4by4Palette.jpg")
		material.set_shader_parameter("palette",palette)
	setAnimation()
	animatedTree.active = true

func _physics_process(_delta):
	blocking = parent.virtualController.directionX * parent.facing > 0
	lowBlock = parent.virtualController.directionY > 0
	
	if parent.virtualController != null:
		if hitstop > 0:
			hitstop -= 1
			animatedTree.set(A_TimeScale, 0)
			#return
		else:
			animatedTree.set(A_TimeScale, 1)
			playerCollision()
			move_and_slide()
			flip()
			endHitstun()
			if !grounded && !disableGravity: gravity_fall()
			walk()
			if (!attacking || normalCancel && action == "attacking" && buttonPressed()) && action != "hit":
				isAttacking()
			jump()
			setAnimation()

func playerCollision():
	var overlappingPlayer = collision_area.get_overlapping_areas()
	if !overlappingPlayer: return
	overlappingPlayer = overlappingPlayer[0]
	var collision = overlappingPlayer.getCollider()
	if collision.is_in_group("CollisionBox"):
		var pushDirection = 1
		if global_position.x < collision.global_position.x:
			pushDirection = -1
		var distance = getHurtBoxSizeX() / 2 + collision.shape.size.x / 2 - abs(global_position.x - collision.global_position.x)
		if grounded != overlappingPlayer.isGrounded() && velocity.y > -1:
			global_position.x += pushDirection * (distance / 8)
			overlappingPlayer.setPlayerGlobalPosition(-pushDirection * (distance / 2), 0)
			velocity.x = 0
			jumpDirection = 0
		elif grounded == overlappingPlayer.isGrounded():
			distance = abs(global_position.x - collision.global_position.x)
			var push = pushDirection * ((speed / 2) * (1 / distance))
			if velocity.x > 0 && !disableGravity: velocity.x = speed/8
			global_position.x += push
			#print(velocity)
		#move_and_slide()

func gravity_fall():
	if action == "hit" && verticalHitstun > 0:
		verticalHitstun -= 1
		if verticalHitstun <= 0: velocity.y = 0
		return
	velocity.y += gravity
	
	if verticalHitstun > 0:
		verticalHitstun -= 1
	#elif velocity.y < 0 && action == "hit":
		#velocity.y = 0
	
	if velocity.y > terminalVelocity:
		if action == "hit":
			velocity.y = terminalVelocity / 2
		else:
			velocity.y = terminalVelocity
	elif grounded:
		velocity.y = 5
	if jumping && grounded && !jumpStartUp:
		jumping = false
		state = "standing"
		action = "idle"
		animationFinished()

func isAttacking():
	buttonPressed()
	neutralAnimation()
	if !jumpStartUp: 
		if attacking:
			action = "attacking"
			return
		attacking = 0
		action = "idle"

func buttonPressed():
	if (parent.virtualController.LP == 1 || parent.virtualController.bufferedAction == "LP"):
		if specialCancel && parent.virtualController.checkMotionExecuted(motionForward, facing):
			setAttack("Special1", 1, 4)
		if gatlingPriority < 1:
			setAttack("LP", 1, 1)
		return true
	if (parent.virtualController.MP == 1 || parent.virtualController.bufferedAction == "MP") && gatlingPriority < 2:
		setAttack("MP", 2, 2)
		return true
	if (parent.virtualController.HP == 1 || parent.virtualController.bufferedAction == "HP") && gatlingPriority < 3:
		setAttack("HP", 3, 3)
		return true
	if (parent.virtualController.LK == 1 || parent.virtualController.bufferedAction == "LK") && gatlingPriority < 1:
		setAttack("LK", 1, 1)
		if specialCancel && parent.virtualController.checkMotionExecuted(motionForward, facing):
			setAttack("Special2", 1, 4)
		return true
	if (parent.virtualController.MK == 1 || parent.virtualController.bufferedAction == "MK") && gatlingPriority < 2:
		setAttack("MK", 2, 2)
		return true
	if (parent.virtualController.HK == 1 || parent.virtualController.bufferedAction == "HK") && gatlingPriority < 3:
		setAttack("HK", 3, 3)
		return true
	return false

func setAttack(atk, isAtk, gatling):
	attack = atk
	attacking = isAtk
	gatlingPriority = gatling

func animationFinished():
	disableGravity = false
	jumpStartUp = false
	knockdown = false
	set_deferred("attacking", 0)
	if !(hitstun > 0): action = "idle"
	if grounded:
		state = "standing"
	else:
		state = "jumping"
	idleState = "idle"
	gatlingPriority = 0
	normalCancel = false

func neutralAnimation():
	if grounded && !jumpStartUp:
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
	if grounded && !attacking && parent.facing != facing:
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
		if !grounded && !knockdown:
			state = "jumping"
		return
	crouching = parent.virtualController.directionY > 0
#	if airborne:
#		return
	if grounded && !crouching && !attacking && !jumpStartUp: 
		velocity.x = parent.virtualController.directionX*speed
	elif abs(velocity.x) > 0 && state != "jumping" && !disableGravity:
		velocity.x = velocity.x - deceleration * (velocity.x/speed)
	elif state != "jumping" && !disableGravity:
		velocity.x = 0

func applyKnockback(knockbackApplied):
	velocity += knockbackVector
	knockbackVector = Vector2(0,0)
	if abs(knockback) > 0:
		velocity.x = velocity.x+knockbackApplied
		knockback = 0
	elif abs(velocity.x) > 0:
		velocity.x = velocity.x - 1 
	else:
		velocity.x = 0

func jump():
	if action == "hit":
		return
	if parent.virtualController.directionY < 0 && grounded && (!attacking || jumpCancel):
		#grounded = false
		gatlingPriority = 0
		state = "standing"
		action = "idle"
		jumpCancel = false
		movement = "jumpStartUp"
		jumpStartUp = true
		attacking = false
		jumpDirection = parent.virtualController.directionX
		velocity.x = 0
		return
	if velocity.y > 0:
		jumpState = "falling"
	elif !jumpStartUp:
		jumpState = "rising"

func startJump():
	if abs(jumpDirection) > 0:
		#velocity.x = parent.virtualController.directionX*jumpSpeed #allow to change direction post start up
		velocity.x = jumpDirection*jumpSpeed
	if jumpDirection != 0 && !grounded:
		velocity.x = jumpDirection*jumpSpeed
	hitboxes.disableHitboxes()
	jumping = true
	state = "jumping"
	grounded = false
	jumpState = "rising"
	velocity.y = +strength
	jumpStartUp = false

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
	animatedTree.set(A_CrouchHit, hit)
	animatedTree.set(A_JumpHit, hit)
	animatedTree.set(A_IdleState, idleState)
	animatedTree.set(A_KnockDownAction, knockdownState)

func _on_hitboxes_area_entered(hitbox):
	if hitbox.get_parent() != animatedSprite:
		hitbox.get_parent().get_parent().getHit(hitboxes)
		hitbox.set_deferred("disabled", true)
		hitstop = hitboxes.hitstop
		normalCancel = true
	
func getHit(hitbox):
	hitstop = hitbox.hitstop
	verticalHitstun = hitbox.vstun
	#hitbox.stunVector.x = hitbox.stunVector.x * parent.facing
	knockbackVector = Vector2(hitbox.stunVector.x * parent.facing, hitbox.stunVector.y)
	if hitbox.hitProperty == 0: 
		knockbackVector.y = 0
	elif hitbox.hitProperty == 2:
		#collision_area.set_deferred("disabled", true)
		#grounded = false
		tmr_knockdown.start(1)
		#disableGravity = true
		knockdown = true
		state = "knockdown"
		knockdownState = "airborne"
	if action == "hit":
		animatedTree.advance(-0.25)
	velocity.x = 0
	velocity.y = 0
	hitboxes.disableHitboxes()
	action = "hit"
	if hitstun > 0 && !isBlocking || !blocking || (blocking && (!lowBlock && hitbox.attackType == 1)) || (blocking && (lowBlock && hitbox.attackType == 2)):
		attacking = 0
		hitstun = hitbox.stun
		knockback = 35 * parent.facing
		hit = "hit"
		isBlocking = false
		parent.getHit(hitbox.damage)
	else:
		isBlocking = true
		if grounded:
			knockbackVector.y = 0
		knockback = 35 * parent.facing
		hitstun = hitbox.stun
		hit = "block"
	
func endHitstun():
	if hitstun == 0 && action == "hit":
		action = "idle"
		#hitboxes.enableHitboxes()
		parent.comboCounter = 0
		parent.comboDamage = 0
	elif hitstun > 0:
		if knockdown:
			hitstun = 1
			#if checkGround():
				#land()
		else:
			hitstun = hitstun - 1
		if velocity.y > 0: checkGround()

func checkGround():
	if anchor_point.global_position.y > Global.ground:
		velocity.y = 0
		global_position.y = Global.ground
		return true

func getHurtBoxSizeX():
	return collision_box.shape.size.x
	
func getHurtBoxSizeY():
	return collision_box.shape.size.y

func _on_anchor_point_body_entered(body):
	if body.is_in_group("ground"):
		land()
	
func land():
	grounded = true
	if knockdownState == "airborne": knockdownState = "otg"
	if !knockdown: 
		animationFinished()
	else:
		velocity.x = 0 #set to 0 for now, otherwise the dummy slides over the ground
	if anchor_point.global_position.y > Global.ground:
		velocity.y = 0
		global_position.y = Global.ground

func _on_anchor_point_body_exited(body):
	if body.is_in_group("ground"):
		grounded = false

#should it be a timer called in _on_anchor_point_body_entered?
#allow otg "recombo"
func wakeUp():
	if parent.HP > 0:
		velocity.x = 0
		#knockdown = false
		knockdownState = "wakeUp"

func setMoveVelocity():
	velocity = moveSpeed * facing * -1


func _on_tmr_knockdown_timeout():
	if grounded:
		land()
