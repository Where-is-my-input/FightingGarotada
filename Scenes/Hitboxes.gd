extends Area2D

var hitboxes;
@export var stun = 19
@export var stunVector:Vector2 = Vector2(1,-5)
@export var damage = 0
@export var attackType = Global.blockType.MID
@export var hitstop = 7
@export var vstun = 1
@export var hitProperty: Global.hitType = Global.hitType.NORMAL
@export var blockStun = 10
@onready var char_body_2d = $".."
@onready var shape_cast_2d = $ShapeCast2D
@onready var hitbox = $Hitbox

func _init(Stun = 19, StunVector = Vector2(1,-5), Damage = 0, AttackType = Global.blockType.MID, Hitstop = 7, Vstun = 1, HitProperty = Global.hitType.NORMAL, Blockstun = 10):
	stun = Stun
	stunVector = StunVector
	damage = Damage
	attackType = AttackType
	hitstop = Hitstop
	vstun = Vstun
	hitProperty = HitProperty
	blockStun = Blockstun

func _ready():
	hitboxes = get_children()

func disableHitboxes():
	for box in hitboxes:
		box.set_deferred("disabled", true)

func enableHitboxes():
	for box in hitboxes:
		box.set_deferred("disabled", false)

func _on_area_entered(hitbox):
	if hitbox.get_parent() != char_body_2d:
		#shape_cast_2d.enabled = false
		var hitParent = hitbox.get_parent()
		if hitProperty == Global.hitType.GRAB:
			if hitbox.is_in_group("CollisionBox"):
				char_body_2d.disableGravity = true
				char_body_2d.velocity = Vector2(0,0)
				hitParent.defaultGetHitEffects(self)
				hitbox.set_deferred("disabled", true)
				hitbox.grabbed()
				char_body_2d.grabbedPlayer = hitParent
				char_body_2d.setAttack("Throw", 1, 4)
		elif hitbox.is_in_group("Hurtboxes"):
			hitParent.getHit(self)
			hitbox.set_deferred("disabled", true)
			if hitProperty != Global.hitType.PROJECTILE:
				char_body_2d.hitstop = hitstop
				char_body_2d.normalCancel = true
