extends Node

var saveFilePath = "res://system/saveState/"
var saveFileName = "saveState.tres"
var saveFileName2 = "saveState2.tres"
@onready var player = $"../VirtualController/Player"
@onready var player2 = $"../VirtualController2/Player2"

func _ready():
	DirAccess.make_dir_absolute(saveFilePath)

func _input(event):
	if event.is_action_pressed("save"):
		saveState()
	if event.is_action_pressed("load"):
		loadState()

func saveState():
	var save = PlayerStateArray.new()
	save.player1State = player.saveStateArray()
	save.player2State = player2.saveStateArray()
	ResourceSaver.save(save, saveFilePath+saveFileName)

func loadState():
	var loadScene = ResourceLoader.load(saveFilePath+saveFileName)
	player.loadStateArray(loadScene.player1State)
	player2.loadStateArray(loadScene.player2State)
	Global.loadState.emit()
