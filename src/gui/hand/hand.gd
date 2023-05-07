class_name Hand extends MarginContainer


signal piece_placed(piece: Piece)


const HandPiece = preload("res://src/gui/hand/hand_piece.tscn")


@export var num_pieces: int = 4

var selected_piece: Piece
var pieces: Dictionary


@onready var piece_container = get_node("%Pieces")


func add(piece: Piece) -> void:
	var scene = HandPiece.instantiate()
	scene.piece = piece
	scene.selected.connect(_on_piece_selected.bind(piece))
	scene.unselected.connect(_on_piece_unselected.bind(piece))
	pieces[piece] = scene
	piece_container.add_child(scene)
	

func _on_piece_selected(piece: Piece) -> void:
	selected_piece = piece
	for child in piece_container.get_children():
		if child.piece != piece:
			child.unselect()
	

func _on_piece_unselected(piece: Piece) -> void:
	if selected_piece == piece:
		selected_piece = null
	

func _on_left_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].rotate_left()
	

func _on_right_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].rotate_right()
	

func _on_accept_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].place()
		pieces.erase(selected_piece)
		piece_placed.emit(selected_piece)
		selected_piece = null
