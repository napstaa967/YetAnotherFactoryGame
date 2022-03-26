extends Node2D
var camera
var camlock = false

func new_game(path):
	return SimpleSave.new_game(get_tree(), path)

func load_game(path):
	SimpleSave.load_scene(get_tree(), path)

