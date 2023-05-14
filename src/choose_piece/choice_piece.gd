extends VBoxContainer


signal selected


const SPRITE_SIZE = 128

@export var piece: Piece

@onready var piece_panel: PanelContainer = get_node("%Piece")
@onready var sprite: Control = get_node("%Sprite")
@onready var description_label: Label = get_node("%Description")
@onready var description_panel: Control = get_node("%DescriptionPanel")
@onready var select_sound:= $select
@onready var draw_sound:= $draw


func _ready() -> void:
	sprite.commands = piece.commands
	description_label.text = piece.description
	

func _on_piece_mouse_entered():
	description_panel.modulate.a = 1
	draw_sound.play()
	

func _on_piece_mouse_exited():
	description_panel.modulate.a = 0


func _on_piece_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		select_sound.play()
		selected.emit()
