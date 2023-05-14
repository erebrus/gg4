extends Container

const SPRITE_SIZE = 42

@export var commands: Array[Command]:
	set(value):
		commands = value
		for command in commands:
			if not command.rotated.is_connected(_position_children):
				command.rotated.connect(_position_children)
		add_children()

@export var num_commands:= 3

@export var move_sprite: Texture
@export var wait_sprite: Texture
@export var shield_sprite: Texture
@export var shield_charge_sprite: Texture
@export var attack_sprite: Texture
@export var sprint_sprite: Texture

var sprites: Dictionary


func _ready() -> void:
	custom_minimum_size = Vector2i(SPRITE_SIZE * num_commands, SPRITE_SIZE * num_commands)
	

func add_children() -> void:
	for child in get_children():
		child.queue_free()
	
	sprites.clear()
	
	for command in commands:
		var sprite = Sprite2D.new()
		sprites[command] = sprite
		
		if sprites.size() == 1:
			sprite.modulate = Color("#bed498")
		if command.is_attack:
			sprite.texture = attack_sprite
		elif command.is_shield and command.speed == 0:
			sprite.texture = shield_sprite
		elif command.is_shield and command.speed > 0:
			sprite.texture = shield_charge_sprite
		elif command.speed > 1:
			sprite.texture = sprint_sprite
		elif command.speed > 0:
			sprite.texture = move_sprite
		else:
			sprite.texture = wait_sprite
			
		add_child(sprite)
	_position_children()
	

func _position_children() -> void:
	var start_position: = Vector2.ZERO
	var previous_rotation: = 0.0
	var previous_speed: = 1
	var min := custom_minimum_size
	var max := Vector2.ZERO
	
	for i in commands.size():
		var command = commands[i]
		var sprite = sprites[command]
		
		if i > 0:
			start_position += Vector2(SPRITE_SIZE * previous_speed, 0).rotated(previous_rotation)
		
		if command.speed > 0:
			match command.direction:
				Command.Direction.RIGHT:
					sprite.rotation = 0
				Command.Direction.UP:
					sprite.rotation = -PI/2
				Command.Direction.LEFT:
					sprite.rotation = PI
				Command.Direction.DOWN:
					sprite.rotation = PI/2
			previous_rotation = sprite.rotation
			previous_speed = command.speed
		else:
			previous_speed = 1
		
		sprite.position = start_position + Vector2(SPRITE_SIZE * (previous_speed-1), 0).rotated(previous_rotation) / 2
		
		var half_size = Vector2(SPRITE_SIZE * previous_speed, SPRITE_SIZE).rotated(previous_rotation) / 2
		var left = sprite.position.x - abs(half_size.x)
		var right = sprite.position.x + abs(half_size.x)
		var top = sprite.position.y - abs(half_size.y)
		var bottom = sprite.position.y + abs(half_size.y)
		
		if left < min.x:
			min.x = left
		if right > max.x:
			max.x = right
		if top < min.y:
			min.y = top
		if bottom > max.y:
			max.y = bottom
	
	var commands_size = max - min
	var offset = custom_minimum_size / 2 - commands_size / 2 - min
	
	for child in sprites.values():
		child.position += offset
	
