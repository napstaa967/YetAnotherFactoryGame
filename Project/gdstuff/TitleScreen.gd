extends Node2D
var camera
var camlock = false

func new_game(path):
	return SimpleSave.new_game(get_tree(), path)

func load_game(path):
	SimpleSave.load_scene(get_tree(), path)

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

func load_texture(paththing):
	var file = File.new()
	if !file.file_exists("user://settings.json"):
		file.open("user://settings.json", File.WRITE)
		var defaults = {
			"texturepack": null
		}
		file.store_line(to_json(defaults))
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
