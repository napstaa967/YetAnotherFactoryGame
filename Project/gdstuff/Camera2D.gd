extends Camera2D

func _ready():
	make_current()
	get_tree().current_scene.camera = self
