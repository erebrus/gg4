class_name PiecePile extends PanelContainer


@export var deck: Deck

var pieces: Array[Piece]
var num_pieces:
	get:
		return pieces.size()
	

@onready var number_label: Label = get_node("%NumPieces")

func _ready() -> void:
	if deck != null:
		pieces = deck.generate()
	update()
	

func is_empty() -> bool:
	return pieces.is_empty()
	

func draw_piece() -> Piece:
	assert(not pieces.is_empty())
	var piece = pieces.pop_front()
	update()
	return piece 
	

func add_piece(piece: Piece) -> void:
	pieces.push_front(piece)
	update()
	

func update() -> void:
	number_label.text = str(pieces.size())
	
