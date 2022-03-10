extends TextEdit

func _ready():
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
	print(parse_json(file.get_as_text()))
	print(file.get_as_text())
	dict = parse_json(file.get_as_text())
	if dict.has("texturepack") && dict.texturepack != null:
		text = dict.texturepack
	file.close()
