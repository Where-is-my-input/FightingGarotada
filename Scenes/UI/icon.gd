extends Sprite2D

func setPlayerPalette(player):
	var palManager = PaletteManager.new();
	palManager.setPalette(player, material)
