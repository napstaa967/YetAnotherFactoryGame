extends Button

func _ready():
	var temp = get_tree().current_scene.load_texture("textures/gui/camera_locked.png")
	if get_tree().current_scene.camlock == false:
		temp = get_tree().current_scene.load_texture("textures/gui/camera_unlocked.png")
	elif get_tree().current_scene.camlock == true:
		temp = get_tree().current_scene.load_texture("textures/gui/camera_locked.png")
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
		
func _pressed():
	if get_tree().current_scene.camlock == false:
		var temp = get_tree().current_scene.load_texture("textures/gui/camera_locked.png")
		temp.set_size_override(Vector2(64, 64))
		set_button_icon(temp)
		get_tree().current_scene.camlock = true
		return
	if get_tree().current_scene.camlock == true:
		var temp = get_tree().current_scene.load_texture("textures/gui/camera_unlocked.png")
		temp.set_size_override(Vector2(64, 64))
		set_button_icon(temp)
		get_tree().current_scene.camlock = false
		return

