extends Sprite

# Called when the node enters the scene tree for the first time.
func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex

func turn_on():
	if File.new().file_exists("user://TexturePack/textures/seller/seller_on.png"):
		texture = load_external_tex("user://TexturePack/textures/seller/seller_on.png")
	else:
		texture = load("res://textures/seller/seller_on.png")

func turn_off():
	if File.new().file_exists("user://TexturePack/textures/seller/seller_off.png"):
		texture = load_external_tex("user://TexturePack/textures/seller/seller_off.png")
	else:
		texture = load("res://textures/seller/seller_off.png")

func _ready():
	pass

