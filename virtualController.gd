extends Node2D

#directions
var directionX = 0
var directionY = 0

#inputs
var inputLP = "LP"
var inputMP = "MP"
var inputHP = "HP"
var inputLK = "LK"
var inputMK = "MK"
var inputHK = "HK"

var up = "8"
var down = "2"
var left = "4"
var right = "6"

#attacks
var LP = 0
var MP = 0
var HP = 0
var LK = 0
var MK = 0
var HK = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var child = self.get_child(0)
	if child.name == "Player2":
		setInputsP2()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	directionX = Input.get_action_strength(right)-Input.get_action_strength(left)
	directionY = Input.get_action_strength(down)-Input.get_action_strength(up)
	
	readButtons()

func readButtons():
	if Input.get_action_strength(inputLP) > 0:
		LP += 1
	else:
		LP = 0
		
	if Input.get_action_strength(inputMP) > 0:
		MP += 1
	else:
		MP = 0
		
	if Input.get_action_strength(inputHP) > 0 && HP < 3:
		HP += 1
	elif HP > 0:
		HP = HP - 1
		
	if Input.get_action_strength(inputLK) > 0:
		LK += 1
	else:
		LK = 0
		
	if Input.get_action_strength(inputMK) > 0:
		MK += 1
	else:
		MK = 0
		
	if Input.get_action_strength(inputHK) > 0:
		HK += 1
	else:
		HK = 0
	
func setInputsP2():
	inputLP = "p2LP"
	inputMP = "p2MP"
	inputHP = "p2HP"
	inputLK = "p2LK"
	inputMK = "p2MK"
	inputHK = "p2HK"

	up = "p2_8"
	down = "p2_2"
	left = "p2_4"
	right = "p2_6"
