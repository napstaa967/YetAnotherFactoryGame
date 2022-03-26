extends Button

var metadata = {
	"speed": 1,
	"type": "conveyor",
	"direction": "down",
	"sell": 50,
	"buy": 100,
	"elec": 1,
	"placing": false
}

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)
	text = "Conveyor"
	var temp = BaseFuncs.load_texture("textures/conveyor/normal/conveyor.png")
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
	icon.set_flags(0)
	textupdate()
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/test_conveyor.tscn", metadata.duplicate())

func textupdate():
	var file = File.new()
	var texturestuff = "textures/conveyor/normal/conveyor.png"
	if !file.file_exists(BaseFuncs.moddedload("textures/conveyor/normal/texture_override.json")):
		texturestuff = "textures/conveyor/normal/conveyor.png"
		var texturest = BaseFuncs.load_texture(texturestuff)
		texturest.set_size_override(Vector2(32, 32))
		get_node("TextureRect").rect_pivot_offset = Vector2(texturest.get_size().x/2, texturest.get_size().y/2)
		match get_meta("metadata").direction:
			"down":
				get_node("TextureRect").rect_rotation = 0
			"up":
				get_node("TextureRect").rect_rotation = 180
			"left":
				get_node("TextureRect").rect_rotation = 90
			"right":
				get_node("TextureRect").rect_rotation = 270
		get_node("TextureRect").texture = texturest
		get_node("TextureRect").texture.set_flags(0)
	else:
		file.open(BaseFuncs.moddedload("textures/conveyor/normal/texture_override.json"), File.READ)
		var textureoverrides = parse_json(file.get_as_text())
		texturestuff = BaseFuncs.loadoverrides(textureoverrides, get_node("TextureRect"), metadata, texturestuff, "icon")
		var texturest = BaseFuncs.load_texture(texturestuff.tex)
		texturest.set_size_override(Vector2(32, 32))
		texturest.set_flags(0)
		get_node("TextureRect").texture = texturest
		get_node("TextureRect").rect_size = Vector2(32,32)

func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("change_item_left"):
			metadata.direction = "left"
		if Input.is_action_just_pressed("change_item_right"):
			metadata.direction = "right"
		if Input.is_action_just_pressed("change_item_up"):
			metadata.direction = "up"
		if Input.is_action_just_pressed("change_item_down"):
			metadata.direction = "down"
		var temp = BaseFuncs.load_texture("textures/conveyor/normal/{direction}.png".format({ "direction": metadata.direction }))
		temp.set_size_override(Vector2(32, 32))
		set_button_icon(temp)
		textupdate()
		return

