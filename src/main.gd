extends Node

@onready var gui = $Gui

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_complete.connect(_on_level_complete)
	
	var map = Globals.level_manager.get_current_level().instantiate()
	add_child(map)
	move_child(map, 0)

func _on_level_complete() -> void:
	if Globals.level_manager.is_last_level():
		Globals.win(gui.deck.num_pieces)
	else:
		Globals.choose_piece()
