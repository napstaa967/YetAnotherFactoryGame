extends Button

var metadata = {
	"type": "remove",
	"mode": "oneshot",
	"placing": false,
	"sell": 0,
	"buy": 0,
	"elec": 5,
	"on": false
}

func textupdate():
	var path = "textures/misc"
	var overridename = "texture_override.json"
	match metadata.mode:
		"seller":
			path = "textures/machinery/seller"
			overridename = "texture_override.json"
		"oneshot":
			path = "textures/misc"
			overridename = "remove_oneshot_texture_override.json"
		"persistent":
			path = "textures/misc"
			overridename = "remove_persistent_texture_override.json"
	var file = File.new()
	var texturestuff = path + "/seller.png"
	if !file.file_exists(BaseFuncs.moddedload(path + "/" + overridename)):
		texturestuff = path + "/seller.png"
		var texturest = BaseFuncs.load_texture(texturestuff)
		texturest.set_size_override(Vector2(32, 32))
		get_node("TextureRect").texture = texturest
		get_node("TextureRect").texture.set_flags(0)
	else:
		file.open(BaseFuncs.moddedload(path + "/" + overridename), File.READ)
		var textureoverrides = parse_json(file.get_as_text())
		texturestuff = BaseFuncs.loadoverrides(textureoverrides, get_node("TextureRect"), metadata, texturestuff, "icon")
		
		var texturest = BaseFuncs.load_texture(texturestuff.tex)
		texturest.set_size_override(Vector2(32, 32))
		texturest.set_flags(0)
		get_node("TextureRect").texture = texturest
		get_node("TextureRect").rect_size = Vector2(32,32)

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)
	text = metadata.mode
	var temp = BaseFuncs.load_texture("textures/misc/remove_{mode}.png".format({ "mode": metadata.mode }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
	icon.set_flags(0)
	textupdate()
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/remove_tool.tscn", metadata.duplicate())

func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("change_item_general"):
			match metadata.mode:
				"oneshot":
					metadata.mode = "persistent"
					metadata.sell = 0
					metadata.buy = 0
					metadata.elec = 0
				"persistent":
					metadata.mode = "seller"
					metadata.sell = 100
					metadata.buy = 200
					metadata.elec = 5
				"seller":
					metadata.mode = "oneshot"
					metadata.sell = 0
					metadata.buy = 0
					metadata.elec = 0
			textupdate()
