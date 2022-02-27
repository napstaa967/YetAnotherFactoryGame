extends Area2D

signal conveyor_move

export var speed = 1 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var type = "conveyor"

func _ready():
	screen_size = get_viewport_rect().size

func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex

func _on_seller_area_entered(area):
	if area.type != "item":
		 return
	print("fart")
	for child in get_children():
		if child.has_method("turn_on"):
			child.turn_on()
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	area.queue_free()
	yield(t, "timeout")
	t.queue_free()
	for child in get_children():
		if child.has_method("turn_off"):
			child.turn_off()
