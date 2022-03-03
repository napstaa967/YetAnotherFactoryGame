extends Sprite

# Called when the node enters the scene tree for the first time.
func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var _data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex

func _ready():
	pass
	#match get_parent().conveyor_direction:
	#if File.new().file_exists("user://TexturePack/textures/conveyor_placeholder/down.png"):
	#	texture = load_external_tex("user://TexturePack/textures/conveyor_placeholder/down.png")
	
