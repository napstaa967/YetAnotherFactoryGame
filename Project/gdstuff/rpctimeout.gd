extends Timer

func timeout():
	DiscordRpc.start_rpc(str(get_tree().current_scene.get_meta("metadata").money), get_tree().current_scene.get_meta("metadata").source)
