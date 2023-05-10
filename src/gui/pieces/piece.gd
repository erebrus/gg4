class_name Piece extends Resource

@export var commands : Array[Command]
@export var texture: Texture
@export var description: String
var rotate_count := 0

func rotate_left() -> void:
	for i in commands.size():
		commands[i].rotate_left()
		rotate_count -= 1
	

func rotate_right() -> void:
	for i in commands.size():
		commands[i].rotate_right()
		rotate_count += 1
	
func reset_rotation() -> void:
	while rotate_count != 0:
		if rotate_count>0:
			rotate_left()
		else:
			rotate_right()


func _to_string() -> String:
	return " ".join(commands.map(func(x): return x._to_string()))
