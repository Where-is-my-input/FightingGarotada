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
	ResourceSaver.save(player.saveState(), saveFilePath+saveFileName)
	ResourceSaver.save(player2.saveState(), saveFilePath+saveFileName2)

func loadState():
	#.duplicate(true)
	player.loadState(ResourceLoader.load(saveFilePath+saveFileName))
	player2.loadState(ResourceLoader.load(saveFilePath+saveFileName2))
	Global.loadState.emit()
