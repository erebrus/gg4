extends MarginContainer


const Piece = preload("res://src/pieces/HandPiece.tscn")


@export var deck: Deck
@export var num_pieces: int = 4


@onready var piece_container = get_node("%Pieces")


func _ready() -> void:
	for i in num_pieces:
		_add_piece()
	

func _add_piece() -> void:
	var scene = Piece.instantiate()
	scene.piece = deck.random()
	scene.connect("selected", _on_piece_selected.bind(scene))
	piece_container.add_child(scene)
	

func _on_piece_selected(piece: Node) -> void:
	for child in piece_container.get_children():
		if child != piece:
			child.unselect()
	

