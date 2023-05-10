class_name Deck extends Resource


@export var pieces: Array[Piece]
@export var quantities: Array[int]


func generate(do_shuffle := true) -> Array[Piece]:
		
	assert(pieces.size() == quantities.size())
	var deck: Array[Piece]
	for i in pieces.size():
		for _n in quantities[i]:
			deck.append(pieces[i].duplicate())
	if do_shuffle:
		deck.shuffle()
	return deck
