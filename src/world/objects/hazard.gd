extends Area2D

func _on_body_entered(body):
	body.take_damage(1)
