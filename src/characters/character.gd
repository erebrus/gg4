extends CharacterBody2D
class_name Character

signal command_added()
signal tick_complete()

const MAX_SPEED:float = 300

var redo_command:=false

var world_target_pos:Vector2 = Vector2()
var speed:float = 0


var previous_command:Command = null
var previous_cell:Vector2i

var commands:Array[Command]

var in_turn := false

var dead := false

@onready var grid:Arena = get_parent()
@onready var xsm:State = $xsm
func _ready():
	previous_cell = grid.local_to_map(position)
	world_target_pos = position
	xsm.disabled = false
	xsm.change_state("idle")


func update_sprite():
	pass

func is_at_target_position()->bool:
	return position == world_target_pos


func _physics_process(delta:float):	
	if dead:
		return
	control(delta)
	update_sprite()


func control(_delta:float)->void:
	pass	


func tick()->void:
	in_turn = true

	if not commands.is_empty():
		var direction:Vector2i = translate_command(commands[0])
		previous_command = commands[0]
		commands.remove_at(0)	
		previous_cell = grid.local_to_map(position)		
		command_added.emit()
		world_target_pos = grid.get_new_local_position(position, direction)
		if is_at_target_position():
			xsm.change_state("idle")
#		is_retreating=false
	else:
		# lets wait for the next frame because we might be inside a subscriber call of the signal
		await get_tree().process_frame 
		previous_command = null
		in_turn = false		
		tick_complete.emit() 
	

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
	

func handle_combat_with(_other):
	pass
	
func handle_combat(player, enemy)->void:
	#Player wins
	if player.previous_command.is_attack:
		enemy.take_damage()
		enemy.retreat()
	else:
		var cell:Vector2i = grid.local_to_map(player.position)
		var player_moved:bool = player.position != player.grid.map_to_local(player.previous_cell)
		var enemy_moved:bool = enemy.position != enemy.grid.map_to_local(enemy.previous_cell)

		#PLAYER loses but has shield
		if player.previous_command.is_shield:
			if player_moved:
				if enemy_moved:
					player.retreat()
					enemy.retreat()
				else:
#					enemy.push(player)			TODO push
					player.retreat()
			else:
				enemy.retreat()
			
		else:					
			player.take_damage()	#TODO gets this from global var
			if player_moved and enemy_moved:			
				player.retreat()
				enemy.retreat()
			elif player_moved:			
				player.retreat()
			else:
				enemy.retreat()
			
func take_damage():	
	xsm.change_state("hurt")

func bump()->void:
	pass

func retreat()->void:
	world_target_pos = grid.map_to_local(previous_cell)
	if redo_command:
		commands.insert(0,previous_command)	
