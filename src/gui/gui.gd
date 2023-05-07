extends PanelContainer


@export var auto_draw_piece_on_place: bool = true


@onready var deck: PiecePile = get_node("%DeckPile")
@onready var discard: PiecePile = get_node("%DiscardPile")
@onready var hand: Hand = get_node("%Hand")


func _ready() -> void:
	hand.piece_placed.connect(_on_piece_placed)
	
	if auto_draw_piece_on_place:
		while hand.num_pieces < hand.max_pieces:
			draw_from(deck)
	

func draw_from(pile: PiecePile) -> void:
	if hand.num_pieces >= hand.max_pieces:
		Logger.error("Hand full")
		return
	hand.add(pile.draw_piece())
	

func _on_piece_placed(piece: Piece) -> void:
	discard.add_piece(piece)
	
	if auto_draw_piece_on_place:
		draw_from(deck)
	

func _on_deck_pile_gui_input(event: InputEvent) -> void:
	if auto_draw_piece_on_place:
		return
	
	if event is InputEventMouseButton and event.is_pressed():
		draw_from(deck)
