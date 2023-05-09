extends Area2D


func _on_body_entered(body):
	if not body.has_signal("command_added"):
		Logger.warn("Quicksand detected non character body %s" % body.name)
		return
	body.command_added.connect(on_command_added.bind(body))

func on_command_added(body):
	#TODO replace this by a stay command
	body.world_target_pos = body.grid.map_to_local(body.grid.local_to_map(body.position))
#	body.xsm.change_state("wait")
	body.command_added.disconnect(on_command_added.bind(body))
#	pass
	

func _on_body_exited(body):
	if not body.has_signal("command_added"):
		Logger.warn("Quicksand detected exit of non character body %s" % body.name)
		return

	if body.command_added.is_connected(on_command_added.bind(body)):
		body.command_added.disconnect(on_command_added.bind(body))
