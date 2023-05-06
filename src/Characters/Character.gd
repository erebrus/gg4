extends CharacterBody2D
class_name Character

const MAX_SPEED:float = 300

var direction:Vector2i = Vector2i()
var target_direction:Vector2 = Vector2()
var world_target_pos:Vector2 = Vector2()

var speed:int = 0
var is_moving:bool = false
@onready var grid:Arena = get_parent()
var commands:Array = []
var command:Vector2i

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
			direction=Vector2i.ZERO
			is_moving=false
			command = Vector2i.ZERO

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
			command = Vector2i.ZERO
			direction = command #TODO check if we want to keep direction, or just use command
			

		var collision = move_and_collide(velocity)
		if collision:
			Logger.error("Unexpected collision with:",collision.collider.name)


func control(delta:float)->void:
	if command!=null and command!=Vector2i.ZERO:		
		direction = command	
	else:
		direction = Vector2i.ZERO		

func tick()->void:
	var new_direction:Vector2i = Vector2i()

	if not commands.is_empty():
		new_direction = commands[0]
		commands.remove_at(0)			
		
	direction=new_direction	
