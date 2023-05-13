class_name PiecePile extends PanelContainer


var pieces: Array[Piece]:
	set(value):
		pieces = value
		if number_label != null:
			update()
	
var num_pieces:
	get:
		return pieces.size()
	

@onready var number_label: Label = get_node("%NumPieces")

func _ready() -> void:
	update()
	

func is_empty() -> bool:
	return pieces.is_empty()
	

func draw_piece(do_random:=false) -> Piece:
	assert(not pieces.is_empty())
	var piece
	if do_random:
		var idx = RngUtils.int_range(0, pieces.size()-1)
		piece = pieces[idx]
		pieces.remove_at(idx)
	else:
		piece = pieces.pop_front()
	update()
	return piece 
	

func add_piece(piece: Piece) -> void:
	pieces.push_front(piece)
	update()
	

func update() -> void:
	number_label.text = str(pieces.size())
	
