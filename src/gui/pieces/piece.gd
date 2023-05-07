class_name Piece extends Resource

@export var commands : Array[Globals.Commands]
@export var texture: Texture


func rotate_left() -> void:
	for i in commands.size():
		commands[i] = _rotate_command_left(commands[i])
	

func rotate_right() -> void:
	for i in commands.size():
		commands[i] = _rotate_command_right(commands[i])
	

func _rotate_command_left(command: Globals.Commands) -> Globals.Commands:
	match command:
		Globals.Commands.LEFT:
			return Globals.Commands.DOWN
		Globals.Commands.UP:
			return Globals.Commands.LEFT
		Globals.Commands.RIGHT:
			return Globals.Commands.UP
		Globals.Commands.DOWN:
			return Globals.Commands.RIGHT
		_:
			return command
	

func _rotate_command_right(command: Globals.Commands) -> Globals.Commands:
	match command:
		Globals.Commands.LEFT:
			return Globals.Commands.UP
		Globals.Commands.UP:
			return Globals.Commands.RIGHT
		Globals.Commands.RIGHT:
			return Globals.Commands.DOWN
		Globals.Commands.DOWN:
			return Globals.Commands.LEFT
		_:
			return command
	

func _to_string() -> String:
	return " ".join(commands.map(func(x): return ["Left", "Up", "Right", "Down"][x]))
