extends Sprite


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
	if File.new().file_exists("user://TexturePack/textures/placeholder_item.png"):
		texture = load_external_tex("user://TexturePack/textures/placeholder_item.png")
