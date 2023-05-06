class_name Piece extends Resource

@export var commands : Array[Globals.Commands]
@export var texture: Texture


func rotate(direction: int) -> void:
	for i in commands.size():
		commands[i] = _rotate_command(commands[i], direction)
		

func _rotate_command(command: Globals.Commands, direction: int) -> Globals.Commands:
	var command_index = int(command)
	var new_command = (command + direction) % Globals.Commands.size()
	return new_command as Globals.Commands
	

func _to_string() -> String:
	return " ".join(commands.map(func(x): return ["Left", "Up", "Right", "Down"][x]))
