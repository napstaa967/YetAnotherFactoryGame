extends Button

func _ready():
	var temp = Main.load_texture("textures/gui/camera_locked.png")
	if Main.camlock == false:
		temp = Main.load_texture("textures/gui/camera_unlocked.png")
	elif Main.camlock == true:
		temp = Main.load_texture("textures/gui/camera_locked.png")
	temp.set_size_override(Vector2(64, 64))
	set_button_icon(temp)
		
func _pressed():
	if Main.camlock == false:
		var temp = Main.load_texture("textures/gui/camera_locked.png")
		temp.set_size_override(Vector2(64, 64))
		set_button_icon(temp)
		Main.camlock = true
		return
	if Main.camlock == true:
		var temp = Main.load_texture("textures/gui/camera_unlocked.png")
		temp.set_size_override(Vector2(64, 64))
		set_button_icon(temp)
		Main.camlock = false
		return

