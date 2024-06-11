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
