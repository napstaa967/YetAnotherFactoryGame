tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("AutoGridContainer", "GridContainer", preload("AutoGridContainer.gd"), preload("GridContainer.svg"))
