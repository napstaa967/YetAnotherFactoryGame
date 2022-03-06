extends Button

func _ready():
	var temp = Main.load_texture("textures/gui/settings.png")
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
