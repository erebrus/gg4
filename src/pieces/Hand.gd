extends MarginContainer


const Piece = preload("res://src/pieces/HandPiece.tscn")


@export var deck: Deck
@export var num_pieces: int = 4


var selected_piece

@onready var piece_container = get_node("%Pieces")


func _ready() -> void:
	for i in num_pieces:
		_add_piece()
	

func _add_piece() -> void:
	var scene = Piece.instantiate()
	scene.piece = deck.random()
	scene.selected.connect(_on_piece_selected.bind(scene))
	scene.unselected.connect(_on_piece_unselected.bind(scene))
	piece_container.add_child(scene)
	

func _on_piece_selected(piece: Node) -> void:
	selected_piece = piece
	for child in piece_container.get_children():
		if child != piece:
			child.unselect()
	

func _on_piece_unselected(piece: Node) -> void:
	if selected_piece == piece:
		selected_piece = null
	

func _on_left_button_pressed():
	if selected_piece != null:
		selected_piece.rotate_left()
	

func _on_right_button_pressed():
	if selected_piece != null:
		selected_piece.rotate_right()
	

func _on_accept_button_pressed():
	if selected_piece != null:
		selected_piece.place()
		_add_piece()
