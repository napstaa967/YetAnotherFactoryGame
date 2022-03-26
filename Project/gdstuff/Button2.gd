extends Button


# Declare member variables here. Examples:
# var a = 2
var id = "placeholder_item"
var type = "item"
var metadata = {
	"type": "item",
	"denom": "flush_sit",
	"name": "pussyfart",
	"desc": "pussy shit",
	"spritepath": "textures/items/flushsit.png",
	"direction": null,
	"colliding": null,
	"sell": 100,
	"placing": false,
	"justplaced": false
}

var itemdata = [
	{"type": "item","denom": "bop","name": "La creatura","desc": "No Way","spritepath": "textures/items/bop.png","direction": null,"colliding": null,"sell": 200,"placing": false,"justplaced": false},
	{"type": "item","denom": "flush_sit","name": "pussyfart","desc": "pussy shit","spritepath": "textures/items/flushsit.png","direction": null,"colliding": null,"sell": 100,"placing": false,"justplaced": false}
]

var curselected = 0
	
func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)
	var temp = BaseFuncs.load_texture(metadata.spritepath)
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
	icon.set_flags(0)
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/item.tscn", metadata.duplicate())
	
func gui_input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("change_item_general"):
			if curselected < itemdata.size() - 1:
				curselected += 1
			else:
				curselected = 0
			metadata = itemdata[curselected]
			var temp = BaseFuncs.load_texture(metadata.spritepath)
			temp.set_size_override(Vector2(32, 32))
			set_button_icon(temp)
			return
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
