extends Control


var can_exit = false

func _ready():
	await get_tree().create_timer(1).timeout
	can_exit = true
	

func _input(event: InputEvent):
	if not can_exit:
		return
	if event is InputEventKey or event is InputEventMouseButton:
		Globals.start()
	

func _on_timer_timeout():
	Globals.start()
