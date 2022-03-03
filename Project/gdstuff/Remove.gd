extends Button

var metadata = {
	"type": "remove"
}

func _ready():
	var temp = Main.load_texture("textures/misc/remove.png")
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
		
func _pressed():
	Main.place_item("res://scene/remove_tool.tscn", metadata.duplicate())
