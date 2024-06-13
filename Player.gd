extends Node2D
@onready var remote_transform_2d = $RemoteTransform2D
@onready var body = $charBody2D
@onready var hurtboxes = $charBody2D/Hurtboxes
@onready var hitboxes = $charBody2D/Hitboxes
@onready var collision_area = $charBody2D/collisionArea

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
	playerGroup = get_tree().get_nodes_in_group("Player")

func _physics_process(_delta):
	getNearesPlayer()
	flip()

func getNearesPlayer():
	for player in playerGroup:
		if player == self:
			continue
		if nearestPlayer == null:
			nearestPlayer = player
		elif player.global_position.distance_to(body.global_position) < nearestPlayer.global_position.distance_to(body.global_position):
			nearestPlayer = player
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
	return collision_area.getCollision()

func getShaderPar(p):
	return body.material.get(p)

func setShaderPar(p, v):
	body.material.set(p, v)

func setPalette(p):
	body.setPalette(p)
