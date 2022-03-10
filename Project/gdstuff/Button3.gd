extends Button

var metadata = {
	"speed": 1,
	"type": "splitter",
	"horientation": "down_up",
	"direction": "down",
	"sell": 100,
	"buy": 200,
	"elec": 10,
	"placing": false
}
var currentmode = "horientation"

func _ready():
	text = "2-Way Splitter"
	var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/test_conveyor.tscn", metadata.duplicate())
	
func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("change_item_general"):
			match currentmode:
				"horientation":
					currentmode = "direction"
				"direction":
					currentmode = "horientation"
			return
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("three"):
			metadata.type = "trisplitter"
			text = "3-Way Splitter"
			return
		if Input.is_action_just_pressed("two"):
			metadata.type = "splitter"
			text = "2-Way Splitter"
			return
	if event is InputEventKey and event.pressed and pressed:
		match metadata.type:
			"splitter":
				match currentmode:
					"horientation":
						if Input.is_action_just_pressed("change_item_left") || Input.is_action_just_pressed("change_item_right"):
							metadata.horientation = "left_right"
							metadata.direction = "left"
							var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
							temp.set_size_override(Vector2(32, 32))
							return set_button_icon(temp)
						if Input.is_action_just_pressed("change_item_up") || Input.is_action_just_pressed("change_item_down"):
							metadata.horientation = "down_up"
							metadata.direction = "down"
							var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
							temp.set_size_override(Vector2(32, 32))
							return set_button_icon(temp)
					"direction":
						if Input.is_action_just_pressed("change_item_left"):
							metadata.horientation = "down_left"
							metadata.direction = "left"
							var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
							temp.set_size_override(Vector2(32, 32))
							return set_button_icon(temp)
						if Input.is_action_just_pressed("change_item_right"):
							metadata.horientation = "up_right"
							metadata.direction = "right"
							var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
							temp.set_size_override(Vector2(32, 32))
							return set_button_icon(temp)
						if Input.is_action_just_pressed("change_item_up"):
							metadata.horientation = "up_left"
							metadata.direction = "left"
							var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
							temp.set_size_override(Vector2(32, 32))
							return set_button_icon(temp)
						if Input.is_action_just_pressed("change_item_down"):
							metadata.horientation = "down_right"
							metadata.direction = "right"
							var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
							temp.set_size_override(Vector2(32, 32))
							return set_button_icon(temp)
			"trisplitter":
				if Input.is_action_just_pressed("change_item_left"):
					metadata.horientation = "left_up_down"
					metadata.direction = "left"
					var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/threeway/{hori}.png".format({ "hori": metadata.horientation }))
					temp.set_size_override(Vector2(32, 32))
					return set_button_icon(temp)
				if Input.is_action_just_pressed("change_item_right"):
					metadata.horientation = "right_up_down"
					metadata.direction = "right"
					var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/threeway/{hori}.png".format({ "hori": metadata.horientation }))
					temp.set_size_override(Vector2(32, 32))
					return set_button_icon(temp)
				if Input.is_action_just_pressed("change_item_up"):
					metadata.horientation = "up_left_right"
					metadata.direction = "up"
					var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/threeway/{hori}.png".format({ "hori": metadata.horientation }))
					temp.set_size_override(Vector2(32, 32))
					return set_button_icon(temp)
				if Input.is_action_just_pressed("change_item_down"):
					metadata.horientation = "down_left_right"
					metadata.direction = "down"
					var temp = get_tree().current_scene.load_texture("textures/conveyor/splitter/threeway/{hori}.png".format({ "hori": metadata.horientation }))
					temp.set_size_override(Vector2(32, 32))
					return set_button_icon(temp)
