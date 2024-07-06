extends Node2D
@onready var remote_transform_2d = $RemoteTransform2D
#@onready var body = $charBody2D
#@onready var hurtboxes = $charBody2D/Hurtboxes
#@onready var hitboxes = $charBody2D/Hitboxes
#@onready var collision_area = $charBody2D/collisionArea

@export var body:CharacterBody2D
var collisionArea
var hurtboxes
var hitboxes

#@onready var virtualController = $"../VirtualController"
#var teste = 1
var virtualController
var HP = 5000
var playerGroup
var nearestPlayer
var facing = 1

signal gotHit()
signal KO()

var comboCounter = 0
var comboDamage = 0

var KOed = false

var nearestPlayerX = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	virtualController = get_parent()
	if virtualController.player == 1:
		addCharacter(Global.player1Character)
	else:
		addCharacter(Global.player2Character)
	playerGroup = get_tree().get_nodes_in_group("Player")

func addCharacter(playerCharacter):
		var chaBody = preload("res://Scenes/characters/Jill/jill.tscn").instantiate()
		match playerCharacter:
			Global.character.JILL:
				chaBody = preload("res://Scenes/characters/Jill/jill.tscn").instantiate()
			Global.character.LILITH:
				chaBody = preload("res://Scenes/characters/Lilith/lilith.tscn").instantiate()
			Global.character.MARROW:
				chaBody = preload("res://Scenes/characters/Marrow/marrow.tscn").instantiate()
			Global.character.SONSON:
				chaBody = preload("res://Scenes/characters/Sonson/sonson.tscn").instantiate()
		add_child(chaBody)
		setBodyVariables(chaBody)

func setBodyVariables(charBody):
	body = charBody
	collisionArea = body.getCollisionArea()
	hurtboxes = body.getHurtBoxes()
	hitboxes = body.getHitBoxes()

func _physics_process(_delta):
	getNearesPlayer()
	flip()

func getNearesPlayer():
	for player in playerGroup:
		if player == self:
			continue
		if nearestPlayer == null:
			nearestPlayer = player.body
		elif player.global_position.distance_to(body.global_position) < nearestPlayer.global_position.distance_to(body.global_position):
			nearestPlayer = player.body
	if nearestPlayer != null:
		var child = nearestPlayer.get_child(0)
		nearestPlayerX = child.global_position.x
			
func flip():
	#TODO flip facing the closest player
	if nearestPlayerX > body.global_position.x:
		facing = -1
	else:
		facing = 1
	
func getHit(damage = 20):
	comboCounter += 1
	damage = damage + comboCounter / comboCounter #simple scalling
	HP = HP - damage
	comboDamage += damage
	gotHit.emit()
	if HP <= 0 && !KOed:
		KOed = true
		KO.emit()

func setCamera(c):
	remote_transform_2d.remote_path = c
	#remote_transform_2d.force_update_cache()

func getGlobalPos():
	return body.global_position

func getStun():
	return body.hitstun

func getHurtboxes():
	return hurtboxes.get_children()
	
func getHitboxes():
	return hitboxes.get_children()

func getCollisionBox():
	return collisionArea.getCollision()

func getShaderPar(p):
	return body.material.get(p)

func setShaderPar(p, v):
	body.material.set(p, v)

func setPalette(p):
	body.setPalette(p)

func saveState():
	var save = PlayerState.new()
	save.bodyGlobalPositionX = body.global_position.x
	save.bodyGlobalPositionY = body.global_position.y
	save.HP = HP
	return save

func loadState(state):
	HP = state.HP
	body.global_position.x = state.bodyGlobalPositionX
	body.global_position.y = state.bodyGlobalPositionY

func saveStateArray():
	#brute forcing save stating cause I'm stupid
	var animation = [body.animation_player.current_animation, body.animation_player.current_animation_position]
	var animationStates = [body.state, body.action, body.jumpState, body.movement, body.attack, body.hit, body.idleState, body.knockdownState]
	var bodyVars = [body.facing, body.grounded, body.knockdown, body.beingGrabbed, 
	body.grabbedPlayer, body.jumpStartUp, body.dashing, body.jumping]
	var bodyVars2 = [body.attacking, body.blocking, body.lowBlock, body.isBlocking]
	var cancels = [body.normalCancel, body.jumpCancel, body.specialCancel, body.superCancel, body.gatlingPriority, body.disableGravity]
	var bodyVars3 = [body.moveSpeed, body.hitstun, body.verticalHitstun, body.hitstop]
	var speeds = [body.speed, body.jumpSpeed, body.preservedJumpSpeed, body.jumpDirection]
	return [HP, body.global_position.x, body.global_position.y] + animation + animationStates + bodyVars + [body.velocity.x, body.velocity.y] + bodyVars2 + cancels + bodyVars3 + speeds
	
func loadStateArray(state):
	HP = state[0]
	body.global_position.x = state[1]
	body.global_position.y = state[2]
	body.state = state[5]
	body.action = state[6]
	body.jumpState = state[7]
	body.movement = state[8]
	body.attack = state[9]
	body.hit = state[10]
	body.idleState = state[11]
	body.knockdownState = state[12]
	body.animation_player.current_animation = state[3]
	body.facing = state[13]
	body.grounded = state[14]
	body.knockdown = state[15]
	body.beingGrabbed = state[16] 
	body.grabbedPlayer = state[17] 
	body.jumpStartUp = state[18] 
	body.dashing = state[19]
	body.jumping = state[20]
	body.velocity.x = state[21]
	body.velocity.y = state[22]
	body.attacking = state[23]
	body.blocking = state[24]
	body.lowBlock = state[25] 
	body.isBlocking = state[26]
	body.normalCancel = state[27]
	body.jumpCancel = state[28] 
	body.specialCancel = state[29]
	body.superCancel = state[30] 
	body.gatlingPriority = state[31] 
	body.disableGravity = state[32]
	body.moveSpeed = state[33] 
	body.hitstun = state[34] 
	body.verticalHitstun = state[35] 
	body.hitstop = state[36]
	body.speed = state[37]
	body.jumpSpeed = state[38]
	body.preservedJumpSpeed = state[39]
	body.jumpDirection = state[40]
	body.setAnimation()
	body.animation_player.seek(state[4], true, true)
	
