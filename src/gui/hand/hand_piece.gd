extends MarginContainer


signal selected
signal unselected


const SPRITE_SIZE = 128

@export var piece: Piece

@onready var sprite: Sprite2D = get_node("%Sprite")

var is_selected:= false


func _ready() -> void:
	custom_minimum_size = Vector2(SPRITE_SIZE, SPRITE_SIZE)
	sprite.position = custom_minimum_size / 2
	sprite.texture = piece.texture
	modulate = Color.RED
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if is_selected:
			unselect()
		else:
			select()
	

func place() -> void:
	Events.commands_queued.emit(piece.commands)
	queue_free()
	

func select() -> void:
	if is_selected:
		return
	is_selected = true
	modulate = Color.YELLOW
	selected.emit()
	

func unselect() -> void:
	if not is_selected:
		return
	is_selected = false
	modulate = Color.RED
	unselected.emit()
	

func rotate_left() -> void:
	piece.rotate_left()
	sprite.rotate(-PI/2)
	

func rotate_right() -> void:
	piece.rotate_right()
	sprite.rotate(PI/2)
