extends Control


@onready var hpBarP1 = $HPPlayer1
@onready var hpBarP2 = $HPPlayer2
@onready var combo_counter_1 = $ComboCounter1
@onready var combo_damage_1 = $ComboDamage1
@onready var combo_counter_2 = $ComboCounter2
@onready var combo_damage_2 = $ComboDamage2
@onready var tm_combo_player_1 = $tmComboPlayer1
@onready var tm_combo_player_2 = $tmComboPlayer2
@onready var lb_ko = $lbKO
@onready var lbl_player_wins = $lblPlayerWins
@onready var tmr_ko = $tmrKO
@onready var lbl_player_1_win_count = $lblPlayer1WinCount
@onready var lbl_player_2_win_count = $lblPlayer2WinCount
@onready var lbl_timer = $lblTimer
@onready var tmr_timer = $tmrTimer

var player1
var player2

# Called when the node enters the scene tree for the first time.
func _ready():
	tmr_timer.start(99)
	lb_ko.visible = false
	lbl_player_wins.visible = false
	player1 = self.get_node("VirtualController/Player")
	player2 = self.get_node("VirtualController2/Player2")
	player1.connect("gotHit", player1GotHit)
	player2.connect("gotHit", player2GotHit)
	player1.connect("KO", player1KO)
	player2.connect("KO", player2KO)
	setDefault()

func _process(delta):
	lbl_timer.text = str("%2d"%tmr_timer.time_left)

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
	setWins()
	
func player1KO():
	lbl_player_wins.text = "Player 2 Wins!"
	Global.player2Wins += 1
	lbl_player_2_win_count.text = str(Global.player2Wins, " wins")
	KO()

func player2KO():
	lbl_player_wins.text = "Player 1 Wins!"
	Global.player1Wins += 1
	lbl_player_1_win_count.text = str(Global.player1Wins, " wins")
	KO()

func KO():
	lb_ko.visible = true
	lbl_player_wins.visible = true
	tmr_ko.start(5)

func _on_tmr_ko_timeout():
	get_tree().change_scene_to_file("res://Bruh.tscn")

func draw():
	lbl_player_wins.text = "Draw!"
	Global.player1Wins += 1
	Global.player2Wins += 1
	setWins()
	KO()

func setWins():
	lbl_player_1_win_count.text = str(Global.player1Wins, " wins")
	lbl_player_2_win_count.text = str(Global.player2Wins, " wins")

func _on_tmr_timer_timeout():
	lb_ko.text = "Timeout!"
	if player1.HP > player2.HP:
		player2KO()
	elif player1.HP < player2.HP:
		player1KO()
	else:
		draw()
	tmr_timer.stop()
