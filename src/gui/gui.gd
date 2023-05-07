extends PanelContainer


@onready var deck: PiecePile = get_node("%DeckPile")
@onready var discard: PiecePile = get_node("%DiscardPile")
@onready var hand: Hand = get_node("%Hand")


func _ready() -> void:
	hand.piece_placed.connect(_on_piece_placed)
	
	while hand.pieces.size() < hand.num_pieces:
		hand.add(deck.draw_piece())
	

func _on_piece_placed(piece: Piece) -> void:
	discard.add_piece(piece)
	hand.add(deck.draw_piece())

