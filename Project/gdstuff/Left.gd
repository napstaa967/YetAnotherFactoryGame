extends TextureRect

func _ready():
	Main.load_texture("textures/gui/border/left.png")
	
func _process(_delta):
	set_size(Vector2(16, get_viewport_rect().size.x - 32))
	rect_position = Vector2(0,16)
