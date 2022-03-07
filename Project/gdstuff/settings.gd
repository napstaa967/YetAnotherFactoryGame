extends Button

func _ready():
	var temp = get_tree().current_scene.load_texture("textures/gui/settings.png")
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
