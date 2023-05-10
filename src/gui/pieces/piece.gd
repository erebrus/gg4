class_name Piece extends Resource

@export var commands : Array[Command]
@export var description: String


func rotate_left() -> void:
	for i in commands.size():
		commands[i].rotate_left()
	

func rotate_right() -> void:
	for i in commands.size():
		commands[i].rotate_right()
	

func _to_string() -> String:
	return " ".join(commands.map(func(x): return x._to_string()))
