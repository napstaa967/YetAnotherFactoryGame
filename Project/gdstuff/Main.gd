extends Node2D

export(PackedScene) var mob_scene
export(String) var placing
export(PackedScene) var scene2
var type = "conveyor"
var placemeta

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

func _ready():
	#placing = "conveyor_down"
	randomize()
	print("one")

func place_item(scene, meta):
	scene2 = load(scene)
	placemeta = meta
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		match placing:
			"placeholder_item":
				mob_scene = load("res://scene/item.tscn")
			"conveyor_left":
				mob_scene = load("res://scene/test_conv.tscn")
			"seller":
				mob_scene = load("res://scene/seller.tscn")
		if scene2 != null:
			var scene3 = scene2.duplicate().instance().duplicate()
			scene3.set_meta("metadata", placemeta)
			scene3.position.x = ceil(get_global_mouse_position().x / 10) * 10
			scene3.position.y = ceil(get_global_mouse_position().y / 10) * 10
			add_child(scene3)
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
		if mob_scene != null:
			var mob = mob_scene.instance()
			add_child(mob)
			mob.position.x = ceil(get_global_mouse_position().x / 10) * 10
			mob.position.y = ceil(get_global_mouse_position().y / 10) * 10
			var stuff = int(mob.position.x) % 64
			print(stuff)
			if stuff != 0:
				mob.position.x = int(mob.position.x) + 0 - stuff;
			var stuff2 = int(mob.position.y) % 64
			print(stuff2)
			if stuff2 != 0:
				mob.position.y = int(mob.position.y) + 0 - stuff2;
			return
	# pass
