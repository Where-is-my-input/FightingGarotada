extends Area2D

enum blockType {MID, LOW, HIGH}

var hitboxes;
@export var stun = 19
@export var stunVector:Vector2 = Vector2(1,-5)
@export var damage = 0
@export var attackType = blockType.MID
@export var hitstop = 7
@export var vstun = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	hitboxes = get_children()
	pass # Replace with function body.

func disableHitboxes():
	for box in hitboxes:
#		box.disabled = true
		box.set_deferred("disabled", true)
	pass

func enableHitboxes():
#	for box in hitboxes:
#		box.disabled = true
	pass
