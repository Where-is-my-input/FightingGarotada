extends Control
@onready var characters = $characters
@onready var player_1_selection = $player1Selection
@onready var player_2_selection = $player2Selection
const JILL = preload("res://Scenes/characters/Jill/jill.tscn")
var charactersArray:Array

var player1Selected = 0
var player2Selected = 2

var p1Confirmed = false
var p2Confirmed = false

func _ready():
	charactersArray = characters.get_children()
	setPlayerSelection(player_1_selection, player1Selected)

func _process(delta):
	if p1Confirmed && Global.gameMode == Global.mode.PALETTE_EDITOR:
		confirmedSelectCharacters()
		get_tree().change_scene_to_file("res://Scenes/UI/load_screen/load_screen.tscn")
	if p1Confirmed && p2Confirmed:
		confirmedSelectCharacters()
		get_tree().change_scene_to_file("res://Scenes/UI/load_screen/load_screen.tscn")

func confirmedSelectCharacters():
	Global.player1Character = player1Selected
	Global.player2Character = player2Selected

func _input(event):
	if !p2Confirmed:
		if event.is_action_pressed("p2_6") || Global.gameMode == Global.mode.TRAINING && event.is_action_pressed("6") && p1Confirmed:
			movePlayer2Cursor()
		if event.is_action_pressed("p2_4") || Global.gameMode == Global.mode.TRAINING && event.is_action_pressed("4") && p1Confirmed:
			movePlayer2Cursor(-1)
		setPlayerSelection(player_2_selection, player2Selected)
		if event.is_action_pressed("p2LP") || Global.gameMode == Global.mode.TRAINING && event.is_action_pressed("LP") && p1Confirmed:
			p2Confirmed = true
	elif event.is_action_pressed("p2MP") || Global.gameMode == Global.mode.TRAINING && event.is_action_pressed("MP") && p1Confirmed:
		p2Confirmed = false
	if !p1Confirmed:
		if event.is_action_pressed("6"):
			movePlayer1Cursor()
		if event.is_action_pressed("4"):
			movePlayer1Cursor(-1)
		setPlayerSelection(player_1_selection, player1Selected)
		if event.is_action_pressed("LP"):
			p1Confirm()
	elif event.is_action_pressed("MP"):
		p1Confirmed = false

func movePlayer1Cursor(value = 1):
	player1Selected += value
	player1Selected = returnCursorValue(player1Selected)

func movePlayer2Cursor(value = 1):
	player2Selected += value
	player2Selected = returnCursorValue(player2Selected)

func returnCursorValue(selection):
	if selection >= charactersArray.size():
		return 0
	elif selection < 0:
		return charactersArray.size() - 1
	return selection

func setPlayerSelection(playerSelection, charSelected):
	playerSelection.global_position = charactersArray[charSelected].global_position

func p1Confirm():
	p1Confirmed = true
	#var spawnCharacter = JILL.instantiate()
	#p_1_spawn_position.add_child(spawnCharacter)
