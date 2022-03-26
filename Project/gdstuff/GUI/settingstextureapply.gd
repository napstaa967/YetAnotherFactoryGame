extends Button

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)

func _pressed():
	var file = File.new()
	if !file.file_exists("user://settings.json"):
		if file.open("user://settings.json", File.WRITE) != OK:
			print("Error opening file")
			file.close()
		else:
			var defaults = {
				"texturepack": null
			}
			file.store_string(to_json(defaults))
			file.close()
			return
	else:
		file.open("user://settings.json", File.READ)
		var dict = {}
		dict = parse_json(file.get_as_text())
		dict.texturepack = get_parent().get_node("Label/TextEdit").text
		var stff = (to_json(dict))
		file.close()
		file.open("user://settings.json", File.WRITE)
		file.store_string(stff)
		file.close()
		return
