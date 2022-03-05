extends TextureRect

func _ready():
	texture = Main.load_texture("textures/gui/border/{gui}.png".format({"gui": get_name()}))

func _process(_delta):
	match get_name():
		"left":
			rect_scale = Vector2(1/(texture.get_size().x-32),(get_viewport_rect().size.y)/texture.get_size().y-32)
			rect_position = Vector2(0, 16)
		"right":
			rect_scale = Vector2(1/(texture.get_size().x-32),(get_viewport_rect().size.y)/texture.get_size().y-32)
			rect_position = Vector2(get_viewport_rect().size.x - 16, 16)
		"up":
			rect_scale = Vector2((get_viewport_rect().size.x)/texture.get_size().x-32, 1/(texture.get_size().y-32))
			rect_position = Vector2(16, 0)
		"down":
			rect_scale = Vector2((get_viewport_rect().size.x)/texture.get_size().x-32, 1/(texture.get_size().y-32))
			rect_position = Vector2(16, get_viewport_rect().size.y - 16)
