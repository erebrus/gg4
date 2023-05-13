extends Area2D



func _on_body_entered(body):
	(body as Character).tick_complete.connect(on_level_complete)

func on_level_complete():
	Logger.info("Level complete.")
	Globals.level_manager.level_complete=true
	Events.level_complete.emit()
