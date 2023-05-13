extends Area2D


func _on_body_entered(body):
	if body.commands.is_empty():	
		body.tick_suspended=true
		Globals.level_manager.level_complete=true
		await get_tree().create_timer(1).timeout		
		Events.level_complete.emit()
