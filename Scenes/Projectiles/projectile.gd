extends CharacterBody2D

@export var gravity = 15
@export var velX = 450
@export var velY = -400
@onready var vel = Vector2(velX,velY)
@onready var hitbox = $hitbox

var globalPos = global_position

func _ready():
	velocity = vel
	global_position = globalPos
	#setHitboxValues()

func _physics_process(_delta):
	velocity.y += gravity
	move_and_slide()

func _on_hurtbox_body_exited(body):
	if body.is_in_group("ground"):
		queue_free()

func setHitboxValues(Stun = 19, StunVector = Vector2(1,-5), Damage = 0, AttackType = Global.blockType.MID, Hitstop = 7, Vstun = 1, HitProperty = Global.hitType.PROJECTILE, Blockstun = 10):
	hitbox.stun = Stun
	hitbox.stunVector = StunVector
	hitbox.damage = Damage
	hitbox.attackType = AttackType
	hitbox.hitstop = Hitstop
	hitbox.vstun = Vstun
	hitbox.hitProperty = HitProperty
	hitbox.blockStun = Blockstun
