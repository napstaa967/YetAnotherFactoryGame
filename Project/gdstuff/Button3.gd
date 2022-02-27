extends Button


# Declare member variables here. Examples:
# var a = 2
var id = "conveyor_left"
var type = "conveyor"


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
	
func _ready():
	if File.new().file_exists("user://TexturePack/textures/conveyor_placeholder/left.png"):
		icon = load_external_tex("user://TexturePack/textures/conveyor_placeholder/left.png")
		
func _pressed():
	print("test2")
	Main.placing = id
	Main.scene2 = null
