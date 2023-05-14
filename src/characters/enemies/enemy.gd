extends Character
class_name Enemy

@export var command_pattern: Array[Command] = []
@onready var sfx_death:=$sfx/sfx_death
@onready var bubble:= $Bubble
@onready var command_preview:= $Bubble/Command

func _ready():
	super._ready()
	redo_command = true
	_test_pattern()
	commands.append_array(command_pattern)
	Events.turn_complete.connect(_on_turn_complete)
	

func _test_pattern():
	var start:=Vector2i.ZERO
	for v in command_pattern:
		start +=translate_command(v)
	assert(start==Vector2i.ZERO)
	

func _show_command():
	var next_command: Array[Command]
	next_command.append(commands.front())
	command_preview.commands = next_command
	

func handle_combat_with(other):
	if not other.previous_command.is_shield:			
		other.take_damage()
	retreat()
	

func take_damage():	
	if not dead:
		Logger.info("Enemy killed: %s" % name)
		dead = true
		xsm.change_state("death")
	

func _on_turn_complete():
	if commands.is_empty():
		commands.append_array(command_pattern)
	_show_command()
	


func _on_mouse_entered():
	bubble.show()


func _on_mouse_exited():
	bubble.hide()

func play_hop_sfx()->void:
	super.play_hop_sfx()
