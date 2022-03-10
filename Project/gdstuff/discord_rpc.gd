extends Node

func _ready():
	get_tree().current_scene.get_node("RPCTimer").set_wait_time(0.5)
	get_tree().current_scene.get_node("RPCTimer").start()
		
func start_rpc(statestuff, source) -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	var stuff = "Money: " + statestuff
	activity.set_state(stuff)
	activity.set_details(source)
	var assets = activity.get_assets()
	assets.set_large_image("gameicon_v0-2")
	assets.set_large_text("Playing V -0.2")
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(result)
