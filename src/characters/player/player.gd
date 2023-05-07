extends Character


@export var enable_debug_movement:=true

func _ready():
	Events.commands_queued.connect(add_commands)		
	
func control(_delta:float)->void:	
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
		super.control(_delta)
		
		
func add_commands(new_commands: Array[Globals.Commands]):
	commands.append_array(new_commands)
	Logger.debug("Added %s commands to player" % str(new_commands))

func handle_combat_with(other):
	do_retreat(false)
	take_damage(1)	

func do_death():
	Logger.info("Player died")
	get_tree().quit()


