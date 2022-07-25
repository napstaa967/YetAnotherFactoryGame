extends Node

const BigInt = preload("res://addons/Big.gd")

enum font_type {REGULAR, BOLD, ITALICS, BOLDITALICS, MONO}

#Base Function signals

signal game_loaded
signal game_saved
signal item_picked
signal item_sent_to_placing
signal json_loaded
signal json_saved
signal reference_pulled
signal settings_entered
signal settings_loaded
signal settings_saved
signal state_pulled
signal texture_loaded

signal translation_changed

#Other Signals

signal item_placed
signal item_placed_by_game
signal item_placed_by_player

var _enforce_placement_rules := true
var _keep_pos := false
var _mod_manifests := {}
var _placement_data := {}
var _placement_icon := ""
var _placement_item : Node
var _resource_manifests := {}

var camlock = true
var categories := {}
var cc = false
var changelogs := {}
var cur_lang = "en_US"
var gamescr = []
var initscr = []
var lang_keys: Dictionary = {}
var modcount: int = 0
var mod_objs: Dictionary = {}
var refs: Dictionary = {}
var rescount: int = 0
var savescr = []
var scripts = {}
var textureshit: Dictionary = {}

func _init():
	var dir = Directory.new()
	if !dir.dir_exists("user://saves"):
		dir.make_dir("user://saves")
	_setup_modding()
	_setup_resourcepacks()
	cur_lang = load_settings().lang
	emit_signal("translation_changed", cur_lang)

func _load_texs():
	var builtins = Directory.new()
	builtins.open("res://textures")
	builtins.list_dir_begin()
	builtins.close()

func _place_item():
	get_tree().current_scene.place_item(_placement_item, _placement_data, _keep_pos, _enforce_placement_rules)
	emit_signal("item_sent_to_placing", _placement_item, _placement_data, _keep_pos, _enforce_placement_rules)
	
func _setup_modding():
	var dir = Directory.new()
	if !dir.dir_exists("user://mods"):
		dir.make_dir("user://mods")
	else:
		dir.open("user://mods")
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var file = File.new()
				if file.file_exists("user://mods/" + file_name + "/manifest.json"):
					var manifest: Dictionary = json_load("user://mods/" + file_name + "/manifest.json")
					manifest.icon = "user://mods/" + file_name + "/" + manifest.icon
					_mod_manifests[manifest.namespace] = manifest
					if manifest.has("init"):
						if !manifest.init.begins_with("user://"):
							initscr.append("user://mods/" + file_name + "/" + manifest.init.trim_prefix("./"))
						else:
							initscr.append(manifest.init)
						rescount += 1
					if manifest.has("save"):
						if !manifest.save.begins_with("user://"):
							savescr.append("user://mods/" + file_name + "/" + manifest.save.trim_prefix("./"))
						else:
							initscr.append(manifest.save)
						rescount += 1
					if manifest.has("game"):
						if !manifest.game.begins_with("user://"):
							gamescr.append("user://mods/" + file_name + "/" + manifest.game.trim_prefix("./"))
						else:
							initscr.append(manifest.game)
						rescount += 1
				if file.file_exists("user://mods/" + file_name + "/manifest.json"):
					var mod = "user://mods/" + file_name
					var thing = json_load(mod + "/manifest.json")
					if thing.version_min in globalvar("Tex Version") and globalvar("Tex Version").find(thing.version_min) <= globalvar("Tex Version").find(globalvar("ReleaseNumber")):
						modcount += 1
						for ii in get_filelist(mod):
							if ii.ends_with(".json"):
								if json_load(ii).has("type"):
									if json_load(ii).type == "builtins:tile":
										var identifier: Array = json_load(ii).id.split(":")
										var ns: String
										if identifier.size() == 1:
											if !thing.has("namespace"):
												ns = "unknown"
											else:
												ns = thing.namespace
										else:
											ns = identifier[0]
										if !mod_objs.has(ns):
											mod_objs[ns] = {}
										mod_objs[ns][identifier[1]] = json_load(ii)
										for i in mod_objs[ns][identifier[1]]:
											if  mod_objs[ns][identifier[1]][i] is String:
												if mod_objs[ns][identifier[1]][i].begins_with("./"):
													var array = Array(ii.trim_prefix("user://").split("/"))
													array.pop_back()
													mod_objs[ns][identifier[1]][i] = "user://" + PoolStringArray(array).join("/") + "/" + mod_objs[ns][identifier[1]][i].trim_prefix("./")
												elif mod_objs[ns][identifier[1]][i].begins_with("user://"):
													pass
												else:
													mod_objs[ns][identifier[1]][i] = mod + "/" + mod_objs[ns][identifier[1]][i]
										rescount += 1
											
			file_name = dir.get_next()

func _setup_resourcepacks():
	var indexoverride = [{"namespace": "builtins", "path": "res://"}] # for updating index.json
	var dir = Directory.new()
	if !dir.dir_exists("user://texturepacks"):
		dir.make_dir("user://texturepacks")
	else:
		dir.open("user://texturepacks")
		dir.list_dir_begin(true)
		if !File.new().file_exists("user://texturepacks/index.json"):
			json_save("user://texturepacks/index.json", {"stuff": indexoverride})
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var file = File.new()
				if file.file_exists("user://texturepacks/" + file_name + "/manifest.json"):
					indexoverride.append({"namespace": json_load("user://texturepacks/" + file_name + "/manifest.json").namespace, "path": "user://texturepacks/" + file_name})
			file_name = dir.get_next()
		var index: Array = json_load("user://texturepacks/index.json").stuff
		var indexnegative = index.duplicate(true)
		for i in indexoverride:
			for ii in indexnegative:
				if ii.namespace == i.namespace:
					indexnegative.erase(ii)
		if !indexnegative.empty():
			for i in indexnegative:
				index.erase(i)
		var ovrnms := {}
		for i in index:
			ovrnms[i.namespace] = i
		for i in indexoverride:
			if i.namespace in ovrnms.keys():
				index.remove(index.find(ovrnms[i.namespace]))
				ovrnms.clear()
				for ii in index:
					ovrnms[ii.namespace] = ii
			index.append(i)
		
		json_save("user://texturepacks/index.json", { "stuff": index })
		# now, loading:
		for i in json_load("user://texturepacks/index.json").stuff:
			var _path = i.path
			if _path == "res://":
				_path = "res:/"
			var ithing = json_load(_path + "/manifest.json")
			ithing.icon = _path + "/" + ithing.icon
			_resource_manifests[ithing.namespace] = ithing
			_resource_manifests[ithing.namespace].data = i
			var thing = ithing.version_min
			if thing in globalvar("Tex Version") and globalvar("Tex Version").find(thing) <= globalvar("Tex Version").find(globalvar("ReleaseNumber")):
				for ii in get_filelist(i.path):
					if ii.ends_with(".json"):
						if json_load(ii).has("type"):
							var pretempthing = json_load(ii).id.split(":")
							var tempthing: Array = []
							if tempthing.size() == 1:
								if !ithing.has("namespace"):
									tempthing.append("unknown")
									tempthing.append(pretempthing[0])
								else:
									tempthing.append(ithing.namespace)
									tempthing.append(pretempthing[0])
							else:
								tempthing = pretempthing
							match json_load(ii).type:
								"builtins:texture":
									if !textureshit.has(tempthing[0]):
										textureshit[tempthing[0]] = {}
									if textureshit[tempthing[0]].has(tempthing[1]):
										for iii in json_load(ii).states.keys():
											textureshit[tempthing[0]][tempthing[1]].states[iii] = json_load(ii).states[iii]
									else:
										textureshit[tempthing[0]][tempthing[1]] = json_load(ii)
									for iii in textureshit[tempthing[0]][tempthing[1]].states.keys():
										if typeof(textureshit[tempthing[0]][tempthing[1]].states[iii]) == TYPE_STRING:
											var laloc = textureshit[tempthing[0]][tempthing[1]].states[iii]
											var _src = ii.split("/")[0]
											if laloc.begins_with("./"):
												var array = Array(ii.trim_prefix(_src + "//").split("/"))
												array.pop_back()
												laloc = _src + "//" + PoolStringArray(array).join("/") + "/" + laloc.trim_prefix("./")
											elif laloc.begins_with(_src + "//"):
												laloc = laloc
											else:
												laloc = i.path + "/" + textureshit[tempthing[0]][tempthing[1]].states[iii]
											textureshit[tempthing[0]][tempthing[1]].states[iii] = laloc
								"builtins:reference", "builtins:resource":
									if !refs.has(tempthing[0]):
										refs[tempthing[0]] = {}
									refs[tempthing[0]][tempthing[1]] = json_load(ii)
									for iii in refs[tempthing[0]][tempthing[1]].states.keys():
										if typeof(refs[tempthing[0]][tempthing[1]].states[iii]) == TYPE_STRING:
											var laloc = refs[tempthing[0]][tempthing[1]].states[iii]
											var _src = ii.split("/")[0]
											if laloc.begins_with("./"):
												var array = Array(ii.trim_prefix(_src + "//").split("/"))
												array.pop_back()
												laloc = _src + "//" + PoolStringArray(array).join("/") + "/" + laloc.trim_prefix("./")
											elif laloc.begins_with(_src + "//"):
												laloc = laloc
											else:
												laloc = i.path + "/" + refs[tempthing[0]][tempthing[1]].states[iii]
											refs[tempthing[0]][tempthing[1]].states[iii] = laloc
								"builtins:category":
									if !categories.has(json_load(ii).id):
										categories[json_load(ii).id] = {}
									categories[json_load(ii).id]= json_load(ii)
								"builtins:changelogs":
									changelogs[json_load(ii).id] = json_load(ii)
					
					elif ii.ends_with(".tres"):
						var __resource = load("res://scripts/translation_template.gd").new()
						var _resource = __resource._load(ii)
						if _resource.get_script():
							if _resource.get("type"):
								if _resource.type == "builtins:translation":
									if !lang_keys.has(_resource.lang_id):
										lang_keys[_resource.lang_id] = {}
									for iii in _resource.keys.keys():
										lang_keys[_resource.lang_id][iii] = _resource.keys[iii]
									
func add_permanent_script(_name, scr):
	var node = Node.new()
	node.set_script(scr)
	node.name = _name
	get_tree().root.call_deferred("add_child", node)

func change_zoom(val):
	if get_tree().current_scene.has_node("Camera2D"):
		get_tree().current_scene.get_node("Camera2D").zoom = Vector2(val,val)

func cur_scene():
	return get_tree().current_scene

func dict_merge(merging: Dictionary, with: Dictionary, overwrite: bool = false):
	var final = merging
	if with == null:
		return merging
	if merging == null:
		return with
	
	for i in with:
		if !merging.has(i) or (merging.has(i) and overwrite):
			final[i] = with[i]
	return final.duplicate(true)

func get_filelist(scan_dir : String) -> Array:
	var my_files : Array = []
	var dir := Directory.new()
	if dir.open(scan_dir) != OK:
		printerr("Warning: could not open directory: ", scan_dir)
		return []

	if dir.list_dir_begin(true, true) != OK:
		printerr("Warning: could not list contents of: ", scan_dir)
		return []

	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			my_files += get_filelist(dir.get_current_dir() + "/" + file_name)
		else:
			my_files.append(dir.get_current_dir() + "/" + file_name)

		file_name = dir.get_next()

	return my_files

func get_translation_key(key, locale: String = cur_lang) -> String:
	if lang_keys[locale].has(key):
		return lang_keys[locale][key]
	else:
		return key

func get_reference(namespace: String, identifier: String, state: String):
	emit_signal("reference_pulled", namespace, identifier, state, get_references(namespace, identifier)[state])
	return get_references(namespace, identifier)[state]

func get_references(namespace: String, identifier: String):
	return refs[namespace][identifier].states

func get_relay(namespace: String, identifier: String):
	return textureshit[namespace][identifier].relay

func get_state(namespace: String, identifier: String, state: String):
	emit_signal("state_pulled", namespace, identifier, state, get_states(namespace, identifier)[state])
	return get_states(namespace, identifier)[state]

func get_states(namespace: String, identifier: String):
	return textureshit[namespace][identifier].states

func get_tile_script(namespace: String, identifier: String):
	if !mod_objs[namespace][identifier].has("rscript"):
		return
	return load(mod_objs[namespace][identifier].rscript)

func globalvar(_name: String):
	return ProjectSettings.get_setting("global/" + _name)
	
func json_load(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		var dict = {}
		dict = parse_json(file.get_as_text())
		file.close()
		emit_signal("json_loaded", path, dict)
		return dict
	else:
		return {}
		
func json_save(path, content):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(to_json(content))
	file.close()
	emit_signal("json_saved", path, content)

func load_external_tex(path: String, relay: String = "res://textures/misc/missing.png", size = null, flags: int = 0, interp: int = 0):
	var finalpath = "res://textures/misc/missing.png"
	var tex_file = File.new()
	if tex_file.file_exists(relay):
		finalpath = relay
	if tex_file.file_exists(path):
		finalpath = path
	tex_file.open(finalpath, File.READ)
	var img = Image.new()
	if finalpath.begins_with("res://"):
		var tex = load(finalpath).get_data()
		if typeof(tex) == TYPE_RAW_ARRAY:
			img.load_png_from_buffer(tex)
		else:
			img = tex
	else:
		img.load(finalpath)
	var imgtex = ImageTexture.new()
	if typeof(size) == TYPE_VECTOR2:
		img.resize(size.x, size.y, interp)
	imgtex.create_from_image(img)
	imgtex.flags = flags
	tex_file.close()
	emit_signal("texture_loaded", imgtex, path, relay, size, flags, interp)
	return imgtex

func load_game(path):
	var saveload = load("res://scripts/saves.gd").new()
	var thing = saveload._load(path)
	var _unused = get_tree().change_scene("res://scene/Main.tscn")
	yield(get_tree(), "idle_frame")
	get_tree().current_scene.money = Big.new(thing.money)
	get_tree().current_scene.sourcepath = path
	for n in thing.tiles:
		for i in thing.tiles[n]:
			for _i in thing.tiles[n][i]:
				if mod_objs.has(n):
					if mod_objs[n].has(i):
						var tile = Tile.new()
						tile.set_script(load(mod_objs[n][i].rscript))
						if _i.has("persistent_values"):
							tile.persistent_values = _i.persistent_values
						get_tree().current_scene.add_child(tile)
						tile.position = _i.position
						if _i.has("tween"):
							_i.tween.name = "MovementTween"
							tile.add_child(_i.tween)
							tile.get_node("MovementTween").stop(tile.get_node("MovementTween"))
							tile.position = _i.original_position
					else:
						printerr("Error loading save: Tile with identifier \"" + i + "\" doesn't exist on the current context (maybe wrong namespace ?)")
						continue
				else:
					printerr("Error loading save: Namespace \"" + n + "\" doesn't exist on the current context")
					continue
	emit_signal("game_loaded", path)

func load_settings():
	var saveload = load("res://scripts/settings.gd").new()
	var set = saveload._load()
	
	emit_signal("settings_loaded")
	return set

func load_texture(paththing):
	var dict = load_settings()
	var file = File.new()
	if dict.has("texturepack") && dict.texturepack != null:
		if File.new().file_exists(dict.texturepack + "/" + paththing):
			file.close()
			return load_external_tex(dict.texturepack + "/" + paththing)
		else:
			file.close()
			return load_external_tex("res://" + paththing)
	else:
		file.close()
		return load_external_tex("res://" + paththing)

func moddedload(path):
	var file = File.new()
	if !file.file_exists("user://settings.json"):
		file.open("user://settings.json", File.WRITE)
		var defaults = {
			"texturepack": null
		}
		file.store_string(to_json(defaults))
		file.close()
	file.open("user://settings.json", File.READ)
	var dict = {}
	dict = parse_json(file.get_as_text())
	if dict.has("texturepack") && dict.texturepack != null:
		if File.new().file_exists(dict.texturepack + "/" + path):
			file.close()
			return dict.texturepack + "/" + path
		else:
			file.close()
			return "res://" + path
	else:
		file.close()
		return "res://" + path

func move_tile(target: Tile, direction: String, speed: int = 1, direction_inc: int = 64):
	if !target.has_node("MovementTween"):
		var tween = Tween.new()
		tween.name = "MovementTween"
		target.add_child(tween)
	if target.get_node("MovementTween").is_active(): return
	if !target.type == Tile.TILE_MOVABLE: return
	target.original_position = target.position
	var stuff = {}
	match direction:
		"down":
			stuff.property = "position:y"
			stuff.from = target.position.y
			stuff.to = target.position.y + direction_inc
		"up":
			stuff.property = "position:y"
			stuff.from = target.position.y
			stuff.to = target.position.y - direction_inc
		"left":
			stuff.property = "position:x"
			stuff.from = target.position.x
			stuff.to = target.position.x - direction_inc
		"right":
			stuff.property = "position:x"
			stuff.from = target.position.x
			stuff.to = target.position.x + direction_inc
		"upright":
			stuff.property = "position"
			stuff.from = target.position
			stuff.to = target.position + Vector2(direction_inc,direction_inc)
		"upleft":
			stuff.property = "position"
			stuff.from = target.position
			stuff.to = target.position + Vector2(-direction_inc,direction_inc)
		"downright":
			stuff.property = "position"
			stuff.from = target.position
			stuff.to = target.position + Vector2(direction_inc,-direction_inc)
		"downleft":
			stuff.property = "position"
			stuff.from = target.position
			stuff.to = target.position + Vector2(-direction_inc,-direction_inc)
	target.get_node("MovementTween").interpolate_property(
		target,
		stuff.property,
		stuff.from,
		stuff.to,
		speed,
		Tween.TRANS_LINEAR
	)
	target.get_node("MovementTween").start()

func place_item(scene: Node, data: Dictionary, keep_pos: bool = false, _icon: String = "", enforce_placement_rules: bool = true):
	_placement_icon = _icon
	_placement_item = scene
	_placement_data = data
	_keep_pos = keep_pos
	_enforce_placement_rules = enforce_placement_rules
	emit_signal("item_picked", _icon, scene, data, keep_pos)

func save_game(path):
	var saveload = load("res://scripts/saves.gd").new()
	saveload.save(path, get_tree().current_scene)
	emit_signal("game_saved", path)

func save_settings(data):
	var saveload = load("res://scripts/settings.gd").new()
	saveload.save(data)
	emit_signal("settings_saved")

func search_for_modtypes(type, sourceroot: String = "mods"):
	var _stuff = {}
	var dir = Directory.new()
	if !dir.dir_exists("user://" + sourceroot):
		dir.make_dir("user://" + sourceroot)
	else:
		dir.open("user://" + sourceroot)
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var file = File.new()
				if file.file_exists("user://" + sourceroot + "/" + file_name + "/manifest.json"):
					var mod = "user://" + sourceroot + "/" + file_name
					var thing = json_load(mod + "/manifest.json")
					if thing.version_min in globalvar("Tex Version") and globalvar("Tex Version").find(thing.version_min) <= globalvar("Tex Version").find(globalvar("ReleaseNumber")):
						for ii in get_filelist(mod):
							if ii.ends_with(".json"):
								if json_load(ii).has("type"):
									if type is Array:
										if json_load(ii).type in type:
											var identifier: Array = json_load(ii).id.split(":")
											var ns: String
											if identifier.size() == 1:
												if !thing.has("namespace"):
													ns = "unknown"
												else:
													ns = thing.namespace
											else:
												ns = identifier[0]
											if !_stuff.has(ns):
												_stuff[ns] = {}
											_stuff[ns][identifier[1]] = json_load(ii)
											if _stuff[ns][identifier[1]].has("script"):
												if _stuff[ns][identifier[1]].script.begins_with("./"):
													var array = Array(ii.trim_prefix("user://").split("/"))
													array.pop_back()
													_stuff[ns][identifier[1]].script = "user://" + PoolStringArray(array).join("/") + "/" + _stuff[ns][identifier[1]].script.trim_prefix("./")
												elif _stuff[ns][identifier[1]].script.begins_with("user://"):
													pass
												else:
													_stuff[ns][identifier[1]].script = mod + "/" + _stuff[ns][identifier[1]].script
									elif type is String:
										if json_load(ii).type == type:
											var identifier: Array = json_load(ii).id.split(":")
											var ns: String
											if identifier.size() == 1:
												if !thing.has("namespace"):
													ns = "unknown"
												else:
													ns = thing.namespace
											else:
												ns = identifier[0]
											if !_stuff.has(ns):
												_stuff[ns] = {}
											_stuff[ns][identifier[1]] = json_load(ii)
											if _stuff[ns][identifier[1]].has("script"):
												if _stuff[ns][identifier[1]].script.begins_with("./"):
													var array = Array(ii.trim_prefix("user://").split("/"))
													array.pop_back()
													_stuff[ns][identifier[1]].script = "user://" + PoolStringArray(array).join("/") + "/" + _stuff[ns][identifier[1]].script.trim_prefix("./")
												elif _stuff[ns][identifier[1]].script.begins_with("user://"):
													pass
												else:
													
													_stuff[ns][identifier[1]].script = mod + "/" + mod_objs[ns][identifier[1]].script		
			file_name = dir.get_next()
	return _stuff

func set_state(namespace: String, identifier: String, state: String, size = null, flags: int = 0, interp: int = Image.INTERPOLATE_NEAREST):
	if textureshit[namespace][identifier].states.has(state):
		return load_external_tex(textureshit[namespace][identifier].states[state], textureshit[namespace][identifier].relay, size, flags, interp)
	else:
		return load_external_tex(textureshit[namespace][identifier].relay, textureshit[namespace][identifier].relay, size, flags, interp)

func setup_button(node: Button, namespace: String = "", id: String = "", state: String = "", size=Vector2(32, 32), recticonname: String = "", flags = 0, interps = 0, add_rect: bool = false, button_size: Vector2 = Vector2(64,64), button_symmetry: bool = true):
	if namespace == "":
		if id != "":
			namespace = "unknown"
	var styleboxnew: StyleBox = load(get_reference("builtins", "styleboxes", "button")).duplicate(true)
	if styleboxnew is StyleBoxTexture:
		styleboxnew.texture = set_state("builtins", "graphic_user_interface", "button_off", Vector2(64,64), 0, 0)
	node.add_stylebox_override("normal", styleboxnew)
	
	styleboxnew = load(get_reference("builtins", "styleboxes", "button")).duplicate(true)
	if styleboxnew is StyleBoxTexture:
		styleboxnew.texture = set_state("builtins", "graphic_user_interface", "button_on", Vector2(64,64), 0, 0)
	node.add_stylebox_override("pressed", styleboxnew)
	
	styleboxnew = load(get_reference("builtins", "styleboxes", "button")).duplicate(true)
	if styleboxnew is StyleBoxTexture:
		styleboxnew.texture = set_state("builtins", "graphic_user_interface", "button_off", Vector2(64,64), 0, 0)
	node.add_stylebox_override("hover", styleboxnew)
	
	styleboxnew = load(get_reference("builtins", "styleboxes", "button")).duplicate(true)
	if styleboxnew is StyleBoxTexture:
		styleboxnew.texture = set_state("builtins", "graphic_user_interface", "button_disabled", Vector2(64,64), 0, 0)
	node.add_stylebox_override("disabled", styleboxnew)
	
	setup_font(node)
	
	node.focus_mode = Control.FOCUS_CLICK
	
	if namespace != "" and id != "" and state != "":
		var temp = BaseFuncs.set_state(namespace, id, state, size, flags, interps)
		var childisrect = false
		var childname
		if add_rect:
			for i in node.get_children():
				if i is TextureRect:
					childisrect = true
					childname = i.name
					break
			if !childisrect:
				var Icon = TextureRect.new()
				if recticonname != "":
					Icon.name = recticonname
					childname = recticonname
				else:
					Icon.name = "Icon"
					childname = "Icon"
				node.add_child(Icon)
		temp.set_flags(flags)
		if add_rect:
			node.get_node(childname).texture = temp
		node.set_button_icon(temp)
		if add_rect:
			node.icon = null
			node.rect_min_size = button_size
			node.rect_size = button_size
			node.get_node(childname).rect_min_size = size
			node.get_node(childname).rect_size = size
			node.get_node(childname).set_margins_preset(Control.PRESET_CENTER)
			node.get_node(childname).set_anchors_preset(Control.PRESET_CENTER)
			if node.rect_size.x != node.rect_size.y and button_symmetry:
				var greatest = vector2_greatest(node.rect_size)
				node.rect_min_size.x = greatest
				node.rect_min_size.y = greatest
				node.rect_size.x = greatest
				node.rect_size.y = greatest
		node.focus_mode = Control.FOCUS_ALL

func setup_font(_self: Node, namespace: String = "builtins", source: String = "fonts", font: String = "default", size: int = 16, fonttype: int = font_type.REGULAR):
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load(get_reference(namespace, source, font))
	dynamic_font.size = size
	match fonttype:
		font_type.REGULAR:
			_self.add_font_override("normal_font", dynamic_font)
			_self.add_font_override("font", dynamic_font)
		font_type.BOLD:
			_self.add_font_override("bold_font", dynamic_font)
		font_type.ITALICS:
			_self.add_font_override("italics_font", dynamic_font)
		font_type.BOLDITALICS:
			_self.add_font_override("bold_italics_font", dynamic_font)
		font_type.MONO:
			_self.add_font_override("mono_font", dynamic_font)

func vector2_both_gthan(Left: Vector2, Right: Vector2):
	if Left.x >= Right.x and Left.y >= Right.y:
		return true
	else:
		return false
	
func vector2_both_lthan(Left: Vector2, Right: Vector2):
	if Left.x <= Right.x and Left.y <= Right.y:
		return true
	else:
		return false

func vector2_greatest(Vector: Vector2):
	if Vector.x == Vector.y:
		return Vector.x
	elif Vector.x > Vector.y:
		return Vector.x
	elif Vector.y > Vector.x:
		return Vector.y

func vector2_gthan(Left: Vector2, Right: Vector2):
	var comparsion: Array = [Left.x > Right.x, Left.y > Right.y]
	return comparsion

func vector2_lesser(Vector: Vector2):
	if Vector.x == Vector.y:
		return Vector.x
	elif Vector.x < Vector.y:
		return Vector.x
	elif Vector.y < Vector.x:
		return Vector.y	

func vector2_lthan(Left: Vector2, Right: Vector2):
	var comparsion: Array = [Left.x < Right.x, Left.y < Right.y]
	return comparsion
