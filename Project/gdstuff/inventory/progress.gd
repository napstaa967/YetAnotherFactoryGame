extends TextureProgress

func _ready():
	texture_under = get_tree().current_scene.load_texture("textures/gui/inv/machine_arrow_off.png")
	texture_progress = get_tree().current_scene.load_texture("textures/gui/inv/machine_arrow_on.png")
	
func _process(_delta):
	if get_parent().get_parent().get_parent().get_parent().get_node("ConvertTimer").is_stopped():
		value = 0
		return
	match stepify(get_parent().get_parent().get_parent().get_parent().get_node("ConvertTimer").time_left * 5, 0.1):
		5.0:
			print("shit3")
			value = 0
		4.5:
			print("shit2")
			value = 0.5
		4.0:
			print("shit2")
			value = 1
		3.5:
			print("shit")
			value = 1.5
		3.0:
			print("shit")
			value = 2
		2.5:
			print("shi")
			value = 2.5
		2.0:
			print("shi")
			value = 3
		1.5:
			print("sh")
			value = 3.5
		1.0:
			print("sh")
			value = 4
		0.5:
			print("sh")
			value = 4.5
		0.0:
			print("sh")
			value = 5
		
