extends Character


@export var enable_debug_movement:=true

func control(delta:float)->void:	
	if enable_debug_movement:		
		if Input.is_action_just_pressed("ui_up"):
			Events.commands_queued.emit([Globals.Commands.UP]) 
		elif Input.is_action_just_pressed("ui_down"):
			Events.commands_queued.emit([Globals.Commands.DOWN])
		elif Input.is_action_just_pressed("ui_left"):
			Events.commands_queued.emit([Globals.Commands.LEFT]) 
		elif Input.is_action_just_pressed("ui_right"):
			Events.commands_queued.emit([Globals.Commands.RIGHT])
	else:
		super.control(delta)
		
		
func add_commands(new_commands): #TODO :Array[Globals.Commands]
	commands.append_array(new_commands)
	Logger.debug("Added %s commands to player" % str(new_commands))
