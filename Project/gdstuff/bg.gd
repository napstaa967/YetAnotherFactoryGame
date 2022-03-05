extends Sprite

func _ready():
	texture = Main.load_texture("textures/misc/background.png")
	texture.set_flags(Texture.FLAG_REPEAT)
	scale = Vector2(64/texture.get_size().x, 64/texture.get_size().y)
	region_rect.size = Vector2(get_viewport_rect().size.x + 128, get_viewport_rect().size.y + 128)
	
func _process(_delta):
	region_rect.size = Vector2(get_viewport_rect().size.x + 128, get_viewport_rect().size.y + 128)
	region_rect.position = Main.camera.position
	position = Main.camera.position
