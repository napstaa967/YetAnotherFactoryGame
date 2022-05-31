extends Button

var metadata = {
	"speed": 1,
	"type": "splitter",
	"horientation": "down_up",
	"direction": "down",
	"sell": 100,
	"buy": 200,
	"elec": 1,
	"placing": false
}
var currentmode = "horientation"

func _ready():
	var styleboxnew = get_stylebox("normal")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("normal" ,styleboxnew)
	styleboxnew = get_stylebox("pressed")
	styleboxnew.texture = BaseFuncs.load_texture("textures/gui/button_pressed.png")
	styleboxnew.texture.set_flags(0)
	add_stylebox_override("pressed" ,styleboxnew)
	text = "2-Way Splitter"
	var temp = BaseFuncs.load_texture("textures/conveyor/splitter/{hori}.png".format({ "hori": metadata.horientation }))
	temp.set_size_override(Vector2(32, 32))
	set_button_icon(temp)
	icon.set_flags(0)
	textupdate()
		
func _pressed():
	get_tree().current_scene.place_item("res://scene/Conveyor.tscn", metadata.duplicate())

func textupdate():
	match metadata.type:
		"trisplitter":
				var file = File.new()
				var texturestuff = "textures/conveyor/trisplitter/trisplitter.png"
				if !file.file_exists(BaseFuncs.moddedload("textures/conveyor/trisplitter/texture_override.json")):
					texturestuff = "textures/conveyor/trisplitter/trisplitter.png"
					var texturest = BaseFuncs.load_texture(texturestuff)
					texturest.set_size_override(Vector2(32, 32))
					texturest.set_flags(0)
					set_button_icon(texturest)
					get_node("TextureRect").rect_pivot_offset = Vector2(texturest.get_size().x/2, texturest.get_size().y/2)
					match get_meta("metadata").direction:
						"down":
							get_node("TextureRect").rect_rotation = 0
						"up":
							get_node("TextureRect").rect_rotation = 180
						"left":
							get_node("TextureRect").rect_rotation = 90
						"right":
							get_node("TextureRect").rect_rotation = 270
					get_node("TextureRect").texture = texturest
					get_node("TextureRect").texture.set_flags(0)
				else:
					file.open(BaseFuncs.moddedload("textures/conveyor/trisplitter/texture_override.json"), File.READ)
					var textureoverrides = parse_json(file.get_as_text())
					texturestuff = BaseFuncs.loadoverrides(textureoverrides, get_node("TextureRect"), metadata, texturestuff, "icon")
					var texturest = BaseFuncs.load_texture(texturestuff.tex)
					texturest.set_size_override(Vector2(32, 32))
					texturest.set_flags(0)
					get_node("TextureRect").texture = texturest
					get_node("TextureRect").rect_size = Vector2(32,32)
		"splitter":
			var file = File.new()
			var texturestuff = "textures/conveyor/splitter/splitter.png"
			if !file.file_exists(BaseFuncs.moddedload("textures/conveyor/splitter/texture_override.json")):
				texturestuff = "textures/conveyor/splitter/splitter.png"
				var texturest = BaseFuncs.load_texture(texturestuff)
				texturest.set_size_override(Vector2(32, 32))
				texturest.set_flags(0)
				set_button_icon(texturest)
				get_node("TextureRect").rect_pivot_offset = Vector2(texturest.get_size().x/2, texturest.get_size().y/2)
				match metadata.direction:
					"down":
						get_node("TextureRect").rect_rotation = 0
					"up":
						get_node("TextureRect").rect_rotation = 180
					"left":
						get_node("TextureRect").rect_rotation = 90
					"right":
						get_node("TextureRect").rect_rotation = 270
				get_node("TextureRect").texture = texturest
				get_node("TextureRect").texture.set_flags(0)
			else:
				file.open(BaseFuncs.moddedload("textures/conveyor/splitter/texture_override.json"), File.READ)
				var textureoverrides = parse_json(file.get_as_text())
				texturestuff = BaseFuncs.loadoverrides(textureoverrides, get_node("TextureRect"), metadata, texturestuff, "icon")
				if texturestuff.has("unhandled_overrides"):
					if texturestuff.unhandled_overrides.has("icon"):
						for i in texturestuff.unhandled_overrides.icon:
							var override = texturestuff.unhandled_overrides.icon[i]
							if !override.has("enable") || override.enable == true:
								if i == "all" || i == metadata.horientation || ((i == "top" && metadata.horientation == ("down_up" || "up_left" || "up_right") ) || (i == "bottom" && metadata.horientation == ("down_up" || "down_left" || "down_right") ) || (i == "side_left" && metadata.horientation == ("left_right" || "up_left" || "down_left") ) || (i == "side_right" && metadata.horientation == ("left_right" || "down_right" || "up_right") )):
									for ii in override:
										match ii:
											"use_default_icon":
												if override.use_default_icon:
													if texturestuff.unhandled_overrides.has("normal") && texturestuff.unhandled_overrides.normal.has(metadata.horientation) && texturestuff.unhandled_overrides.normal[metadata.horientation].has("path"):
														texturestuff.tex = texturestuff.unhandled_overrides.normal[metadata.horientation].path
													else:
														texturestuff.tex = "textures/misc/missing.png"
											"rotation":
												if get_node("TextureRect") is Sprite:
													get_node("TextureRect").rotation_degrees = override.rotation
												else:
													get_node("TextureRect").rect_pivot_offset = Vector2(get_node("TextureRect").rect_size.x/2, get_node("TextureRect").rect_size.y/2)
													get_node("TextureRect").rect_rotation = override.rotation
											"path":
												if File.new().file_exists(BaseFuncs.moddedload(override.path)):
													texturestuff.tex = override.path
											"flipx":
												get_node("TextureRect").flip_h = bool(override.flipx)
											"flipy":
												get_node("TextureRect").flip_v = bool(override.flipy)
				get_node("TextureRect").texture = BaseFuncs.load_texture(texturestuff.tex)
				var texturest = BaseFuncs.load_texture(texturestuff.tex)
				texturest.set_size_override(Vector2(32, 32))
				texturest.set_flags(0)
				set_button_icon(texturest)
				get_node("TextureRect").texture = texturest
				get_node("TextureRect").rect_size = Vector2(32,32)

func gui_input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().current_scene.place_item(null, null)
			release_focus()
			return
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(KEY_P) and just_pressed:
			match currentmode:
				"horientation":
					currentmode = "direction"
				"direction":
					currentmode = "horientation"
			return
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(KEY_3) and just_pressed:
			metadata.type = "trisplitter"
			text = "3-Way Splitter"
			metadata.horientation = "down_left_right"
			metadata.direction = "down"
		elif Input.is_key_pressed(KEY_2) and just_pressed:
			metadata.type = "splitter"
			text = "2-Way Splitter"
			metadata.horientation = "down_up"
			metadata.direction = "down"
	if event is InputEventKey and event.pressed:
		match metadata.type:
			"splitter":
				match currentmode:
					"horientation":
						if Input.is_key_pressed(KEY_R) and just_pressed:
							match metadata.horientation:
								"left_right":
									metadata.horientation = "down_up"
									metadata.direction = "down"
								"down_up":
									metadata.horientation = "left_right"
									metadata.direction = "left"
					"direction":
						if Input.is_key_pressed(KEY_R) and just_pressed:
							match metadata.horientation:
								"down_left":
									metadata.horientation = "up_left";
									metadata.direction = "up"
								"up_left":
									metadata.horientation = "up_right";
									metadata.direction = "right"
								"up_right":
									metadata.horientation = "down_right";
									metadata.direction = "down"
								"down_right":
									metadata.horientation = "down_left";
									metadata.direction = "left"
			"trisplitter":
				if Input.is_key_pressed(KEY_R) and just_pressed:
					match metadata.horientation:
						"up_left_right":
							metadata.horientation = "right_up_down";
							metadata.direction = "right"
						"right_up_down":
							metadata.horientation = "down_left_right";
							metadata.direction = "down"
						"down_left_right":
							metadata.horientation = "left_up_down";
							metadata.direction = "left"
						"left_up_down":
							metadata.horientation = "up_left_right";
							metadata.direction = "up"
		textupdate()
		get_tree().current_scene.place_item("res://scene/Conveyor.tscn", metadata.duplicate())
