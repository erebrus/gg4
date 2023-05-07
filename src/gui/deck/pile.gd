class_name PiecePile extends PanelContainer


@export var deck: Deck

var pieces: Array[Piece]

@onready var number_label: Label = get_node("%NumPieces")

func _ready() -> void:
	if deck != null:
		pieces = deck.generate()
	update()
	

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
	# todo: handle deck empty
