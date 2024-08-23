extends Control
@onready var player = $VirtualController/Player
@onready var color_picker = $CenterContainer/VBoxContainer/colorPickerContainer/colorPicker
@onready var color_picker_2 = $CenterContainer/VBoxContainer/colorPickerContainer/colorPicker2
@onready var color_picker_3 = $CenterContainer/VBoxContainer/colorPickerContainer/colorPicker3
@onready var virtual_controller = $VirtualController

var shadderParamenter = "shader_parameter/newColor"

var colorsArray:Array
var parameterArray:Array
var parameterIndex = 1
var body

var copiedColor:Color = Color(255, 255, 0)

func _ready():
	virtual_controller.roundStart = false
	body = player.body
	fillArrays(color_picker)
	fillArrays(color_picker_2)
	fillArrays(color_picker_3)

func fillArrays(cPicker):
	for c in cPicker.get_children():
		if c.is_in_group("colorPicker"):
			colorsArray.push_back(c)
			var shaderpar = str(shadderParamenter,parameterIndex)
			parameterArray.push_back(shaderpar)
			parameterIndex += 1
			c.setColor(player.getShaderPar(shaderpar))
			c.connect("changed", changed)
			c.connect("copy", copyColor)
			c.connect("paste", pasteColor)
#array.find
func changed(c, color):
	var index = colorsArray.find(c)
	if index == -1: return
	player.setShaderPar(parameterArray[index], Vector4(color.r, color.g, color.b, color.a))

func pasteColor(colorPicker):
	colorPicker.pasteColor(copiedColor)

func copyColor(v):
	copiedColor = v

func _on_bt_print_pressed():
	for c in colorsArray:
		print(c.getColor())

func _on_bt_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func _on_bt_player_1_pressed():
	Global.player1Palette.clear()
	for c in colorsArray:
		Global.player1Palette.push_back(c.getColor())

func _on_bt_player_2_pressed():
	Global.player2Palette.clear()
	for c in colorsArray:
		Global.player2Palette.push_back(c.getColor())

func _on_save_collorbt_pressed() -> void:
	Global.SaveGameData()
