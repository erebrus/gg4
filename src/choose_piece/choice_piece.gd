extends VBoxContainer


signal selected


const SPRITE_SIZE = 128

@export var piece: Piece

@onready var piece_panel: PanelContainer = get_node("%Piece")
@onready var sprite: Control = get_node("%Sprite")
@onready var description_label: Label = get_node("%Description")


func _ready() -> void:
	sprite.commands = piece.commands
	description_label.text = piece.description
	

func _on_piece_mouse_entered():
	description_label.modulate.a = 1


func _on_piece_mouse_exited():
	description_label.modulate.a = 0


func _on_piece_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		selected.emit()
