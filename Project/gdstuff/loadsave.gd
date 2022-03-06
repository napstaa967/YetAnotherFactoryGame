extends Button

func _ready():
	var temp = Main.load_texture("textures/gui/save_{name}.png".format({"name": self.name}))
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
		
func _pressed():
	if self.name == "load":
		Main.load_game()
		return
	if self.name == "create":
		get_child(0).popup()
		Main.save_game()
		return

