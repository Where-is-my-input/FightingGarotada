extends Control


@onready var hpBarP1 = $HPPlayer1
@onready var hpBarP2 = $HPPlayer2
@onready var combo_counter_1 = $ComboCounter1
@onready var combo_damage_1 = $ComboDamage1
@onready var combo_counter_2 = $ComboCounter2
@onready var combo_damage_2 = $ComboDamage2

var player1
var player2

var comboTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = self.get_node("VirtualController/Player")
	player2 = self.get_node("VirtualController2/Player2")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	hpBarP1.value = player1.HP
	hpBarP2.value = player2.HP
	if comboTimer > 0:
		comboTimer -= 1
	if player1.comboCounter > 0:
		combo_counter_1.visible = true
		combo_damage_1.visible = true
		combo_counter_1.text = str(player1.comboCounter)
		combo_damage_1.text = str(player1.comboDamage)
		comboTimer = 60
	elif comboTimer == 0:
		combo_counter_1.visible = false
		combo_damage_1.visible = false
	if player2.comboCounter > 0:
		combo_counter_2.visible = true
		combo_damage_2.visible = true
		combo_counter_2.text = str(player2.comboCounter)
		combo_damage_2.text = str(player2.comboDamage)
		comboTimer = 60
	elif comboTimer == 0:
		combo_counter_2.visible = false
		combo_damage_2.visible = false
