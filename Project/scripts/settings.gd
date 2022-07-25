extends Resource

class_name Settings

export var other := {}
export var zoom := 1
export var lang := "en_US"

func save(data) -> void:
	for i in data.keys():
		if i == "lang":
			lang = data.lang
		elif i == "zoom":
			zoom = data.zoom
		else:
			other[i] = data[i]
			
	ResourceSaver.save("user://settings.res", self)
	
func _load():
	if ResourceLoader.exists("user://settings.res"):
		return ResourceLoader.load("user://settings.res")
	else:
		var _discard = ResourceSaver.save("user://settings.res", self)
		return ResourceLoader.load("user://settings.res")
