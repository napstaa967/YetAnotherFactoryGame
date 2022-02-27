extends Node2D

class_name Conveyor

var metadata

func _init():
	metadata = {
		"speed": 1,
		"type": "conveyor",
		"direction": "down"
	}
	
func _process(delta):
	print(metadata)

func update_meta(meta):
	metadata = meta
