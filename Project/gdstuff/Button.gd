extends Button

var metadata = {
	"speed": 1,
	"type": "conveyor",
	"direction": "down",
	"type2": "normal"
}

func _ready():
	text = metadata.direction
	var temp = Main.load_texture("textures/conveyor/normal/{direction}.png".format({ "direction": metadata.direction }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
		
func _pressed():
	Main.place_item("res://scene/test_conveyor.tscn", metadata.duplicate())


func gui_input(event):
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("change_item_left"):
			metadata.direction = "left"
		if Input.is_action_just_pressed("change_item_right"):
			metadata.direction = "right"
		if Input.is_action_just_pressed("change_item_up"):
			metadata.direction = "up"
		if Input.is_action_just_pressed("change_item_down"):
			metadata.direction = "down"
		text = metadata.direction
		var temp = Main.load_texture("textures/conveyor/normal/{direction}.png".format({ "direction": metadata.direction }))
		temp.set_size_override(Vector2(32, 32))
		set_button_icon(temp)
