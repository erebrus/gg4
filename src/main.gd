extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.reset_level() #TODO remove once we have main menu
	var map = LevelManager.get_current_level().instantiate()
	add_child(map)
	move_child(map, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
