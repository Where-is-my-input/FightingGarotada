extends Node

@onready var virtual_controller_2 = $"../HPBars/VirtualController2"
@onready var player2 = $"../HPBars/VirtualController2/Player2"
@onready var tmr_block = $tmrBlock
@onready var player = $"../HPBars/VirtualController/Player"
@onready var lbl_stun = $lblStun
@onready var lbl_stun_2 = $lblStun2

var block = false

func _ready():
	if Global.gameMode != Global.mode.TRAINING:
		queue_free()
	player2.connect("gotHit", player2GotHit)

func player2GotHit():
	tmr_block.start(1)
	block = true

func holdBlock():
	virtual_controller_2.directionX = 1
	virtual_controller_2.directionY = 1

func _process(_delta):
	setLabel(player2.getStun(), player2.getGlobalPos(), lbl_stun_2)
	setLabel(player.getStun(), player.getGlobalPos(), lbl_stun)
	#if block: holdBlock()

func _on_tmr_block_timeout():
	player2.HP = 5000
	block = false

func setLabel(txt, pos, lbl):
	pos -= Vector2(20, -40)
	lbl.text = str(txt)
	lbl.global_position = pos
