extends Control
@onready var btn_versus = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/btnVersus

func _ready():
	btn_versus.grab_focus()
	RenderingServer.set_default_clear_color(Color.BLACK)

func _on_btn_versus_pressed():
	Global.setGameMode(Global.mode.VERSUS)
	get_tree().change_scene_to_file("res://Bruh.tscn")

func _on_btn_button_map_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/button_remap.tscn")

func _on_button_pressed():
	Global.setGameMode(Global.mode.TRAINING)
	get_tree().change_scene_to_file("res://Bruh.tscn")
