class_name Command extends Resource

signal rotated


const SHIELD = 1
const ATTACK = 2

enum Direction {LEFT, UP, RIGHT, DOWN }
const DIRECTIONS = ["LEFT", "UP", "RIGHT", "DOWN"]

@export_flags("Shield", "Attack") var action: int
@export var direction: Direction
@export var speed: int = 1

var is_attack:
	get:
		return action & ATTACK
		
var is_shield:
	get:
		return action & SHIELD
	

func rotate_left() -> void:
	match direction:
		Direction.LEFT:
			direction = Direction.DOWN
		Direction.UP:
			direction = Direction.LEFT
		Direction.RIGHT:
			direction = Direction.UP
		Direction.DOWN:
			direction = Direction.RIGHT
	rotated.emit()
	

func rotate_right() -> void:
	match direction:
		Direction.LEFT:
			direction = Direction.UP
		Direction.UP:
			direction = Direction.RIGHT
		Direction.RIGHT:
			direction = Direction.DOWN
		Direction.DOWN:
			direction = Direction.LEFT
	rotated.emit()
	

func _to_string() -> String:
	return "%s %s%s%s" % [
		DIRECTIONS[direction], 
		speed, 
		" Attack" if is_attack else "", 
		" Shield" if is_shield else ""
	]

static func create(direction: Direction = Direction.RIGHT, speed: int = 1, flags: int = 0) -> Command:
	var command = Command.new()
	command.direction = direction
	command.speed = speed
	command.action = flags
	return command
