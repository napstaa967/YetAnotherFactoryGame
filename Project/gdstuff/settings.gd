extends Button

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	var temp = BaseFuncs.load_texture("textures/gui/settings.png")
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
	icon.set_flags(0)

func _pressed():
	get_tree().current_scene.get_node("CanvasLayer").add_child(load("res://scene/Settings.tscn").instance())
