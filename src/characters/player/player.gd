extends Character

var out_of_pieces:=false
@onready var sfx_death = $sfx/sfx_death
@onready var sfx_wobble = $sfx/sfx_wobble
func _ready():
	super._ready()
	Events.commands_queued.connect(add_commands)
	Events.out_of_pieces.connect(set_out_of_pieces.bind(true))
#	Events.piece_drawn.connect(set_out_of_pieces.bind(false))
	Events.turn_complete.connect(_on_turn_complete)	
	set_camera_limits()

func add_commands(new_commands: Array[Command]):
	for c in new_commands:
		commands.append(c.duplicate())
	Globals.player_in_turn = true
	Logger.debug("Turn player start")
	Events.trigger_tick.emit()
	Logger.debug("Added %s commands to player" % str(new_commands))

func handle_combat_with(_other):
	if previous_command.is_attack:
		_other.take_damage()
		_other.retreat()
	elif previous_command.is_shield:
		_other.retreat()
	else:
		take_damage()
		retreat()
		
		

func _physics_process(_delta):
	if out_of_pieces and not dead and not Globals.level_manager.level_complete:
		dead = true
		xsm.change_state("death")	
		
func take_damage(dmg:int = 4):	
	Events.player_damaged.emit(dmg) #TODO replace by variable
	if out_of_pieces and not Globals.level_manager.level_complete:
		dead = true
		xsm.change_state("death")	
		
	else:
		super.take_damage()

func set_out_of_pieces(val:bool):
	out_of_pieces=val
	

func _on_turn_complete():
	if commands.is_empty():
		Events.player_queue_empty.emit()
		Globals.player_in_turn = false
		Logger.debug("Turn player over")
	else:
		Events.trigger_tick.emit()
	

func bump()->void:
	Events.player_bumped.emit()

func set_camera_limits()->void:
	var cam:Camera2D= $Camera2D
	cam.limit_left=-int(grid.tile_size.x)
	cam.limit_top=-int(grid.tile_size.y)
	cam.limit_right=int(grid.tile_size.x*(grid.grid_size.x+1))
	cam.limit_bottom=int(grid.tile_size.y*(grid.grid_size.y+1))
	
func play_hop_sfx()->void:
	super.play_hop_sfx()

