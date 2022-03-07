extends Button

var metadata = {
	"type": "remove",
	"mode": "oneshot"
}

func _ready():
	text = metadata.mode
	var temp = get_tree().current_scene.load_texture("textures/misc/remove_{mode}.png".format({ "mode": metadata.mode }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/remove_tool.tscn", metadata.duplicate())

func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
	if event is InputEventKey and event.pressed and pressed:
		if Input.is_action_just_pressed("ui_select"):
			if metadata.mode == "oneshot":
				metadata.mode = "persistent"
				var temp = get_tree().current_scene.load_texture("textures/misc/remove_{mode}.png".format({ "mode": metadata.mode }))
				temp.set_size_override(Vector2(32, 32))
				text = metadata.mode
				return set_button_icon(temp)
			if metadata.mode == "persistent":
				metadata.mode = "seller"
				var temp = get_tree().current_scene.load_texture("textures/misc/remove_{mode}.png".format({ "mode": metadata.mode }))
				temp.set_size_override(Vector2(32, 32))
				text = metadata.mode
				return set_button_icon(temp)
			if metadata.mode == "seller":
				metadata.mode = "oneshot"
				var temp = get_tree().current_scene.load_texture("textures/misc/remove_{mode}.png".format({ "mode": metadata.mode }))
				temp.set_size_override(Vector2(32, 32))
				text = metadata.mode
				return set_button_icon(temp)
