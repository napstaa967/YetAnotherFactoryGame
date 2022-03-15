extends Button

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = get_tree().current_scene.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = get_tree().current_scene.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)
	var temp = get_tree().current_scene.load_texture("textures/gui/save_load.png")
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
	icon.set_flags(0)

func _pressed():
	get_node("FileDialog").popup()
	

func file_selected(path):
	get_tree().current_scene.load_game(path)
	return
