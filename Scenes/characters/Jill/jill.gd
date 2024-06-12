extends "res://CharacterScript.gd"

#var granade = preload("res://Scenes/Projectiles/projectile.tscn")

#func special5():
	#var projectile = granade.instantiate()

func _ready():
	super()
	setPalette()

func _physics_process(delta):
	super(delta)

func setPalette():
	var materialArray = ["shader_parameter/newColor1","shader_parameter/newColor2","shader_parameter/newColor3",
	"shader_parameter/newColor4","shader_parameter/newColor5","shader_parameter/newColor6","shader_parameter/newColor7",
	"shader_parameter/newColor8","shader_parameter/newColor9","shader_parameter/newColor10","shader_parameter/newColor11",
	"shader_parameter/newColor12","shader_parameter/newColor13","shader_parameter/newColor14","shader_parameter/newColor15",
	"shader_parameter/newColor16","shader_parameter/newColor17","shader_parameter/newColor18"]
	for m in materialArray:
		var r = randf_range(0,1)
		var g = randf_range(0,1)
		var b = randf_range(0,1)
		material.set(m, Vector4(r,g,b,255.0))
		#print(material.get_shader_parameter(m), m)
		material.set_shader_parameter(m, Vector4(r,g,b,255.0))
