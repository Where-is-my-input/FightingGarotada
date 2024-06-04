extends Control
@onready var btn_versus = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/btnVersus

func _ready():
	btn_versus.grab_focus()

func _on_btn_versus_pressed():
	get_tree().change_scene_to_file("res://Bruh.tscn")


func _on_btn_button_map_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/button_remap.tscn")
