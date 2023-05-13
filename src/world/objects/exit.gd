extends Area2D

func _ready():
	Events.turn_complete.connect(_on_turn_complete)

func _on_turn_complete():
	monitoring = true	
	await get_tree().create_timer(.1).timeout
	monitoring = false
	
func _on_body_entered(body):
	monitoring = false
	if body.commands.is_empty():	
		body.tick_suspended=true
		Globals.level_manager.level_complete=true
		Events.level_complete.emit()
