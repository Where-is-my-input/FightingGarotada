extends Node2D

@export var player = 1

#directions
var directionX = 0
var directionY = 0

@onready var spr_lp = $VisualController/sprLP
@onready var spr_mp = $VisualController/sprMP
@onready var spr_hp = $VisualController/sprHP
@onready var spr_lk = $VisualController/sprLK
@onready var spr_mk = $VisualController/sprMK
@onready var spr_hk = $VisualController/sprHK
@onready var lbl_up = $VisualController/lblUp
@onready var lbl_down = $VisualController/lblDown
@onready var lbl_right = $VisualController/lblRight
@onready var lbl_left = $VisualController/lblLeft

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
	var child = self.get_child(1)
	if child != null && child.name == "Player2" || player == 2:
		setInputsP2()

func modulateSprite(sprite, value = 0.2):
	sprite.modulate.a = value + 0.2

func modulateVisualController():
	modulateSprite(spr_lp, LP)
	modulateSprite(spr_mp, MP)
	modulateSprite(spr_hp, HP)
	modulateSprite(spr_lk, LK)
	modulateSprite(spr_mk, MK)
	modulateSprite(spr_hk, HK)
	if directionX != 0:
		if directionX > 0:
			modulateSprite(lbl_right, 1)
		else:
			modulateSprite(lbl_left, 1)
	else:
		modulateSprite(lbl_left, 0)
		modulateSprite(lbl_right, 0)
	if directionY != 0:
		if directionY > 0:
			modulateSprite(lbl_down, 1)
		else:
			modulateSprite(lbl_up, 1)
	else:
		modulateSprite(lbl_down, 0)
		modulateSprite(lbl_up, 0)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	directionX = Input.get_action_strength(right)-Input.get_action_strength(left)
	directionY = Input.get_action_strength(down)-Input.get_action_strength(up)
	
	readButtons()
	modulateVisualController()

func readButtons():
	if Input.get_action_strength(inputLP) > 0:
		LP += 1
	else:
		LP = 0
		
	if Input.get_action_strength(inputMP) > 0:
		MP += 1
	else:
		MP = 0
		
	if Input.get_action_strength(inputHP) > 0:
		HP += 1
	else:
		HP = 0
		
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
