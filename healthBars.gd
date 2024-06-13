extends Control

#@onready var hpBarP1 = $CanvasLayer/HPPlayer1
#@onready var hpBarP2 = $CanvasLayer/HPPlayer2
@onready var combo_counter_1 = $CanvasLayer/ComboCounter1
@onready var combo_damage_1 = $CanvasLayer/ComboDamage1
@onready var combo_counter_2 = $CanvasLayer/ComboCounter2
@onready var combo_damage_2 = $CanvasLayer/ComboDamage2
@onready var tm_combo_player_1 = $CanvasLayer/tmComboPlayer1
@onready var tm_combo_player_2 = $CanvasLayer/tmComboPlayer2
@onready var lb_ko = $CanvasLayer/lbKO
@onready var lbl_player_wins = $CanvasLayer/lblPlayerWins
@onready var tmr_ko = $CanvasLayer/tmrKO
@onready var lbl_player_1_win_count = $CanvasLayer/lblPlayer1WinCount
@onready var lbl_player_2_win_count = $CanvasLayer/lblPlayer2WinCount
@onready var lbl_timer = $CanvasLayer/lblTimer
@onready var tmr_timer = $CanvasLayer/tmrTimer
@onready var camera_2d = $Camera2D
@onready var lbl_player_1_win_streak = $CanvasLayer/lblPlayer1WinStreak
@onready var lbl_player_2_win_streak = $CanvasLayer/lblPlayer2WinStreak
@onready var lbl_leader_2 = $CanvasLayer/lblLeader2
@onready var lbl_leader_1 = $CanvasLayer/lblLeader1
@onready var hpBarP1 = $CanvasLayer/tpHPPlayer1
@onready var hpBarP2 = $CanvasLayer/tpHPPlayer2
@onready var tmr_round_start = $tmrRoundStart

var player1
var player2

var player1KOed = false
var player2KOed = false

#var timerPause = true

# Called when the node enters the scene tree for the first time.
func _ready():
	tmr_round_start.start(2)
	#if !timerPause: tmr_timer.start(99)
	lb_ko.visible = false
	lbl_player_wins.visible = false
	player1 = self.get_node("VirtualController/Player")
	player2 = self.get_node("VirtualController2/Player2")
	player1.connect("gotHit", player1GotHit)
	player2.connect("gotHit", player2GotHit)
	player1.connect("KO", player1KO)
	player2.connect("KO", player2KO)
	player1.setCamera(camera_2d.get_path())
	setWinStreak()
	#player2.setCamera(camera_2d.get_path())
	setDefault()

func _process(_delta):
	var timer = tmr_timer.time_left +1
	if !tmr_timer.is_stopped(): 
		lbl_timer.text = str("%2d"%timer)
	else:
		lbl_timer.text = str("%2d"%tmr_round_start.time_left)

func player1GotHit():
	hpBarP1.value = player1.HP
	combo_counter_1.visible = true
	combo_damage_1.visible = true
	combo_counter_1.text = str(player1.comboCounter)
	combo_damage_1.text = str(player1.comboDamage)
	tm_combo_player_1.start(1)
	setLeader()

func player2GotHit():
	hpBarP2.value = player2.HP
	combo_counter_2.visible = true
	combo_damage_2.visible = true
	combo_counter_2.text = str(player2.comboCounter)
	combo_damage_2.text = str(player2.comboDamage)
	tm_combo_player_2.start(1)
	setLeader()

func setLeader():
	if player1.HP > player2.HP:
		lbl_leader_1.visible = true
		lbl_leader_2.visible = false
	elif player1.HP < player2.HP:
		lbl_leader_2.visible = true
		lbl_leader_1.visible = false
	else:
		lbl_leader_2.visible = false
		lbl_leader_1.visible = false

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
	player1KOed = true
	lbl_player_wins.text = "Player 2 Wins!"
	Global.player2Wins += 1
	Global.player2WinStreak += 1
	Global.player1WinStreak = 0
	lbl_player_1_win_streak.visible = false
	lbl_player_2_win_streak.visible = true
	lbl_player_2_win_count.text = str(Global.player2Wins, " wins")
	if player2KOed: 
		doubleKO()
	else:
		KO()

func player2KO():
	player2KOed = true
	lbl_player_wins.text = "Player 1 Wins!"
	Global.player1Wins += 1
	Global.player1WinStreak += 1
	Global.player2WinStreak = 0
	lbl_player_1_win_streak.visible = true
	lbl_player_2_win_streak.visible = false
	lbl_player_1_win_count.text = str(Global.player1Wins, " wins")
	if player1KOed: 
		doubleKO()
	else:
		KO()

func setWinStreak():
	if Global.player1WinStreak == 0 || Global.player2WinStreak == 0:
		if Global.player1WinStreak > 0: lbl_player_2_win_streak.visible = false
		if Global.player2WinStreak > 0: lbl_player_1_win_streak.visible = false
	lbl_player_1_win_streak.text = str(Global.player1WinStreak, " Wins")
	lbl_player_2_win_streak.text = str(Global.player2WinStreak, " Wins")

func doubleKO():
	lbl_player_wins.text = "Double KO!"
	Global.player1WinStreak = 1
	Global.player2WinStreak = 1
	lbl_player_1_win_streak.visible = true
	lbl_player_2_win_streak.visible = true
	KO()

func KO():
	lb_ko.visible = true
	lbl_player_wins.visible = true
	tmr_ko.start(5)
	setWinStreak()

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
	lbl_timer.text = str("%2d"%tmr_timer.time_left)

func pauseTimer():
	if tmr_timer != null: tmr_timer.stop()

func resumeTimer():
	tmr_timer.start(tmr_timer.get_time_left())

func _on_tmr_round_start_timeout():
	Global.roundStarted.emit()
	tmr_timer.start(99)
