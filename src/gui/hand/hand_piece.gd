extends MarginContainer


signal selected
signal unselected
signal accepted


const SPRITE_SIZE = 128

@export var piece: Piece

@onready var sprite: Container = get_node("%Sprite")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var rotate_sound: AudioStreamPlayer = $sfx/rotate

var is_selected:= false


func _ready() -> void:
	sprite.commands = piece.commands
	

func _input(event: InputEvent) -> void:
	if is_selected:
		if Input.is_action_just_pressed("ui_up"):
			rotate_left()
		if Input.is_action_just_pressed("ui_down"):
			rotate_right()
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if is_selected:
			accepted.emit()
		else:
			select()
	

func place() -> void:
	Events.commands_queued.emit(piece.commands)
	piece.reset_rotation()
	queue_free()
	

func select() -> void:
	if is_selected:
		return
	animation_player.play("Select")
	is_selected = true
	selected.emit()
	

func unselect() -> void:
	if not is_selected:
		return
	animation_player.play("Unselect")
	is_selected = false
	unselected.emit()
	

func rotate_left() -> void:
	rotate_sound.play()
	piece.rotate_left()
	

func rotate_right() -> void:
	rotate_sound.play()
	piece.rotate_right()
	

func _on_mouse_entered():
	select()
