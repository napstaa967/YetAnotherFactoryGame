extends Button

var metadata = {
	"type": "converter",
	"direction": "down",
	"sell": 300,
	"buy": 600,
	"elec": 15,
	"items": [],
	"placing": false
}

func _ready():
	text = "Converter"
	var temp = get_tree().current_scene.load_texture("textures/machinery/converter/{direction}.png".format({ "direction": metadata.direction }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
	
func _pressed():
	get_tree().current_scene.place_item("res://scene/Machine.tscn", metadata.duplicate())


func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
		if Input.is_action_just_pressed("change_item_left"):
			metadata.direction = "left"
			var temp = get_tree().current_scene.load_texture("textures/machinery/converter/{dir}.png".format({ "dir": metadata.direction }))
			temp.set_size_override(Vector2(32, 32))
			return set_button_icon(temp)
		if Input.is_action_just_pressed("change_item_right"):
			metadata.direction = "right"
			var temp = get_tree().current_scene.load_texture("textures/machinery/converter/{dir}.png".format({ "dir": metadata.direction }))
			temp.set_size_override(Vector2(32, 32))
			return set_button_icon(temp)
		if Input.is_action_just_pressed("change_item_up"):
			metadata.direction = "up"
			var temp = get_tree().current_scene.load_texture("textures/machinery/converter/{dir}.png".format({ "dir": metadata.direction }))
			temp.set_size_override(Vector2(32, 32))
			return set_button_icon(temp)
		if Input.is_action_just_pressed("change_item_down"):
			metadata.direction = "down"
			var temp = get_tree().current_scene.load_texture("textures/machinery/converter/{dir}.png".format({ "dir": metadata.direction }))
			temp.set_size_override(Vector2(32, 32))
			return set_button_icon(temp)

