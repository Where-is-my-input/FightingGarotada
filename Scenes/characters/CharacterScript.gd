extends CharacterBody2D
class_name CharacterScript
#D:\Games\Game Dev sprites
var crouching = false
var gravity = 50
var terminalVelocity = 888
var maxSpeed = 500
var deceleration = 150
var knockback = 0
var knockbackVector:Vector2 = Vector2(1,1)

var motionForward = [Vector2(0,1), Vector2(1,1), Vector2(1,0)]
var motionBackwards = [Vector2(0,1), Vector2(-1,1), Vector2(-1,0)]
var motionDash = [Vector2(0,0), Vector2(1,0), Vector2(0,0), Vector2(1,0)]
var motionBackdash = [Vector2(0,0), Vector2(-1,0), Vector2(0,0), Vector2(-1,0)]

var facing = 1
var grounded = true
var knockdown = false
var beingGrabbed = false
var grabbedPlayer = null
var jumpStartUp = false
var dashing = false
var jumping = false
#var airborne = false

const strength = -900
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
var jumpDirectionState = "neutral"

#cancel states
var normalCancel = false
@export var jumpCancel = false
var specialCancel = true
var superCancel = true
var gatlingPriority = 0
@export var disableGravity = false
@export var maxAirJumps = 1
@export var maxAirDashes = 1

@export var moveSpeed = Vector2(0,0)
var hitstun = 0
var verticalHitstun = 0
var hitstop = 0

@export var invulnerability = Global.invulnerability.NONE

var speed = 250;
var jumpSpeed = 200
var preservedJumpSpeed = jumpSpeed
var jumpDirection = 0
var airJumps = 0
var airDashes = 0

var airJumpLocked = false

@onready var parent = $".."
@export var animatedSprite:AnimatedSprite2D
@onready var hitboxes = $Hitboxes
@export var animatedTree:AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var collision_box = $CollisionBox
@onready var marker_2d = $anchorPoint/Marker2D
@onready var anchor_point = $anchorPoint
@onready var tmr_knockdown = $tmrKnockdown
@onready var collision_area = $collisionArea
@onready var grab_position = $grabPosition
@onready var hurtboxes = $Hurtboxes
@onready var animated_human: Node3D = $SubViewportContainer/SubViewport/AnimatedHuman
@onready var animationPlayer3D: AnimationPlayer = $SubViewportContainer/SubViewport/AnimatedHuman/AnimationPlayer

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
@onready var A_JumpDirection = "parameters/jumpDirection/transition_request"

#controller
@onready var virtualController = parent.virtualController

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.root_node = animatedSprite.get_path()
	global_position.y = Global.ground
	setAnimation()
	animatedTree.active = true
	parent.connect("KO",KO)

func _physics_process(_delta):
	blocking = parent.virtualController.directionX * parent.facing > 0
	lowBlock = parent.virtualController.directionY > 0
	
	if grabbedPlayer != null && !grabbedPlayer.setGrabbedGlobalPosition(grab_position.global_position): grabbedPlayer = null
	
	if parent.virtualController != null:
		if hitstop > 0:
			hitstop -= 1
			animatedTree.set(A_TimeScale, 0)
		else:
			animatedTree.set(A_TimeScale, 1)
			playerCollision()
			move_and_slide()
			flip()
			endHitstun()
			if !grounded && !disableGravity: gravity_fall()
			if !beingGrabbed: 
				walk()
			else:
				velocity.x = 0
			if (!attacking || normalCancel && action == "attacking" && parent.virtualController.buttonPressed()) && action != "hit":
				isAttacking()
			checkJump()
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
	attackPressed()
	neutralAnimation()
	if !jumpStartUp: 
		if attacking:
			if dashing && !jumping: velocity.x = 0
			action = "attacking"
			return
		attacking = 0
		action = "idle"

#TODO improve this
func attackPressed():
	if (checkActionPressed(parent.virtualController.LP, parent.virtualController.bufferedAction, "LP")):
		if specialCancel && parent.virtualController.checkMotionExecuted(motionForward, facing):
			setAttack("Special1", 1, 4)
		if checkActionPressed(parent.virtualController.LK, parent.virtualController.bufferedAction, "LK"):
			setAttack("Grab", 6, 4)
		if gatlingPriority < 1:
			setAttack("LP", 1, 0)
		return true
	if checkActionPressed(parent.virtualController.LK, parent.virtualController.bufferedAction, "LK"):
		if specialCancel && parent.virtualController.checkMotionExecuted(motionForward, facing):
			setAttack("Special2", 1, 4)
		if specialCancel && parent.virtualController.checkMotionExecuted(motionBackwards, facing):
			setAttack("Special5", 1, 4)
		if gatlingPriority < 2:
			setAttack("LK", 1, 1)
		#TODO Grab leniency
		#if attack == "LP":
			#setAttack("Grab", 6, 4)
		return true
	if checkActionPressed(parent.virtualController.MP, parent.virtualController.bufferedAction, "MP"):
		if gatlingPriority < 3: setAttack("MP", 2, 2)
		return true
	if checkActionPressed(parent.virtualController.MK, parent.virtualController.bufferedAction, "MK"):
		if specialCancel && parent.virtualController.checkMotionExecuted(motionForward, facing):
			setAttack("Special3", 1, 4)
			return true
		if  gatlingPriority < 2: 
			setAttack("MK", 2, 3)
			return true
	if checkActionPressed(parent.virtualController.HP, parent.virtualController.bufferedAction,"HP"):
		if gatlingPriority < 4: setAttack("HP", 3, 4)
		return true
	if checkActionPressed(parent.virtualController.HK, parent.virtualController.bufferedAction, "HK"):
		if specialCancel && parent.virtualController.checkMotionExecuted(motionForward, facing):
			setAttack("Special4", 1, 4)
		if gatlingPriority < 1: setAttack("HK", 3, 5)
		return true
	return false

func checkActionPressed(vcAction, bufferAction, act):
	return vcAction == 1 || bufferAction == act

func setAttack(atk, isAtk, gatling):
	attack = atk
	attacking = isAtk
	gatlingPriority = gatling

func animationFinished():
	jumpCancel = false
	dashing = false
	if grabbedPlayer != null: grabbedPlayer.release()
	beingGrabbed = false
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
			if dashing: animationFinished()
			dashing = false
			state = "crouching"
		elif parent.virtualController.directionX == 0 && !dashing:
			state = "standing"
			movement = "idle"
		elif !dashing:
			state = "standing"
			if parent.virtualController.directionX * facing > 0:
				movement = "walkback"
			else:
				movement = "walk"
		if parent.virtualController.checkMotionExecutedExcept(motionDash, Vector2(-1,0), facing, 5) && !dashing:
			dashing = true
			movement = "dash"
		elif parent.virtualController.checkMotionExecutedExcept(motionBackdash, Vector2(1,0), facing, 5) && !dashing:
			dashing = true
			movement = "backdash"
	
func flip():
	if grounded && !attacking && parent.facing != facing && !knockdown:
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
	if grounded && !crouching && !attacking && !jumpStartUp && !dashing: 
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

func checkJump():
	if action == "hit":
		return
	if parent.virtualController.directionY < 0 && (!attacking || jumpCancel) && !jumpStartUp:
		#grounded = false
		if grounded:
			jump()
		elif airJumps < maxAirJumps && !airJumpLocked:
			airJump()
	elif parent.virtualController.directionY >= 0:
		airJumpLocked = false
	if velocity.y > 0:
		jumpState = "falling"
	elif !jumpStartUp:
		jumpState = "rising"

func jump():
	airJumpLocked = true
	disableGravity = false
	gatlingPriority = 0
	state = "standing"
	action = "idle"
	jumpCancel = false
	movement = "jumpStartUp"
	jumpStartUp = true
	attacking = false
	jumpDirection = parent.virtualController.directionX
	if !dashing: 
		velocity.x = 0
		preservedJumpSpeed = 0
	else:
		preservedJumpSpeed = velocity.x
	return

func airJump():
	airJumps += 1
	attacking = false
	jumpDirection = parent.virtualController.directionX
	preservedJumpSpeed = 0
	velocity.x = 0
	startJump()

func startJump():
	jumpDirectionState = "neutral"
	if abs(jumpDirection) > 0:
		if jumpDirection == facing:
			jumpDirectionState = "backwards"
		#velocity.x = parent.virtualController.directionX*jumpSpeed #allow to change direction post start up
		if preservedJumpSpeed != 0:
			velocity.x = jumpDirection*abs(preservedJumpSpeed)
		else:
			velocity.x = jumpDirection*jumpSpeed
	#if jumpDirection != 0 && !grounded:
		#velocity.x = jumpDirection*jumpSpeed
	hitboxes.disableHitboxes()
	jumping = true
	state = "jumping"
	#animationPlayer3D.play("Jump")
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
	animatedTree.set(A_JumpDirection, jumpDirectionState)

#func _on_hitboxes_area_entered(hitbox):
	#if hitbox.get_parent() != self:
		#var hitParent = hitbox.get_parent()
		#if hitboxes.hitProperty == Global.hitType.GRAB:
			#if hitbox.is_in_group("CollisionBox"):
				#disableGravity = true
				#velocity = Vector2(0,0)
				#hitParent.defaultGetHitEffects(hitboxes)
				#hitbox.set_deferred("disabled", true)
				#hitbox.grabbed()
				#grabbedPlayer = hitParent
				#setAttack("Throw", 1, 4)
		#elif hitbox.is_in_group("Hurtboxes"):
			#hitParent.getHit(hitboxes)
			#hitbox.set_deferred("disabled", true)
			#hitstop = hitboxes.hitstop
			#normalCancel = true

func defaultGetHitEffects(hitbox):
	hitstop = hitbox.hitstop
	verticalHitstun = hitbox.vstun
	#hitbox.stunVector.x = hitbox.stunVector.x * parent.facing
	dashing = false
	knockbackVector = Vector2(hitbox.stunVector.x * parent.facing, hitbox.stunVector.y)
	velocity.x = 0
	velocity.y = 0
	hitboxes.disableHitboxes()
	hitbox.disableHitboxes() #change to priority system? Otherwise enable hitboxes every other frame for multihits
	action = "hit"

func getHit(hitbox):
	defaultGetHitEffects(hitbox)
	if hitbox.hitProperty == Global.hitType.NORMAL: 
		knockbackVector.y = 0
	if action == "hit":
		animatedTree.set_deferred("advance", -0.25)
		#animatedTree.advance(-0.25)
	if hitbox.attackType == Global.blockType.UNBLOCKABLE || beingGrabbed || attacking || hitstun > 0 && !isBlocking || !blocking || (blocking && (!lowBlock && hitbox.attackType == Global.blockType.LOW)) || (blocking && (lowBlock && hitbox.attackType == Global.blockType.HIGH)):
		if hitbox.hitProperty == Global.hitType.KNOCKDOWN:
			#collision_area.set_deferred("disabled", true)
			#grounded = false
			tmr_knockdown.start(1)
			#disableGravity = true
			knockdown = true
			state = "knockdown"
			if knockdownState != "otg": knockdownState = "airborne"
		attacking = 0
		hitstun = 1 if hitbox.stun == 0 else hitbox.stun
		knockback = 35 * parent.facing
		hit = "hit"
		isBlocking = false
		parent.getHit(hitbox.damage)
	else:
		isBlocking = true
		if grounded:
			knockbackVector.y = 0
		knockback = 35 * parent.facing
		hitstun = hitbox.blockStun
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
		#if velocity.y > 0: checkGround()

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
	if body.is_in_group("ground") && !attacking:
		land()
	
func land():
	airJumps = 0
	airDashes = 0
	grounded = true
	jumping = false
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
		if velocity.y > 0:
			land()
		else:
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

func grabbed():
	beingGrabbed = true

func release():
	beingGrabbed = false

func _on_tmr_knockdown_timeout():
	if grounded:
		land()

func KO():
	tmr_knockdown.start(1)
	state = "knockdown"
	if knockdownState != "otg": knockdownState = "airborne"
	knockdown = true
	action = "hit"
	setAnimation()

func setGrabbedGlobalPosition(p):
	if beingGrabbed:
		global_position = p
		return true
	return false

func getCollisionArea():
	return collision_area

func getHurtBoxes():
	return hurtboxes

func getHitBoxes():
	return hitboxes

func getState():
	return state

func save_state() -> Dictionary:
	return {
		"global_position": global_position,
		"velocity": velocity,
		"facing": facing,
		"grounded": grounded,
		"knockdown": knockdown,
		"beingGrabbed": beingGrabbed,
		"grabbedPlayer": grabbedPlayer,
		"jumpStartUp": jumpStartUp,
		"dashing": dashing,
		"jumping": jumping,
		"attacking": attacking,
		"blocking": blocking,
		"lowBlock": lowBlock,
		"isBlocking": isBlocking,
		"state": state,
		"action": action,
		"movement": movement,
		"attack": attack,
		"jumpState": jumpState,
		"hit": hit,
		"idleState": idleState,
		"knockdownState": knockdownState,
		"jumpDirectionState": jumpDirectionState,
		"normalCancel": normalCancel,
		"jumpCancel": jumpCancel,
		"specialCancel": specialCancel,
		"superCancel": superCancel,
		"gatlingPriority": gatlingPriority,
		"disableGravity": disableGravity,
		"moveSpeed": moveSpeed,
		"hitstun": hitstun,
		"verticalHitstun": verticalHitstun,
		"hitstop": hitstop,
		"invulnerability": invulnerability,
		"speed": speed,
		"jumpSpeed": jumpSpeed,
		"preservedJumpSpeed": preservedJumpSpeed,
		"jumpDirection": jumpDirection,
		"airJumps": airJumps,
		"airDashes": airDashes,
		"airJumpLocked": airJumpLocked,
		"crouching": crouching,
		"knockback": knockback,
		"knockbackVector": knockbackVector,
	}

func load_state(state: Dictionary) -> void:
	global_position = state["global_position"]
	velocity = state["velocity"]
	facing = state["facing"]
	grounded = state["grounded"]
	knockdown = state["knockdown"]
	beingGrabbed = state["beingGrabbed"]
	grabbedPlayer = state["grabbedPlayer"]
	jumpStartUp = state["jumpStartUp"]
	dashing = state["dashing"]
	jumping = state["jumping"]
	attacking = state["attacking"]
	blocking = state["blocking"]
	lowBlock = state["lowBlock"]
	isBlocking = state["isBlocking"]
	state = state["state"]
	action = state["action"]
	movement = state["movement"]
	attack = state["attack"]
	jumpState = state["jumpState"]
	hit = state["hit"]
	idleState = state["idleState"]
	knockdownState = state["knockdownState"]
	jumpDirectionState = state["jumpDirectionState"]
	normalCancel = state["normalCancel"]
	jumpCancel = state["jumpCancel"]
	specialCancel = state["specialCancel"]
	superCancel = state["superCancel"]
	gatlingPriority = state["gatlingPriority"]
	disableGravity = state["disableGravity"]
	moveSpeed = state["moveSpeed"]
	hitstun = state["hitstun"]
	verticalHitstun = state["verticalHitstun"]
	hitstop = state["hitstop"]
	invulnerability = state["invulnerability"]
	speed = state["speed"]
	jumpSpeed = state["jumpSpeed"]
	preservedJumpSpeed = state["preservedJumpSpeed"]
	jumpDirection = state["jumpDirection"]
	airJumps = state["airJumps"]
	airDashes = state["airDashes"]
	airJumpLocked = state["airJumpLocked"]
	crouching = state["crouching"]
	knockback = state["knockback"]
	knockbackVector = state["knockbackVector"]
