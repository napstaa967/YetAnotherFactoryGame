extends Button


# Declare member variables here. Examples:
var selected = 2

var metadata = {
	"speed": 1,
	"type": "conveyor",
	"direction": "down",
}

var texturestuff = "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })

# Called when the node enters the scene tree for the first time.
func _ready():
	text = metadata.direction
	if File.new().file_exists("user://TexturePack/" + texturestuff):
		icon = load_external_tex("user://TexturePack/" + texturestuff)
	else:
		icon = load("res://" + texturestuff)

func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var _bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var _data = img.load_png_from_buffer(_bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex
		
func _pressed():
	Main.place_item("res://scene/test_conveyor.tscn", metadata.duplicate())
	
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("change_item_left"):
			print("pressed left")
			if selected > 0:
				selected -= 1
		if Input.is_action_just_pressed("change_item_right"):
			print("pressed right")
			if selected < 3:
				selected += 1
		match selected:
			0:
				print("left")
				metadata.direction = "left"
			1:
				print("up")
				metadata.direction = "up"
			2:
				print("down")
				metadata.direction = "down"
			3:
				print("right")
				metadata.direction = "right"
		text = metadata.direction
		if File.new().file_exists("user://TexturePack/" + texturestuff):
			icon = load_external_tex("user://TexturePack/" + texturestuff)
		else:
			icon = load("res://" + texturestuff)
