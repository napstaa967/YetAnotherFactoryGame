extends Reference

class_name SimpleSave

static func set_owner(node, root):
	if node != root:
		node.owner = root
	for child in node.get_children():
		if is_instanced_from_scene(child)==false:
			set_owner(child, root)
		else:
			child.owner = root

static func is_instanced_from_scene(p_node):
	if not p_node.filename.empty():
		return true
	return false

static func save_scene(tree:SceneTree, filename:String) -> int:
	var root = tree.current_scene
	return _save_scene(root, filename)

static func load_scene(tree:SceneTree, filename:String) -> int:
	var main = "res://scene/Main.tscn"
	var stuff3 = load(filename).instance()
# warning-ignore:return_value_discarded
	tree.change_scene(main)
	yield(tree.current_scene, "tree_exited")
	yield(tree, "idle_frame")
	var newmet = stuff3.get_meta("metadata").duplicate()
	newmet.source = filename
	tree.current_scene.set_meta("metadata", newmet)
	for child in stuff3.get_children():
		if child.has_meta("metadata"):
			var stff = null
			match child.get_meta("metadata").type:
				"item":
					stff = load("res://scene/item.tscn").instance()
				"conveyor", "splitter", "trisplitter", "producer":
					stff = load("res://scene/test_conveyor.tscn").instance()
				"converter":
					stff = load("res://scene/Machine.tscn").instance()
				"remove":
					stff = load("res://scene/remove_tool.tscn").instance()
			if stff != null:
				var newchild = stff.duplicate()
				newchild.set_meta("metadata", child.get_meta("metadata"))
				newchild.position = child.position
				tree.current_scene.add_child(newchild.duplicate())
				child.queue_free()
				stuff3.remove_child(child)
	stuff3.queue_free()
	return save_scene(tree, filename)

static func load_scene_partial(top_node:Node, filename:String) -> int:
	var f = File.new()
	if(!f.file_exists(filename)):
		print_debug("File: " + str(filename) + " doesn't exist")
		return ERR_FILE_NOT_FOUND
	var new_obj = ResourceLoader.load(filename)
	top_node.replace_by(new_obj.instance())
	return OK

static func save_scene_partial(node:Node, filename:String) -> int:
	return _save_scene(node, filename)

static func _save_scene(top_node:Node, filename:String) -> int:
	var d = Directory.new()
	d.make_dir_recursive(filename.get_base_dir())
	var scene = PackedScene.new()
	for x in top_node.get_children():
		if x.has_meta("metadata") && x.get_meta("metadata").placing == true:
			continue
		set_owner(x, top_node)
	print(top_node.get_children())
	scene.pack(top_node)
	return ResourceSaver.save(filename,scene)

