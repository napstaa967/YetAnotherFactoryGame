extends Button

func _ready():
	BaseFuncs.setup_button(self, "builtins", "graphic_user_interface", "credits")

func _pressed():
	if self.name == "Credits": BaseFuncs.cc = false
	elif self.name == "Changelogs": BaseFuncs.cc = true
	return get_tree().change_scene("res://scene/Credits.tscn")
