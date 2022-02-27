extends Area2D

signal conveyor_move

export(Dictionary) var metadata = {
	"speed": 1,
	"type": "conveyor",
	"direction": "down"
}

onready var metadata2

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
	
var firsttime = true

func _ready():
	metadata2 = get_parent().metadata
	var texturestuff = "textures/conveyor_placeholder/{direction}.png".format({"direction": metadata2.direction})
	if File.new().file_exists("user://TexturePack/" + texturestuff):
		get_child(0).texture = load_external_tex("user://TexturePack/" + texturestuff)
	else:
		get_child(0).texture = load("res://" + texturestuff)


func _on_test_conveyor_body_entered(_body):
	emit_signal("conveyor_move")

func _process(_delta):
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get("type") != null:
			if area.type == "item":
				match metadata2.direction:
					"down":
						area.position.y += 1
					"up":
						area.position.y -= 1
					"left":
						area.position.x -= 1
					"right":
						area.position.x += 1
				
