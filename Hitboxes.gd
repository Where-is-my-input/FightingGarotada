extends Area2D

var hitboxes;
# Called when the node enters the scene tree for the first time.
func _ready():
	hitboxes = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func disableHitboxes():
	for box in hitboxes:
#		box.disabled = true
		box.set_deferred("disabled", true)
	pass

func enableHitboxes():
#	for box in hitboxes:
#		box.disabled = true
	pass
