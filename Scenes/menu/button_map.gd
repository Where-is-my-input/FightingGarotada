extends Control
@onready var grid_container = $CenterContainer/GridContainer

@export var actionItems: Array[String]

func _ready():
	CreateActionRemapItems()

func CreateActionRemapItems():
	var previousItem = grid_container.get_child(grid_container.get_child_count() - 1)
	for index in range(actionItems.size()):
		var action = actionItems[index]
		var label = Label.new()
		label.text = action
		grid_container.add_child(label)
		
		var button = ButtonRemap.new()
		button.action = action
		button.focus_neighbor_top = previousItem.get_path()
		previousItem.focus_neighbor_bottom = button.get_path()
		
		#if index == actionItems.size() - 1:
			#mainMenuButton.focus_neighbor_top = button.get_path()
			#button.focus_neighbor_bottom = mainMenuButton.get_path()
		
		previousItem = button
		grid_container.add_child(button)
