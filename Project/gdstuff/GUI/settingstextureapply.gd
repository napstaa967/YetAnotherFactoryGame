extends Button

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = get_tree().current_scene.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = get_tree().current_scene.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)

func _pressed():
	print("1")
	var file = File.new()
	if !file.file_exists("user://settings.json"):
		print("2")
		if file.open("user://settings.json", File.WRITE) != OK:
			print("Error opening file")
			print("3")
		else:
			print("4")
			var defaults = {
				"texturepack": null
			}
			file.store_line(to_json(defaults))
			file.close()
			print("5")
			return
	else:
		print("6")
		file.open("user://settings.json", File.READ_WRITE)
		var dict = {}
		print("7")
		dict = parse_json(file.get_as_text())
		dict.texturepack = get_parent().get_node("Label/TextEdit").text
		print(dict)
		print("8")
		var stff = (to_json(dict))
		print(stff)
		print("9")
		file.store_string(stff)
		print(file.get_as_text())
		print("10")
		file.close()
		print("11")
		return
