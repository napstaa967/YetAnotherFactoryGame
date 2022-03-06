extends Camera2D

func _ready():
	make_current()
	Main.camera = self

func _process(_delta):
	if position.x < 0:
		position.x = 0
	if position.y < 0:
		position.y = 0
	if Main.camlock == false:
		if (get_global_mouse_position().x > position.x && get_global_mouse_position().x < position.x + 16) && position.x > 0:
			position.x -= 8
		if (get_global_mouse_position().y > position.y && get_global_mouse_position().y < position.y + 16) && position.y > 0:
			position.y -= 8
		if get_global_mouse_position().x < position.x + get_viewport_rect().size.x && get_global_mouse_position().x > position.x + + get_viewport_rect().size.x - 32:
			position.x += 8
		if get_global_mouse_position().y < position.y + get_viewport_rect().size.y && get_global_mouse_position().y > position.y + get_viewport_rect().size.y - 32:
			position.y += 8
