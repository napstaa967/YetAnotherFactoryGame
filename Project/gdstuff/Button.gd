extends Button

var metadata = {
	"speed": 1,
	"type": "conveyor",
	"direction": "down",
}

func _ready():
	text = metadata.direction
	if File.new().file_exists("user://TexturePack/" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })):
		set_button_icon(load_external_tex("user://TexturePack/" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })))
	else:
		set_button_icon(load("res://" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })))

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
			metadata.direction = "left"
		if Input.is_action_just_pressed("change_item_right"):
			metadata.direction = "right"
		if Input.is_action_just_pressed("change_item_up"):
			metadata.direction = "up"
		if Input.is_action_just_pressed("change_item_down"):
			metadata.direction = "down"
		text = metadata.direction
		set_button_icon(load("res://" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })))
		if File.new().file_exists("user://TexturePack/" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })):
			print("a")
			set_button_icon(load_external_tex("user://TexturePack/" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })))
		else:
			print("b")
			set_button_icon(load("res://" + "textures/conveyor_placeholder/{direction}.png".format({ "direction": metadata.direction })))
