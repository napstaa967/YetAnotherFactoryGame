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
	print(tree)
	print(filename)
	var root = tree.current_scene
	print(root)
	return _save_scene(root, filename)

static func load_scene(tree:SceneTree, filename:String) -> int:
	tree.current_scene.queue_free()
	tree.change_scene(filename)
	print(tree.current_scene.get_meta("metadata"))
	for child in tree.current_scene.get_children():
		if child.has_meta("metadata"):
			match child.get_meta("metadata").type:
				"item":
					var stff = load("res://scene/item.tscn").instance()
					var newchild = stff.duplicate()
					newchild.set_meta("metadata", child.get_meta("metadata"))
					newchild.position = child.position
					child.queue_free()
					tree.current_scene.add_child(newchild)
	return 0

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
	print(top_node.get_meta("metadata"))
	var d = Directory.new()
	d.make_dir_recursive(filename.get_base_dir())
	var scene = PackedScene.new()
	for x in top_node.get_children():
		set_owner(x, top_node)
	print(top_node.get_children())
	scene.pack(top_node)
	return ResourceSaver.save(filename,scene)
