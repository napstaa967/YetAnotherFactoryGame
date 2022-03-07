extends Label

func _process(_delta):
	text = str(get_tree().current_scene.get_meta("metadata").money)
