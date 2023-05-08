extends Area2D


func _on_body_entered(body):
	if not body.has_signal("command_added"):
		Logger.warn("Quicksand detected non character body %s" % body.name)
		return
	body.command_added.connect(on_command_added.bind(body))

func on_command_added(body):
	body.direction = Vector2i.ZERO
	body.command_added.disconnect(on_command_added.bind(body))


func _on_body_exited(body):
	if not body.has_signal("command_added"):
		Logger.warn("Quicksand detected exit of non character body %s" % body.name)
		return
	body.command_added.disconnect(on_command_added.bind(body))
