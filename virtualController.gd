extends Node2D

#directions
var directionX = 0
var directionY = 0

#attacks
var LP = 0
var MP = 0
var HP = 0
var LK = 0
var MK = 0
var HK = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	directionX = Input.get_action_strength("6")-Input.get_action_strength("4")
	directionY = Input.get_action_strength("2")-Input.get_action_strength("8")
	
	readButtons()

func readButtons():
	if Input.get_action_strength("LP") > 0:
		LP += 1
	else:
		LP = 0
		
	if Input.get_action_strength("MP") > 0:
		MP += 1
	else:
		MP = 0
		
	if Input.get_action_strength("HP") > 0 && HP < 3:
		HP += 1
	elif HP > 0:
		HP = HP - 1
		
	if Input.get_action_strength("LK") > 0:
		LK += 1
	else:
		LK = 0
		
	if Input.get_action_strength("MK") > 0:
		MK += 1
	else:
		MK = 0
		
	if Input.get_action_strength("HK") > 0:
		HK += 1
	else:
		HK = 0
	
