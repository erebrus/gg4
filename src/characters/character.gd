extends CharacterBody2D
class_name Character

signal tick_complete()

const MAX_SPEED:float = 300


@export var hp:int = 3

var direction:Vector2i = Vector2i()
var target_direction:Vector2 = Vector2()
var world_target_pos:Vector2 = Vector2()

var speed:float = 0
var is_moving:bool = false

var previous_command
var previous_cell:Vector2i

var commands:Array[Command]
var command

var in_turn := false

@onready var grid:Arena = get_parent()

func _ready():
	previous_cell = grid.local_to_map(position)
	
func update_sprite():
	pass

func _physics_process(delta:float):

	control(delta)
	update_sprite()
	
	if not is_moving and direction != Vector2i():
		# if player is not moving and has no direction
		target_direction = Vector2(direction).normalized()
		# then set the target direction

		if grid.is_cell_vacant(position, direction):
			world_target_pos = grid.update_child_pos(position, direction)
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
		var done :=false
		if distance_to_target < move_distance:
			velocity = target_direction * distance_to_target
			is_moving = false
			command = null
			direction = Vector2i.ZERO
			done = true			
			#TODO check if we want to keep direction, or just use command
			

		var collision = move_and_collide(velocity)
		if collision:
			#Logger.error("Unexpected collision with:",collision.collider.name)
			var retreat = handle_combat_with(collision.get_collider())
			if done and retreat:
				done=false
		if done:
			in_turn = false
			previous_command = null
			tick_complete.emit()
	elif in_turn:
		in_turn = false
		tick_complete.emit() #nothing to do


func control(_delta:float)->void:
	if command!=null:		
		direction = translate_command(command)
	else:
		direction = Vector2i.ZERO		

func tick()->void:
	in_turn = true
	var new_direction:Vector2i = Vector2i()

	if not commands.is_empty():
		new_direction = translate_command(commands[0])
		previous_command = commands[0]
		commands.remove_at(0)	
		previous_cell = grid.local_to_map(position)		
		
	direction=new_direction	

func translate_command(_command : Command)->Vector2i:
	match _command.direction:
		Command.Direction.RIGHT:
			return Vector2i.RIGHT
		Command.Direction.LEFT:
			return Vector2i.LEFT
		Command.Direction.UP:
			return Vector2i.UP
		Command.Direction.DOWN:
			return Vector2i.DOWN
	return Vector2i.ZERO	
	
func pre_handle_collision(_position, _direction):
	pass

func post_handle_collision(_position, _direction):
	pass


func handle_combat_with(_other):
	pass

func do_retreat(redo_command:bool):
	world_target_pos = grid.map_to_local(previous_cell)
	is_moving = true
	if redo_command:
		commands.insert(0,previous_command)
	direction *= -1
	target_direction = Vector2(direction).normalized()
	

func take_damage(dmg):
	hp = clamp(hp - dmg, 0, hp)
	
	var hurt_color:Color = Color("ff0f18")
	#var tween := create_tween().set_trans(Tween.TRANS_CUBIC).
	modulate = hurt_color
	await get_tree().create_timer(.2).timeout
	modulate = Color.WHITE
		
	if hp == 0:
		do_death()

func do_death():
	queue_free()
