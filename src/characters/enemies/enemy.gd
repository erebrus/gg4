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
	if commands.is_empty():
		commands.append_array(command_pattern)
		

func handle_combat_with(other):
	handle_combat(other, self)
	
func take_damage():	
	super.take_damage()
	collision_layer=0
	#HACK we need to replace all this by an XSM to fix it
	await get_tree().create_timer(.3).timeout
	do_death()
	
	
