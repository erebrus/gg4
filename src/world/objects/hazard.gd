extends Area2D

var turns_from_trigger:=10
func _ready():
	Events.turn_complete.connect(_on_turn_complete)
	
func _on_turn_complete():
	turns_from_trigger+=1
		
func _on_body_entered(body):
	
	if turns_from_trigger>1:
		body.take_damage(1)
		turns_from_trigger = 0
