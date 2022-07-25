tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Tile", "Area2D", preload("Tile.gd"), preload("Tile.svg"))
	
func _exit_tree():
	remove_custom_type("Tile")

