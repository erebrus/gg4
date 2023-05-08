extends Character
class_name Enemy

@export var command_pattern: Array[Command] = []

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
		

func handle_combat_with(other):
	other.take_damage(1)	
	if other.previous_command != null:
		other.do_retreat(false)
	else:
		do_retreat(true)
	
