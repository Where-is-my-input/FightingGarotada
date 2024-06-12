extends HBoxContainer
@onready var color_rect = $ColorRect
@onready var r = $sliders/R
@onready var g = $sliders/G
@onready var b = $sliders/B

signal changed()

func _ready():
	r.value = color_rect.color.r * 255
	g.value = color_rect.color.g * 255
	b.value = color_rect.color.b * 255

func _on_r_drag_ended(value_changed):
	var rr = r.value / 255
	color_rect.color.r = rr
	changed.emit(self, rr)

func _on_g_drag_ended(value_changed):
	var gg = g.value / 255
	color_rect.color.g = gg
	changed.emit(self, gg)

func _on_b_drag_ended(value_changed):
	var bb = b.value / 255
	color_rect.color.b = bb
	changed.emit(self, bb)

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
