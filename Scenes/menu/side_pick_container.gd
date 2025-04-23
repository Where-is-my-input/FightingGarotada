extends HBoxContainer
const CONTROLLER = preload("res://Scenes/menu/controller.tscn")
@export var remapperOne:VBoxContainer
@export var remapperTwo:VBoxContainer
@onready var vboxplayer_1: VBoxContainer = $vboxplayer1
@onready var vboxmiddle: VBoxContainer = $vboxmiddle
@onready var vboxplayer_2: VBoxContainer = $vboxplayer2

func _ready() -> void:
	for c in Input.get_connected_joypads():
		var controller = CONTROLLER.instantiate()
		vboxmiddle.add_child(controller)
		controller.deviceId = c

func _input(event: InputEvent) -> void:
	var device = event.get_device()
	if  isRemaping(device, remapperOne) ||  isRemaping(device, remapperTwo): return
	if event.is_action_pressed("4") || event.is_action_pressed("p2_4"):
		if remapperOne.deviceId < 0 && remapperTwo.deviceId != device:
			remapperOne.setDevice(device)
			reparentController(vboxplayer_1, device, vboxmiddle)
		elif remapperTwo.deviceId == device:
			remapperTwo.setDevice(-1)
			reparentController(vboxmiddle, device, vboxplayer_2)
	elif event.is_action_pressed("6") || event.is_action_pressed("p2_6"):
		if remapperTwo.deviceId < 0 && device != remapperOne.deviceId:
			remapperTwo.setDevice(device)
			reparentController(vboxplayer_2, device, vboxmiddle)
		elif remapperOne.deviceId == device:
			remapperOne.setDevice(-1)
			reparentController(vboxmiddle, device, vboxplayer_1)

func reparentController(targetSide, device, currentSide):
	for c in currentSide.get_children():
		if c.deviceId == device:
			c.reparent(targetSide)

func isRemaping(device, remapper):
	return remapper.deviceId == device && remapper.remapping
