extends Button

func _pressed():
	get_parent().get_parent().remove_child(get_parent())
