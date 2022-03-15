extends Button

var metadata = {
	"speed": 1,
	"type": "conveyor",
	"direction": "down",
	"sell": 50,
	"buy": 100,
	"elec": 1,
	"placing": false
}

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = get_tree().current_scene.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = get_tree().current_scene.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)
	text = "Conveyor"
	var temp = get_tree().current_scene.load_texture("textures/conveyor/normal/{direction}.png".format({ "direction": metadata.direction }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
	icon.set_flags(0)
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/test_conveyor.tscn", metadata.duplicate())


func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("change_item_left"):
			metadata.direction = "left"
		if Input.is_action_just_pressed("change_item_right"):
			metadata.direction = "right"
		if Input.is_action_just_pressed("change_item_up"):
			metadata.direction = "up"
		if Input.is_action_just_pressed("change_item_down"):
			metadata.direction = "down"
		var temp = get_tree().current_scene.load_texture("textures/conveyor/normal/{direction}.png".format({ "direction": metadata.direction }))
		temp.set_size_override(Vector2(32, 32))
		set_button_icon(temp)
		return

