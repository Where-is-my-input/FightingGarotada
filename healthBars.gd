extends Control


@onready var hpBarP1 = $HPPlayer1
@onready var hpBarP2 = $HPPlayer2

var player1
var player2
# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = self.get_node("VirtualController/Player")
	player2 = self.get_node("VirtualController2/Player2")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hpBarP1.value = player1.HP
	hpBarP2.value = player2.HP
