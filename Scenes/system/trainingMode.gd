extends Node

@onready var tmr_block = $CanvasLayer/tmrBlock
@onready var lbl_stun = $CanvasLayer/lblStun
@onready var lbl_stun_2 = $CanvasLayer/lblStun2
@onready var lb_frame_advantage = $CanvasLayer/lbFrameAdvantage
@onready var player = $"../VirtualController/Player"
@onready var player2 = $"../VirtualController2/Player2"
@onready var virtual_controller_2 = $"../VirtualController2"
@onready var hp_bars = $".."
@onready var p_1_state: Label = $CanvasLayer/states/p1States/p1state
@onready var p_1_knockdown: Label = $CanvasLayer/states/p1States/p1Knockdown
@onready var p_1_grounded: Label = $CanvasLayer/states/p1States/p1Grounded
@onready var p_1_facing: Label = $CanvasLayer/states/p1States/p1Facing
@onready var p_1_being_grabed: Label = $CanvasLayer/states/p1States/p1BeingGrabed
@onready var p_1_jump_start_up: Label = $CanvasLayer/states/p1States/p1JumpStartUp
@onready var p_1_dashing: Label = $CanvasLayer/states/p1States/p1Dashing
@onready var p_1_jumping: Label = $CanvasLayer/states/p1States/p1Jumping
@onready var p_2_state: Label = $CanvasLayer/states/p2States/p2state
@onready var p_2_knockdown: Label = $CanvasLayer/states/p2States/p2Knockdown
@onready var p_2_grounded: Label = $CanvasLayer/states/p2States/p2Grounded
@onready var p_2_facing: Label = $CanvasLayer/states/p2States/p2Facing
@onready var p_2_being_grabed: Label = $CanvasLayer/states/p2States/p2BeingGrabed
@onready var p_2_jump_startup: Label = $CanvasLayer/states/p2States/p2JumpStartup
@onready var p_2_dashing: Label = $CanvasLayer/states/p2States/p2Dashing
@onready var p_2_jumping: Label = $CanvasLayer/states/p2States/p2Jumping

#var facing = 1
#var grounded = true
#var knockdown = false
#var beingGrabbed = false
#var grabbedPlayer = null
#var jumpStartUp = false
#var dashing = false
#var jumping = false

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
	setLabel(player.getState(), p_1_state)
	setLabel(player2.getState(), p_2_state)
	setLabel(player.body.knockdown, p_1_knockdown, "Knockdown")
	setLabel(player.body.grounded, p_1_grounded, "grounded")
	setLabel(player.body.beingGrabbed, p_1_being_grabed, "beingGrabbed")
	#setLabel(player.body.grabbedPlayer, p_1_GrabbedPlayer, "grabbedPlayer")
	setLabel(player.body.jumpStartUp, p_1_jump_start_up, "jumpStartUp")
	setLabel(player.body.dashing, p_1_dashing, "dashing")
	setLabel(player.body.jumping, p_1_jumping, "jumping")
	setLabel(player.body.facing, p_1_facing, "facing")
	setLabel(player2.body.knockdown, p_2_knockdown, "Knockdown")
	setLabel(player2.body.grounded, p_2_grounded, "grounded")
	setLabel(player2.body.beingGrabbed, p_2_being_grabed, "beingGrabbed")
	#setLabel(player.body.grabbedPlayer, p_1_GrabbedPlayer, "grabbedPlayer")
	setLabel(player2.body.jumpStartUp, p_2_jump_startup, "jumpStartUp")
	setLabel(player2.body.dashing, p_2_dashing, "dashing")
	setLabel(player2.body.jumping, p_2_jumping, "jumping")
	setLabel(player2.body.facing, p_2_facing, "facing")
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

func setLabel(txt, lbl, variable = ""):
	lbl.text = variable + " " + str(txt)
