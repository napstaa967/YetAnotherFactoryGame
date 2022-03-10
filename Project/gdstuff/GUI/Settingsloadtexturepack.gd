extends Button

func _pressed():
	get_parent().get_node("Texture").popup()


func dir_selected(dir):
	get_parent().get_node("Label/TextEdit").text = dir
