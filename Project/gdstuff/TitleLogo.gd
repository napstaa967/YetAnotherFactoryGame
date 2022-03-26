extends TextureRect

func _ready():
	var texturestuff = "textures/misc/gamelogo.png"
	texture = BaseFuncs.load_texture(texturestuff)
	set_size(Vector2(288, 144))
	texture.set_flags(0)
