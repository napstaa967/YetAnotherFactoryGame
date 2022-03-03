extends Area2D

var type = "conveyor"

func _ready():
	get_child(0).texture = Main.load_texture("textures/seller/seller_on.png")
	get_child(0).scale = Vector2(64/get_child(1).texture.get_size().x, 64/get_child(1).texture.get_size().y)
	get_child(2).set_wait_time(1)

func _process(_delta):
	for item in get_overlapping_areas():
		if item.position == position:
			get_child(0).texture = Main.load_texture("textures/seller/seller_on.png")
			get_child(0).scale = Vector2(64/get_child(1).texture.get_size().x, 64/get_child(1).texture.get_size().y)
			item.free
			if !get_child(2).is_stopped():
				get_child(2).stop()
			get_child(2).start()
			yield(get_child(2), "timeout")

func _on_seller_area_entered(area):
	if area.type != "item":
		 return
	print("fart")
	for child in get_children():
		if child.has_method("turn_on"):
			child.turn_on()


func timeout():
	get_child(0).texture = Main.load_texture("textures/seller/seller_off.png")
	get_child(0).scale = Vector2(64/get_child(1).texture.get_size().x, 64/get_child(1).texture.get_size().y)
