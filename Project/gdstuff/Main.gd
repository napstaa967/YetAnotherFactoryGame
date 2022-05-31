extends Node2D

export(String) var placing
export(PackedScene) var scene2
export(Dictionary) var placemeta
var camlock = true
var camera
var can_place
var placingscene
export (Dictionary) var newmeta = {
	"money": 2000,
	"source": "res://scene/Main.tscn",
	"difficulty": "regular"
}
var due = 0

func _ready():
	var d = Directory.new()
	d.make_dir_recursive("user://saves/")
	var file = File.new()
	if !file.file_exists("user://settings.json"):
		if file.open("user://settings.json", File.WRITE) != OK:
			print("Error opening file")
		else:
			var defaults = {
				"texturepack": null
			}
			file.store_string(to_json(defaults))
			file.close()
	if !has_meta("metadata"):
		set_meta("metadata", newmeta.duplicate())
	get_tree().current_scene.get_node("DueTimer").set_wait_time(20)
	get_tree().current_scene.get_node("ItemMoveTimer").set_wait_time(1)
	get_tree().current_scene.get_node("DueTimer").start()
	get_tree().current_scene.get_node("RPCTimer").start()
	DiscordRpc.start_rpc(str(get_tree().current_scene.get_meta("metadata").money), get_tree().current_scene.get_meta("metadata").source)

func save_game(path):
	return SimpleSave.save_scene(get_tree(), path)

func load_game(path):
	SimpleSave.load_scene(get_tree(), path)
	
func update_currency(amount:int):
	var copy2 = get_meta("metadata")
	copy2.money = amount
	set_meta("metadata", copy2.duplicate())
			
func place_item(scene, meta):
	if placingscene != null:
		placingscene.queue_free()
	if scene == null:
		placemeta = null
		scene2 = null
		if placingscene != null:
			placingscene.queue_free()
		placingscene = null
		return
	scene2 = load(scene)
	placemeta = meta.duplicate()
	var placemeta2 = placemeta.duplicate()
	placemeta2.placing = true
	placingscene = scene2.duplicate().instance()
	placingscene.set_meta("metadata",placemeta2.duplicate())
	get_tree().current_scene.add_child(placingscene)
	
func _process(delta):
	if placingscene != null:
		var newpos = get_global_mouse_position()
		newpos.x = ceil(newpos.x / 10) * 10
		newpos.y = ceil(newpos.y / 10) * 10
		var stuff = int(newpos.x) % 64
		if stuff != 0:
			newpos.x = int(newpos.x) + 0 - stuff;
		var stuff2 = int(newpos.y) % 64
		if stuff2 != 0:
			newpos.y = int(newpos.y) + 0 - stuff2;
		placingscene.position = placingscene.position.linear_interpolate(newpos, delta * 20)
		if placingscene.get_overlapping_areas().empty() == false:
			for area in placingscene.get_overlapping_areas():
				if placingscene.get_meta("metadata").type == "converter" || placingscene.get_meta("metadata").type == "producer":
					if area.position.x >= placingscene.position.x && area.position.x <= placingscene.position.x + placingscene.get_node("TextureProgress").texture_under.get_size().x - 1 && area.position.y >= placingscene.position.y && area.position.y <= placingscene.position.y + placingscene.get_node("TextureProgress").texture_under.get_size().y - 1 && area.has_meta("metadata"):
						if placingscene.get_meta("metadata").type != "item" && placingscene.get_meta("metadata").type != "remove" && area.has_meta("metadata") && area.get_meta("metadata").type != "item":
							can_place = false
							placingscene.get_child(0).modulate = Color(1, 0.5, 0.5)
						return
					else:
						can_place = true
						placingscene.get_child(0).modulate = Color(0.5, 1, 0.5)
				else:
					if area.position.x >= placingscene.position.x && area.position.x <= placingscene.position.x + placingscene.get_child(0).texture.get_size().x - 1 && area.position.y >= placingscene.position.y && area.position.y <= placingscene.position.y + placingscene.get_child(0).texture.get_size().y - 1 && area.has_meta("metadata"):
						if placingscene.get_meta("metadata").type != "item" && placingscene.get_meta("metadata").type != "remove" && area.has_meta("metadata") && area.get_meta("metadata").type != "item":
							can_place = false
							placingscene.get_child(0).modulate = Color(1, 0.5, 0.5)
						return
					else:
						can_place = true
						placingscene.get_child(0).modulate = Color(0.5, 1, 0.5)
		else:
			can_place = true
			placingscene.get_child(0).modulate = Color(0.5, 1, 0.5)
			
func place_item_now(scene, meta, pos, freepos:bool = false):
	var scene3 = load(scene).duplicate().instance().duplicate()
	scene3.set_meta("metadata", meta.duplicate())
	scene3.position.x = ceil(pos.x / 10) * 10
	scene3.position.y = ceil(pos.y / 10) * 10
	get_tree().current_scene.add_child(scene3)
	scene3.set_owner(get_tree().current_scene)
	if !freepos:
		var stuff = int(scene3.position.x) % 64
		if stuff != 0:
			scene3.position.x = int(scene3.position.x) + 0 - stuff;
		var stuff2 = int(scene3.position.y) % 64
		if stuff2 != 0:
			scene3.position.y = int(scene3.position.y) + 0 - stuff2;
	return


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("save_game"):
			return SimpleSave.save_scene(get_tree(), "user://saves/cur.tscn")
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if scene2 != null && can_place == true && placemeta != null:
			if !placemeta.has("buy"):
				placemeta.buy = 0
			if get_tree().current_scene.get_meta("metadata").money >= placemeta.buy:
				var update = get_tree().current_scene.get_meta("metadata").duplicate()
				update.money -= placemeta.buy
				get_tree().current_scene.set_meta("metadata", update.duplicate())
				var scene3 = scene2.duplicate().instance().duplicate()
				scene3.set_meta("metadata", placemeta.duplicate(true))
				scene3.position.x = ceil(get_global_mouse_position().x / 10) * 10
				scene3.position.y = ceil(get_global_mouse_position().y / 10) * 10
				get_tree().current_scene.add_child(scene3)
				scene3.set_owner(get_tree().current_scene)
				var stuff = int(scene3.position.x) % 64
				if stuff != 0:
					scene3.position.x = int(scene3.position.x) + 0 - stuff;
				var stuff2 = int(scene3.position.y) % 64
				if stuff2 != 0:
					scene3.position.y = int(scene3.position.y) + 0 - stuff2;
				return


func on_due_pay():
	get_tree().current_scene.get_node("/root/Main/DueTimer").start()
	var metcopy = get_meta("metadata")
	metcopy.money -= due
	due = 0 
	set_meta("metadata", metcopy.duplicate())
	get_tree().current_scene.get_node("CanvasLayer/NinePatchRect/Control/Electricity").update()

func itemtimertimeout():
	get_tree().current_scene.get_node("ItemMoveTimer").stop()

func RPCTimer_timeout():
	DiscordRpc.start_rpc(str(get_tree().current_scene.get_meta("metadata").money), get_tree().current_scene.get_meta("metadata").source)
	get_node("RPCTimer").start()
