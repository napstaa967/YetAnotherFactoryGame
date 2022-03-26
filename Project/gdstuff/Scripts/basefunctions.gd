extends Node

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

func loadoverrides(textureoverrides, target, meta, oldtex, type):
	if textureoverrides == null:
		var texturestuff = { "tex": "textures/misc/missing.png" }
		return texturestuff
	var texturestuff = { "tex" : oldtex }
	for iii in textureoverrides:
		if typeof(textureoverrides[iii]) != TYPE_DICTIONARY:
			match iii:
				"default_texture": 
					if File.new().file_exists(BaseFuncs.moddedload(textureoverrides.default_texture)):
						textureoverrides.default_texture = textureoverrides[iii]
					else:
						textureoverrides.default_texture = "textures/misc/missing.png"
				"auto_rotate":
					if textureoverrides[iii]:
						var direction2 = {"down": 0, "left": 90, "up": 180, "right": 270}
						match textureoverrides.default_texture_direction:
							"down":
								direction2 = {"down": 0, "left": 90, "up": 180, "right": 270}
							"left":
								direction2 = {"down": 270, "left": 0, "up": 90, "right": 180}
							"up":
								direction2 = {"down": 180, "left": 270, "up": 0, "right": 90}
							"right":
								direction2 = {"down": 90, "left": 180, "up": 270, "right": 0}
						texturestuff.tex = textureoverrides.default_texture
						if target is Sprite:
							target.rotation_degrees = direction2[meta.direction]
						else:
							target.rect_pivot_offset = Vector2(target.rect_size.x/2, target.rect_size.y/2)
							target.rect_rotation = direction2[meta.direction]
				"default_texture_rotation":
					if target is Sprite:
						target.rotation_degrees = int(textureoverrides[iii])
					else:
						target.rect_pivot_offset = Vector2(target.rect_size.x/2, target.rect_size.y/2)
						target.rect_rotation = int(textureoverrides[iii])
	#applying
	texturestuff.tex = textureoverrides.default_texture
	match type:
		"normal":
			if textureoverrides.has("overrides"):
				for i in textureoverrides.overrides:
					var override = textureoverrides.overrides[i]
					if !override.has("enable") || override.enable == true:
						if i == "all" || (i == meta.direction || ((i == "leftright" && (meta.direction == "left" || meta.direction == "right")) || (i == "updown" && (meta.direction == "up" || meta.direction == "down")))):
							for ii in override:
								match ii:
									"rotation":
										if target is Sprite:
											target.rotation_degrees = override.rotation
										else:
											target.rect_pivot_offset = Vector2(target.rect_size.x/2, target.rect_size.y/2)
											target.rect_rotation = override.rotation
									"path":
										if File.new().file_exists(BaseFuncs.moddedload(override.path)):
											texturestuff.tex = override.path
									"flipx":
										target.flip_h = bool(override.flipx)
									"flipy":
										target.flip_v = bool(override.flipy)
									"auto_rotate":
										if override[ii]:
											var direction = {"down": 0, "left": 90, "up": 180, "right": 270}
											match textureoverrides.default_texture_direction:
												"down":
													direction = {"down": 0, "left": 90, "up": 180, "right": 270}
												"left":
													direction = {"down": 270, "left": 0, "up": 90, "right": 180}
												"up":
													direction = {"down": 180, "left": 270, "up": 0, "right": 90}
												"right":
													direction = {"down": 90, "left": 180, "up": 270, "right": 0}
											texturestuff.tex = textureoverrides.default_texture
											if target is Sprite:
												target.rotation_degrees = direction[meta.direction]
											else:
												target.rect_pivot_offset = Vector2(target.rect_size.x/2, target.rect_size.y/2)
												target.rect_rotation = direction[meta.direction]
			else:
				continue
		"icon":
			if textureoverrides.has("icon_overrides"):
				for i in textureoverrides.icon_overrides:
					var override = textureoverrides.icon_overrides[i]
					if !override.has("enable") || override.enable == true:
						if i == "all" || (i == meta.direction || ((i == "leftright" && (meta.direction == "left" || meta.direction == "right")) || (i == "updown" && (meta.direction == "up" || meta.direction == "down")))):
							for ii in override:
								match ii:
									"use_default_icon":
										if override[ii]:
											if textureoverrides.has("overrides") && textureoverrides.overrides.has(meta.direction) && textureoverrides.overrides[meta.direction].has("path"):
												texturestuff.tex = textureoverrides.overrides[meta.direction].path
											else:
												texturestuff.tex = textureoverrides.default_texture
									"rotation":
										if target is Sprite:
											target.rotation_degrees = override[ii]
										else:
											target.rect_pivot_offset = Vector2(target.rect_size.x/2, target.rect_size.y/2)
											target.rect_rotation = override[ii]
									"path":
										if File.new().file_exists(BaseFuncs.moddedload(override[ii])):
											texturestuff.tex = override[ii]
									"flipx":
										target.flip_h = bool(override[ii])
									"flipy":
										target.flip_v = bool(override[ii])
									"auto_rotate":
										if override[ii]:
											var direction = {"down": 0, "left": 90, "up": 180, "right": 270}
											match textureoverrides.default_texture_direction:
												"down":
													direction = {"down": 0, "left": 90, "up": 180, "right": 270}
												"left":
													direction = {"down": 270, "left": 0, "up": 90, "right": 180}
												"up":
													direction = {"down": 180, "left": 270, "up": 0, "right": 90}
												"right":
													direction = {"down": 90, "left": 180, "up": 270, "right": 0}
											texturestuff.tex = textureoverrides.default_texture
											if target is Sprite:
												target.rotation_degrees = direction[meta.direction]
											else:
												target.rect_pivot_offset = Vector2(target.rect_size.x/2, target.rect_size.y/2)
												target.rect_rotation = direction[meta.direction]
			else:
				continue
	if textureoverrides.has("custom_overrides"):
		texturestuff.unhandled_overrides = textureoverrides.custom_overrides
	return texturestuff

func load_texture(paththing):
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
