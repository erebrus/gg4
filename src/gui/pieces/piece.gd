class_name Piece extends Resource

@export var commands : Array[Globals.Direction]
@export var texture: Texture


func rotate_left() -> void:
	for i in commands.size():
		commands[i] = _rotate_command_left(commands[i])
	

func rotate_right() -> void:
	for i in commands.size():
		commands[i] = _rotate_command_right(commands[i])
	

func _rotate_command_left(command: Globals.Direction) -> Globals.Direction:
	match command:
		Globals.Direction.LEFT:
			return Globals.Direction.DOWN
		Globals.Direction.UP:
			return Globals.Direction.LEFT
		Globals.Direction.RIGHT:
			return Globals.Direction.UP
		Globals.Direction.DOWN:
			return Globals.Direction.RIGHT
		_:
			return command
	

func _rotate_command_right(command: Globals.Direction) -> Globals.Direction:
	match command:
		Globals.Direction.LEFT:
			return Globals.Direction.UP
		Globals.Direction.UP:
			return Globals.Direction.RIGHT
		Globals.Direction.RIGHT:
			return Globals.Direction.DOWN
		Globals.Direction.DOWN:
			return Globals.Direction.LEFT
		_:
			return command
	

func _to_string() -> String:
	return " ".join(commands.map(func(x): return ["Left", "Up", "Right", "Down"][x]))
