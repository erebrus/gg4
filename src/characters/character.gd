extends CharacterBody2D
class_name Character

const MAX_SPEED:float = 300

var direction:Vector2i = Vector2i()
var target_direction:Vector2 = Vector2()
var world_target_pos:Vector2 = Vector2()

var speed:int = 0
var is_moving:bool = false
@onready var grid:Arena = get_parent()
var commands:Array[Globals.Commands] = []
var command

func _ready():
	pass
	
func update_sprite():
	pass

func _physics_process(delta:float):

	control(delta)
	update_sprite()
	var tpos := position
	if not is_moving and direction != Vector2i():
		# if player is not moving and has no direction
		target_direction = Vector2(direction).normalized()
		# then set the target direction

		if grid.is_cell_vacant(position, direction):
			world_target_pos = grid.update_child_pos(position, direction, null)
			is_moving = true
		else:
			pre_handle_collision(position, direction)
			direction=Vector2i.ZERO
			is_moving=false
			command = null
			post_handle_collision(position, direction)

	elif is_moving:
		speed = MAX_SPEED
		velocity = speed * target_direction * delta

		var distance_to_target = position.distance_to(world_target_pos)
		var move_distance = velocity.length()

		# Set the last movement distance to the distance to the target
		# this will make the player stop exaclty on the target
		if distance_to_target < move_distance:
			velocity = target_direction * distance_to_target
			is_moving = false
			command = null
			direction = Vector2i.ZERO
			#TODO check if we want to keep direction, or just use command
			

		var collision = move_and_collide(velocity)
		if collision:
			Logger.error("Unexpected collision with:",collision.collider.name)


func control(delta:float)->void:
	if command!=null:		
		direction = translate_command(command)
	else:
		direction = Vector2i.ZERO		

func tick()->void:
	var new_direction:Vector2i = Vector2i()

	if not commands.is_empty():
		new_direction = translate_command(commands[0])
		commands.remove_at(0)			
		
	direction=new_direction	

func translate_command(command : Globals.Commands)->Vector2i:
	match command:
		Globals.Commands.RIGHT:
			return Vector2i.RIGHT
		Globals.Commands.LEFT:
			return Vector2i.LEFT
		Globals.Commands.UP:
			return Vector2i.UP
		Globals.Commands.DOWN:
			return Vector2i.DOWN
	return Vector2i.ZERO	
	
func pre_handle_collision(position, direction):
	pass

func post_handle_collision(position, direction):
	pass
