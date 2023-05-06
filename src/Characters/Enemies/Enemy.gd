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
		
func control(delta:float)->void:	
	if command == null:
		if commands.is_empty():
			commands.append_array(command_pattern)
		
	
	
