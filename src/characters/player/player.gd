extends Character


func _ready():
	super._ready()
	Events.commands_queued.connect(add_commands)
	tick_complete.connect(_on_tick_complete)	
	set_camera_limits()

func add_commands(new_commands: Array[Command]):
	for c in new_commands:
		commands.append(c.duplicate())
	Events.player_ticked.emit()
	Logger.debug("Added %s commands to player" % str(new_commands))

func handle_combat_with(_other):
	handle_combat(self, _other)

func take_damage():	
	Events.player_damaged.emit(4) #TODO replace by variable
	super.take_damage()
	

func _on_tick_complete():
	if commands.is_empty():
		Events.player_queue_empty.emit()
	else:
		Events.player_ticked.emit()			

func bump()->void:
	Events.player_bumped.emit()

func set_camera_limits()->void:
	var cam:Camera2D= $Camera2D
	cam.limit_left=-grid.tile_size.x
	cam.limit_top=-grid.tile_size.y
	cam.limit_right=grid.tile_size.x*grid.grid_size.x
	cam.limit_bottom=grid.tile_size.y*grid.grid_size.y
	
