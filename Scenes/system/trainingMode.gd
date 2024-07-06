extends Node

@onready var tmr_block = $CanvasLayer/tmrBlock
@onready var lbl_stun = $CanvasLayer/lblStun
@onready var lbl_stun_2 = $CanvasLayer/lblStun2
@onready var lb_frame_advantage = $CanvasLayer/lbFrameAdvantage
@onready var player = $"../VirtualController/Player"
@onready var player2 = $"../VirtualController2/Player2"
@onready var virtual_controller_2 = $"../VirtualController2"
@onready var hp_bars = $".."

var block = false
var frameAdvantage = 0

var hurtboxes:Array
var hurtboxesPointers:Array

func _ready():
	Global.connect("roundStarted", loadTraining)
	if Global.gameMode != Global.mode.TRAINING:
		queue_free()

func loadTraining():
	player2.connect("gotHit", player2GotHit)
	hp_bars.timerPause = true
	getHitHurtBoxes(player)
	getHitHurtBoxes(player2)

func _process(_delta):
	setLabel(player2.getStun(), lbl_stun_2)
	setLabel(player.getStun(), lbl_stun)
	checkFrameAdvantage()
	if block: holdBlock()
	alignHurtboxes()

func getHitHurtBoxes(p):
	var colBox = p.getCollisionBox()
	var colorNode = ColorRect.new()
	colorNode.color = Color.BLUE
	colorNode.self_modulate.a = 0.5
	add_child(colorNode)
	hurtboxes.push_back(colorNode)
	hurtboxesPointers.push_back(colBox)
	for i in p.getHurtboxes():
		var node = ColorRect.new()
		node.color = Color.LIME_GREEN
		node.self_modulate.a = 0.5
		#node.set_anchors_preset(Control.PRESET_CENTER, true)
		add_child(node)
		hurtboxes.push_back(node)
		hurtboxesPointers.push_back(i)
	for i in p.getHitboxes():
		var node = ColorRect.new()
		node.color = Color.RED
		node.self_modulate.a = 0.5
		add_child(node)
		hurtboxes.push_back(node)
		hurtboxesPointers.push_back(i)

func alignHurtboxes():
	for i in hurtboxes.size():
		if !(hurtboxesPointers[i] is CollisionShape2D):
			continue
			hurtboxes[i].visible = true
			hurtboxes[i].size = hurtboxesPointers[i].shape.size
			hurtboxes[i].global_position = Vector2(hurtboxesPointers[i].global_position.x - hurtboxes[i].size.x /2, hurtboxesPointers[i].global_position.y - hurtboxes[i].size.y/2)
		elif hurtboxesPointers[i].disabled == false:
			hurtboxes[i].visible = true
			hurtboxes[i].size = hurtboxesPointers[i].shape.size
			hurtboxes[i].global_position = Vector2(hurtboxesPointers[i].global_position.x - hurtboxes[i].size.x /2, hurtboxesPointers[i].global_position.y - hurtboxes[i].size.y/2)
		else:
			hurtboxes[i].visible = false

func player2GotHit():
	tmr_block.start(1)
	block = true

func holdBlock():
	virtual_controller_2.directionX = 1
	virtual_controller_2.directionY = 1

func checkFrameAdvantage():
	if !player.body.attacking && player2.body.hitstun > 0:
		frameAdvantage += 1
		return
	elif player.body.attacking && player2.body.hitstun == 0 && frameAdvantage <= 0:
		frameAdvantage -= 1
	else:
		if abs(frameAdvantage) > 0:
			setLabel(frameAdvantage, lb_frame_advantage)
		frameAdvantage = 0

func _on_tmr_block_timeout():
	player2.HP = 5000
	block = false

func setLabel(txt, lbl):
	lbl.text = str(txt)
