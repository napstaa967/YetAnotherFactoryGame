extends Button


# Declare member variables here. Examples:
# var a = 2
var id = "placeholder_item"
var type = "item"
var metadata = {
	"type": "item",
	"name": "pussyfart",
	"desc": "pussy shit",
	"spritepath": "items/flushsit.png",
	"direction": null,
	"colliding": null,
	"sell": 50
}
	
func _ready():
	var temp = get_tree().current_scene.load_texture("textures/" + metadata.spritepath)
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/item.tscn", metadata.duplicate())
	
func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
