extends Character


@export var enable_debug_movement:=true

func _ready():
	Events.commands_queued.connect(add_commands)
	tick_complete.connect(_on_tick_complete)
			
		
func add_commands(new_commands: Array[Globals.Commands]):
	commands.append_array(new_commands)
	Events.player_ticked.emit()
	Logger.debug("Added %s commands to player" % str(new_commands))

func handle_combat_with(_other):
	do_retreat(false)
	take_damage(1)	

func do_death():
	Logger.info("Player died")
	Globals.gameover()

func _on_tick_complete():
	if commands.is_empty():
		Events.player_queue_empty.emit()
	else:
		Events.player_ticked.emit()
		
