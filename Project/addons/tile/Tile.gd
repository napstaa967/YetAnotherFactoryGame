tool
extends Area2D

class_name Tile

enum {
	TILE_SOLID,
	TILE_TRANSPARENT,
	TILE_OVERLAPPING,
	TILE_MOVABLE
}

var original_position := Vector2(0,0)
var type := TILE_SOLID
var placing := false
var sell_cost := 0
var buy_cost := 0
var namespace := ""
var identifier := ""
var persistent_values := {}
var electrical_cost := 0
var electrical_timer := 0
var tile_size := Vector2(64,64)
var _name := "unknown"
var description := """unknown"""

func _get_property_list():
	return [
		{
			name = "Tile",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY
		},
		{
			name = "type",
			type = TYPE_INT
		},
		{
			name = "placing",
			type = TYPE_BOOL
		},
		{
			name = "sell_cost",
			type = TYPE_INT
		},
		{
			name = "buy_cost",
			type = TYPE_INT
		},
		{
			name = "namespace",
			type = TYPE_STRING
		},
		{
			name = "identifier",
			type = TYPE_STRING
		},
		{
			name = "persistent_values",
			type = TYPE_DICTIONARY
		},
		{
			name = "electrical_cost",
			type = TYPE_INT
		},
		{
			name = "electrical_timer",
			type = TYPE_INT
		},
		{
			name = "tile_size",
			type = TYPE_VECTOR2
		}
	]

func _enter_tree():
	editor_description = "Basic tile base for any item/tile, requires collision shape"

func configure(_data: Dictionary):
	var data = _data
	if data.has("type"):
		type = data.type
	if data.has("placing"):
		placing = data.placing
	if data.has("sell_cost"):
		sell_cost = data.sell_cost
	if data.has("buy_cost"):
		buy_cost = data.buy_cost
	if data.has("namespace"):
		namespace = data.namespace
	if data.has("identifier"):
		identifier = data.identifier
	if data.has("persistent_values"):
		persistent_values = data.persistent_values
	if data.has("electrical_cost"):
		electrical_cost = data.electrical_cost
	if data.has("electrical_timer"):
		electrical_timer = data.electrical_timer
	if data.has("size"):
		tile_size = data.tile_size

func setup_electrical():
	var ElectricalTimer = Timer.new()
	ElectricalTimer.name = "ElectricalTimer"
	ElectricalTimer.wait_time = electrical_timer
	add_child(ElectricalTimer)
	ElectricalTimer.connect("timeout", self, "_electrical_add_cost")
	ElectricalTimer.start()

func _electrical_add_cost():
	get_tree().current_scene.due += electrical_cost

func _tile_setup(node):
	var shape = CollisionShape2D.new()
	var shape2 = RectangleShape2D.new()
	shape2.extents = tile_size/2
	shape.shape = shape2
	var sprite = Sprite.new()
	shape.name = "CollisionShape2D"
	shape.position += tile_size/2
	sprite.name = "Sprite"
	sprite.position += Vector2(32,32)
	node.add_child(sprite)
	node.add_child(shape)
	shape.owner = node
	sprite.owner = node
	var visibility_notifier = VisibilityNotifier2D.new()
	visibility_notifier.rect = Rect2(0,0,tile_size.x, tile_size.y)
	node.add_child(visibility_notifier)
	visibility_notifier.owner = node
	visibility_notifier.connect("screen_entered", self, "show")
	visibility_notifier.connect("screen_exited", self, "hide")
	visible = false

func set_texture_state(state: String, _size: Vector2, flags: int = 0, interp: int = 0, _identifier: String = identifier, _namespace: String = namespace):
	$Sprite.texture = BaseFuncs.set_state(_namespace, _identifier, state, _size, flags, interp)
