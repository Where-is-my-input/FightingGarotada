extends Control
@onready var sprite_2d = $Sprite2D
@onready var tmr_wait = $tmrWait

var scene

func _ready():
	match Global.gameMode:
		Global.mode.PALETTE_EDITOR:
			scene = "res://Scenes/paletteEditor/palette_editor.tscn"
		_:
			scene = "res://Scenes/GameScene.tscn"
	ResourceLoader.load_threaded_request(scene, "", true)

func _process(delta):
	if tmr_wait.is_stopped():
		match ResourceLoader.load_threaded_get_status(scene):
			0,1,2:
				pass
			3:
				var loadedResource = ResourceLoader.load_threaded_get(scene)
				get_tree().change_scene_to_packed(loadedResource)
	#sprite_2d.rotate(365)
