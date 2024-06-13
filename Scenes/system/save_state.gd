extends Node

var saveFilePath = "user://save/"
var saveFileName = "saveGame.save"
@onready var player = $"../VirtualController/Player"

func _ready():
	DirAccess.make_dir_absolute(saveFilePath)

func _input(event):
	if event.is_action_pressed("save"):
		saveState()
	if event.is_action_pressed("load"):
		loadState()

func saveState():
	#ResourceSaver.save("player.saveState()", saveFileName)
	pass

func loadState():
	var gp = ResourceLoader.load(saveFilePath+saveFileName)
	player.loadState(gp)
