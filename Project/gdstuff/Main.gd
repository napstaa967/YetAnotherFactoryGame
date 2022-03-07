extends Node2D

export(String) var placing
export(PackedScene) var scene2
export(Dictionary) var placemeta
var camlock = true
var camera
var newmeta = {
	"money": 0
}

func _ready():
	if !has_meta("metadata"):
		set_meta("metadata", newmeta)
	else:
		print(get_meta("metadata"))
	DiscordRpc.start_rpc(str(get_tree().current_scene.get_meta("metadata").money))

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

func load_texture(path):
	if File.new().file_exists("user://TexturePack/" + path):
		return load_external_tex("user://TexturePack/" + path)
	else:
		return load("res://" + path)
		
func save_game(path):
	print(get_meta("metadata"))
	SimpleSave.save_scene(get_tree(), path)

func load_game(path):
	print(get_meta("metadata"))
	SimpleSave.load_scene(get_tree(), path)
	
func update_currency(amount:int):
	var copy2 = get_meta("metadata")
	copy2.money = amount
	set_meta("metadata", copy2.duplicate())
			
func place_item(scene, meta):
	if scene == null:
		placemeta = null
		scene2 = null
		return
	scene2 = load(scene)
	placemeta = meta

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("save_game"):
			SimpleSave.save_scene(get_tree(), "user://saves/cur.tscn")
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if scene2 != null:
			var scene3 = scene2.duplicate().instance().duplicate()
			scene3.set_meta("metadata", placemeta)
			scene3.position.x = ceil(get_global_mouse_position().x / 10) * 10
			scene3.position.y = ceil(get_global_mouse_position().y / 10) * 10
			print(self.name)
			get_tree().current_scene.add_child(scene3)
			scene3.set_owner(get_tree().current_scene)
			var stuff = int(scene3.position.x) % 64
			print(stuff)
			if stuff != 0:
				scene3.position.x = int(scene3.position.x) + 0 - stuff;
			var stuff2 = int(scene3.position.y) % 64
			print(stuff2)
			if stuff2 != 0:
				scene3.position.y = int(scene3.position.y) + 0 - stuff2;
			print(scene3.metadata)
			return
