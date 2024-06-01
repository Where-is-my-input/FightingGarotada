extends Control


@onready var hpBarP1 = $HPPlayer1
@onready var hpBarP2 = $HPPlayer2
@onready var combo_counter_1 = $ComboCounter1
@onready var combo_damage_1 = $ComboDamage1
@onready var combo_counter_2 = $ComboCounter2
@onready var combo_damage_2 = $ComboDamage2
@onready var tm_combo_player_1 = $tmComboPlayer1
@onready var tm_combo_player_2 = $tmComboPlayer2

var player1
var player2

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = self.get_node("VirtualController/Player")
	player2 = self.get_node("VirtualController2/Player2")
	player1.connect("gotHit", player1GotHit)
	player2.connect("gotHit", player2GotHit)
	setDefault()

func player1GotHit():
	hpBarP1.value = player1.HP
	combo_counter_1.visible = true
	combo_damage_1.visible = true
	combo_counter_1.text = str(player1.comboCounter)
	combo_damage_1.text = str(player1.comboDamage)
	tm_combo_player_1.start(1)

func player2GotHit():
	hpBarP2.value = player2.HP
	combo_counter_2.visible = true
	combo_damage_2.visible = true
	combo_counter_2.text = str(player2.comboCounter)
	combo_damage_2.text = str(player2.comboDamage)
	tm_combo_player_2.start(1)

func _on_tm_combo_player_1_timeout():
	combo_counter_1.visible = false
	combo_damage_1.visible = false


func _on_tm_combo_player_2_timeout():
	combo_counter_2.visible = false
	combo_damage_2.visible = false

func setDefault():
	combo_counter_1.visible = false
	combo_damage_1.visible = false
	combo_counter_2.visible = false
	combo_damage_2.visible = false
	hpBarP1.value = player1.HP
	hpBarP2.value = player2.HP
	
