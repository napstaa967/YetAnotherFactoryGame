extends Area2D

signal conveyor_move

export var speed = 1 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var type = "conveyor"

func _ready():
	screen_size = get_viewport_rect().size


func _on_Conveyor_body_entered(_body):
	emit_signal("conveyor_move")
	
func _process(_delta):
	var areas = get_overlapping_areas()
	for area in areas:
		if area.type == "item":
			area.position.x -= 1
