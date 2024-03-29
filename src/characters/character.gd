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
var tick_suspended := false
var tick_requested := false

@onready var sprite:AnimatedSprite2D = $sprite
@onready var grid:Arena = get_parent()
@onready var xsm:State = $xsm

func _ready():
	previous_cell = grid.local_to_map(position)
	world_target_pos = position
	xsm.disabled = false
	xsm.change_state("idle")
	if not sprite.is_playing():
		sprite.play(sprite.animation)

func is_at_target_position()->bool:
	return position == world_target_pos

func tick()->void:
	in_turn = true

	if not commands.is_empty():
		#HACK I dont know where the null comes from and I'm tired of looking for it!
		while commands[0] == null:
			commands.remove_at(0)
		var direction:Vector2i = translate_command(commands[0])
		previous_command = commands[0]
		commands.remove_at(0)	
		previous_cell = grid.local_to_map(position)		
		world_target_pos = grid.get_new_local_position(position, direction)
		command_added.emit()			
		if is_at_target_position():
			xsm.change_state("wait")
	else:
		# lets wait for the next frame because we might be inside a subscriber call of the signal
		await get_tree().process_frame 
		complete_tick()
	
func complete_tick():
	if tick_suspended:
		tick_requested = true
		return
	in_turn = false		
	tick_complete.emit() 
	tick_requested = false
		
func clear_suspension():
	tick_suspended = false
	if tick_requested:
		complete_tick()

func suspend_tick():
	tick_suspended = true
	
func translate_command(_command : Command)->Vector2i:
	if _command.speed == 0:
		return Vector2i.ZERO
	match _command.direction:
		Command.Direction.RIGHT:
			return Vector2i.RIGHT*_command.speed
		Command.Direction.LEFT:
			return Vector2i.LEFT*_command.speed
		Command.Direction.UP:
			return Vector2i.UP*_command.speed
		Command.Direction.DOWN:
			return Vector2i.DOWN*_command.speed
	return Vector2i.ZERO	
	

func handle_combat_with(_other):
	pass
	
			
func take_damage():	
	xsm.change_state("hurt")

func bump()->void:
	pass

func retreat()->void:
	var prev_pos:Vector2 = grid.map_to_local(previous_cell)
	var direction:Vector2 = (prev_pos  - world_target_pos).normalized()
	world_target_pos = world_target_pos + grid.tile_size*Vector2(round(direction.x), round(direction.y))
	if redo_command:
		commands.insert(0,previous_command)	

func play_animation(animation:String)->void:
	if animation == "move" or animation == "attack":
		if world_target_pos.y < position.y:
			animation += "_up"			
	sprite.play(animation)
	sprite.flip_h = world_target_pos.x <= position.x
	
func play_hop_sfx()->void:
	$sfx/sfx_hop_grass.play()
		

