extends Button

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
		print("8")
		var stff = (to_json(dict))
		print("9")
		file.store_line(stff)
		print("10")
		file.close()
		print("11")
		return
