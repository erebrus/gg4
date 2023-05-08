extends Character


@export var enable_debug_movement:=true

func _ready():
	Events.commands_queued.connect(add_commands)
	tick_complete.connect(_on_tick_complete)
	
func control(_delta:float)->void:	
	if enable_debug_movement:		
		if Input.is_action_just_pressed("ui_up"):
			Events.commands_queued.emit([Command.create(Command.Direction.RIGHT)]) 
		elif Input.is_action_just_pressed("ui_down"):
			Events.commands_queued.emit([Command.create(Command.Direction.DOWN)])
		elif Input.is_action_just_pressed("ui_left"):
			Events.commands_queued.emit([Command.create(Command.Direction.LEFT)]) 
		elif Input.is_action_just_pressed("ui_right"):
			Events.commands_queued.emit([Command.create(Command.Direction.RIGHT)])
		

func add_commands(new_commands: Array[Command]):
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
		
