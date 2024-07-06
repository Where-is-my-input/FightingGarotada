extends CollisionShape2D
@onready var shape_cast_2d = $ShapeCast2D

func _physics_process(_delta):
	#if shape_cast_2d != null:
	shape_cast_2d.shape = shape
	shape_cast_2d.global_position = global_position
	shape_cast_2d.enabled = !disabled
	shape_cast_2d.force_shapecast_update()
	if shape_cast_2d.enabled:
		for c in shape_cast_2d.get_collision_count():
			get_parent()._on_area_entered(shape_cast_2d.get_collider(c))
