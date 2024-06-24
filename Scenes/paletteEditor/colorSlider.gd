extends HBoxContainer
@onready var color_rect = $ColorRect
@onready var r = $sliders/boxR/R
@onready var g = $sliders/boxG/G
@onready var b = $sliders/boxB/B
@onready var line_r = $sliders/boxR/lineR
@onready var line_g = $sliders/boxG/lineG
@onready var line_b = $sliders/boxB/lineB

signal changed()
signal copy()
signal paste()

func _ready():
	r.value = color_rect.color.r * 255
	g.value = color_rect.color.g * 255
	b.value = color_rect.color.b * 255
	line_r.text = str(r.value)
	line_g.text = str(g.value)
	line_b.text = str(b.value)

func _on_r_drag_ended(value_changed):
	color_rect.color.r = colorChanged(r, line_r)

func colorChanged(slider, text):
	var rr = slider.value / 255
	text.text = str(rr * 255)
	changed.emit(self, rr)
	return rr

func _on_g_drag_ended(value_changed):
	color_rect.color.g = colorChanged(g, line_g)

func _on_b_drag_ended(value_changed):
	color_rect.color.b = colorChanged(b, line_b)

func setColor(c):
	if c == null: 
		visible = false
		return
	if c is Color:
		r.value = c.r * 255
		g.value = c.g * 255
		b.value = c.b * 255
		color_rect.color = Color(c.r, c.g, c.b, c.a)
	else:
		r.value = c.x * 255
		g.value = c.y * 255
		b.value = c.z * 255
		color_rect.color = Color(c.x, c.y, c.z, c.w)

func getColor():
	return color_rect.color

func _on_line_r_text_changed(new_text):
	r.value = int(new_text)
	_on_r_drag_ended(0)

func _on_line_g_text_changed(new_text):
	g.value = int(new_text)
	_on_g_drag_ended(0)

func _on_line_b_text_changed(new_text):
	b.value = int(new_text)
	_on_b_drag_ended(0)

func returnColor():
	return Color(r.value, g.value, b.value)

func _on_btn_copiar_pressed():
	copy.emit(returnColor())

func _on_btn_colar_pressed():
	paste.emit(self)

func pasteColor(c):
	r.value = c.r
	g.value = c.g
	b.value = c.b
	color_rect.color = Color(c.r, c.g, c.b, c.a)
	color_rect.color.r = colorChanged(r, line_r)
	color_rect.color.g = colorChanged(g, line_g)
	color_rect.color.b = colorChanged(b, line_b)
	
