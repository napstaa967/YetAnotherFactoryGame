extends TextureRect

func _ready():
	texture = get_tree().current_scene.load_texture("textures/gui/currencystuff/currency.png")
