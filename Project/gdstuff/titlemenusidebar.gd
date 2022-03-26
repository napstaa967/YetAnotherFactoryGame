extends TextureRect

func _ready():
	var texturestuff = "textures/misc/title_sidebar.png"
	texture = BaseFuncs.load_texture(texturestuff)
	texture.set_flags(0)
	
func _process(_delta):
	set_size(Vector2(384, get_viewport_rect().size.y))
