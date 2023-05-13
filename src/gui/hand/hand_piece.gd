extends Node2D


signal selected
signal unselected
signal accepted


const SELECTED_OFFSET = -80
const SELECTED_POSITION = Vector2(1920/2,1080-600)
const SPRITE_SIZE = 128

@export var piece: Piece


var tween: Tween

@onready var sprite: Container = get_node("%Sprite")
@onready var left_button: Button = get_node("%TurnLeftButton")
@onready var right_button: Button = get_node("%TurnRightButton")

@onready var rotate_sound: AudioStreamPlayer = $sfx/rotate

var is_selected:= false


func _ready() -> void:
	sprite.commands = piece.commands
	

func _input(_event: InputEvent) -> void:
	if is_selected:
		if Input.is_action_just_pressed("ui_up"):
			rotate_left()
		if Input.is_action_just_pressed("ui_down"):
			rotate_right()
	

func place() -> void:
	Events.commands_queued.emit(piece.commands)
	

func select() -> void:
	if is_selected:
		return
	Logger.info("Piece selected: %s" % get_index())
	_select_tween()
	is_selected = true
	selected.emit()
	

func unselect() -> void:
	if not is_selected:
		return
	_unselect_tween()
	is_selected = false
	unselected.emit()
	

func rotate_left() -> void:
	if Globals.player_in_turn:
		return
	
	rotate_sound.play()
	piece.rotate_left()
	

func rotate_right() -> void:
	if Globals.player_in_turn:
		return
	
	rotate_sound.play()
	piece.rotate_right()
	

func _select_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, SELECTED_OFFSET), 0.3)
	tween.tween_callback(left_button.show)
	tween.tween_callback(right_button.show)
	

func _unselect_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_callback(left_button.hide)
	tween.tween_callback(right_button.hide)
	tween.tween_property(self, "position", Vector2(position.x, 0), 0.3)
	

func _on_hand_piece_gui_input(event):
	if Globals.player_in_turn:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if is_selected:
			accepted.emit()
		else:
			select()
	

func _on_hand_piece_mouse_entered():
	if Globals.player_in_turn:
		return
	
	select()
