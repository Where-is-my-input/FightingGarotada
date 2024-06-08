extends Node

@onready var virtual_controller_2 = $"../HPBars/VirtualController2"
@onready var player2 = $"../HPBars/VirtualController2/Player2"
@onready var tmr_block = $tmrBlock

var block = false

func _ready():
	player2.connect("gotHit", player2GotHit)

func player2GotHit():
	tmr_block.start(1)
	block = true

func holdBlock():
	virtual_controller_2.directionX = 1
	virtual_controller_2.directionY = 1

func _process(_delta):
	if block: holdBlock()


func _on_tmr_block_timeout():
	player2.HP = 5000
	block = false
