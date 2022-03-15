extends NinePatchRect

func _ready():
	texture = get_tree().current_scene.load_texture("textures/gui/border.png")

func _process(_delta):
	rect_size = get_viewport_rect().size
