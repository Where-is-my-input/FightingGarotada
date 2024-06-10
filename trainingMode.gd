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

func _ready():
	if Global.gameMode != Global.mode.TRAINING:
		queue_free()
	else:
		player2.connect("gotHit", player2GotHit)
		hp_bars.timerPause = true

func player2GotHit():
	tmr_block.start(1)
	block = true

func holdBlock():
	virtual_controller_2.directionX = 1
	virtual_controller_2.directionY = 1

func _process(_delta):
	setLabel(player2.getStun(), lbl_stun_2)
	setLabel(player.getStun(), lbl_stun)
	checkFrameAdvantage()
	if block: holdBlock()

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
