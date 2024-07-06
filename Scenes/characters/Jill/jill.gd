extends CharacterScript

var granade = preload("res://Scenes/Projectiles/projectile.tscn")

#func special5():
	#var projectile = granade.instantiate()

func _ready():
	super()
	setPalette(virtualController.player)

func _physics_process(delta):
	super(delta)

func setPalette(p):
	var palManager = PaletteManager.new();
	palManager.setPalette(p, material)

func spawnGranade(special = 0):
	var nade = granade.instantiate()
	nade.globalPos = grab_position.global_position
	nade.velX = nade.velX * facing * -1
	if special == 1: 
		nade.velY = -400
		nade.velX = (nade.velX - 100) * facing * -1
	parent.add_child(nade)
	nade.setHitboxValues()
