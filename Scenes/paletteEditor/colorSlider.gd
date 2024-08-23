extends HBoxContainer
@onready var color_picker: ColorPickerButton = $colorPicker

signal changed()
signal copy()
signal paste()

func setColor(c):
	if c == null: 
		visible = false
		return
	if c is Color:
		color_picker.color = Color(c.r, c.g, c.b, c.a)
	else:
		color_picker.color = Color(c.x, c.y, c.z, c.w)

func getColor():
	return color_picker.color

func returnColor():
	return color_picker.color

func _on_btn_copiar_pressed():
	copy.emit(returnColor())

func _on_btn_colar_pressed():
	paste.emit(self)

func pasteColor(c):
	changed.emit(self, c)
	color_picker.color = c

func _on_color_picker_color_changed(color: Color) -> void:
	changed.emit(self, color)
