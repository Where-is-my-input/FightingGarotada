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
# Called when the node enters the scene tree for the first time.
func _ready():
	hitboxes = get_children()

func disableHitboxes():
	for box in hitboxes:
		box.set_deferred("disabled", true)

func enableHitboxes():
	for box in hitboxes:
		box.set_deferred("disabled", false)
