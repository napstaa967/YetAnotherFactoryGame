extends Resource

class_name Saves

export var tiles := {}
export var sourcepath := "user://saves/save.tres"
export var money := 0.0

func save(path: String, scene: Node2D) -> void:
	for i in scene.get_children():
		if i is Tile:
			var toappend = {
				"persistent_values": i.persistent_values,
				"position": i.position,
				"original_position": i.original_position
			}
			if i.has_node("MovementTween"):
				var b: Tween = i.get_node("MovementTween").duplicate()
				b.set_active(false)
				toappend.tween = b
			if !tiles.has(i.namespace):
				tiles[i.namespace] = {}
			if !tiles[i.namespace].has(i.identifier):
				tiles[i.namespace][i.identifier] = [toappend]
			else:
				tiles[i.namespace][i.identifier].append(toappend)
				
	sourcepath = path
	money = scene.money.toFloat()
	var _unused = ResourceSaver.save(path, self)

func _load(path: String):
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path)
