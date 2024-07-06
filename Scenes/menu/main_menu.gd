extends Control
@onready var btn_versus = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/btnVersus
@onready var btn_training = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/btnTraining

func _ready():
	btn_training.grab_focus()
	RenderingServer.set_default_clear_color(Color.DARK_SLATE_GRAY)#DARK_SLATE_GRAY

func _on_btn_versus_pressed():
	Global.setGameMode(Global.mode.VERSUS)
	get_tree().change_scene_to_file("res://Scenes/UI/character_select.tscn")

func _on_btn_button_map_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/button_remap.tscn")

func _on_button_pressed():
	Global.setGameMode(Global.mode.TRAINING)
	get_tree().change_scene_to_file("res://Scenes/UI/character_select.tscn")

func _on_btn_color_editor_pressed():
	Global.setGameMode(Global.mode.PALETTE_EDITOR)
	get_tree().change_scene_to_file("res://Scenes/UI/character_select.tscn")
