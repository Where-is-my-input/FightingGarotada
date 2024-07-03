extends Node

enum mode {VERSUS, TRAINING}
enum hitType {NORMAL, LAUNCHER, KNOCKDOWN, GRAB, PROJECTILE} #STAGGER, BOUNCES
enum blockType {MID, LOW, HIGH, UNBLOCKABLE}
enum character {JILL, LILITH, MARROW}

signal player1KO()
signal player2KO()
signal debugPause()
signal debugFrameAdvance()
signal roundStarted()

signal saveState()
signal loadState()

#const SAVE_PATH : String = "user://gamedata.data"
const SAVE_PATH : String = "res://palettes/gamedata.data"

var player1Wins = 0
var player2Wins = 0

var player1WinStreak = 0
var player2WinStreak = 0

var player1Palette:Array
var player2Palette:Array

var ground = 785

var gameMode = mode.VERSUS

var player1Character = character.JILL
var player2Character = character.JILL

func _ready() -> void:
	LoadGameData()

func _input(event):
	if event.is_action_pressed("mainmenu"):
		get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func setGameMode(v):
	print("game mode set to - ", v)
	gameMode = v

func LoadGameData():
	#checking if the file does exist
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		#getting the parsed data from the Json file
		var parsedData = JSON.parse_string(file.get_as_text())
		file.close()
		
		for data in parsedData:
			#here we use the color constructor Color.from_string, so we can convert it back to color, Color.White is just a default value
			var colorData = Color.from_string(data, Color.WHITE)
			#adding the converted data to the player1Pallete(Array)
			player1Palette.append(colorData)
			
		
func SaveGameData():
	
	#here we save the game data, so we can load the palletes
	
	#opening the file
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	#creating a separated array so the data can be store in a correct json format
	var formattedArray : Array = []
	
	for data in player1Palette:
		if typeof(data) == TYPE_COLOR:
			#this is a important step, here we change the color data from rgb to hex
			formattedArray.append(data.to_html())
			
	#saving it in the disk and closing the file
	file.store_string(JSON.stringify(formattedArray))
	file.close()
	
