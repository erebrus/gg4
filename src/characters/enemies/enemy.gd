extends Character
class_name Enemy

@export var command_pattern:Array[Globals.Commands]=[]

func _ready():
	super._ready()
	_test_pattern()

func _test_pattern():
	var start:=Vector2i.ZERO
	for v in command_pattern:
		start +=translate_command(v)
	assert(start==Vector2i.ZERO)
		
func control(_delta:float)->void:	
	if command == null:
		if commands.is_empty():
			commands.append_array(command_pattern)
		
	
func pre_handle_collision(_position, _direction):
	var new_cell_pos = grid.local_to_map(_position)+_direction
	if grid.grid[new_cell_pos.x][new_cell_pos.y] == Arena.CellType.OBSTACLE:
		return

func post_handle_collision(_position, _direction):
	pass	

func handle_combat_with(other):
	other.take_damage(1)	
	if other.previous_command != null:
		other.do_retreat(false)
	else:
		do_retreat(true)
	
