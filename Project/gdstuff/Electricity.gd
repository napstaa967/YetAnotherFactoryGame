extends TextureRect

func _ready():
	print("text")
	$FadeoutTimer.set_wait_time(0.01)
	texture = get_tree().current_scene.load_texture("textures/gui/electricty.png")
	update()

func update():
	pass
	modulate.a = 1
	while modulate.a > 0:
		modulate.a -= 0.01
		$FadeoutTimer.start()
		yield($FadeoutTimer, "timeout")
