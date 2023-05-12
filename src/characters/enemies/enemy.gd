extends Character
class_name Enemy

@export var command_pattern: Array[Command] = []

func _ready():
	super._ready()
	redo_command = true
	_test_pattern()

func _test_pattern():
	var start:=Vector2i.ZERO
	for v in command_pattern:
		start +=translate_command(v)
	assert(start==Vector2i.ZERO)
		
func control(_delta:float)->void:	
	if commands.is_empty():
		commands.append_array(command_pattern)
		

func handle_combat_with(other):
	handle_combat(other, self)
	
func take_damage():	
#	super.take_damage()
	dead = true
	xsm.change_state("death")
	
	
