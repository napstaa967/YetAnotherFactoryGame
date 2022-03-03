extends Button

var metadata = {
	"speed": 1,
	"type": "conveyor",
	"horientation": "down_up",
	"type2": "splitter",
	"direction": "down"
}

func _ready():
	text = metadata.horientation
	var temp = Main.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
		
func _pressed():
	Main.place_item("res://scene/test_conveyor.tscn", metadata.duplicate())
	
func gui_input(event):
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("change_item_left") || Input.is_action_just_pressed("change_item_right"):
			metadata.horientation = "left_right"
			metadata.direction = "left"
		if Input.is_action_just_pressed("change_item_up") || Input.is_action_just_pressed("change_item_down"):
			metadata.horientation = "down_up"
			metadata.direction = "down"
		text = metadata.horientation
		var temp = Main.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
		temp.set_size_override(Vector2(32, 32))
		set_button_icon(temp)
