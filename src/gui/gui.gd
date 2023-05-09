extends PanelContainer


@export var auto_draw_piece_on_place: bool = true


@onready var deck: PiecePile = get_node("%DeckPile")
@onready var discard: PiecePile = get_node("%DiscardPile")
@onready var hand: Hand = get_node("%Hand")


func _ready() -> void:
	Events.player_queue_empty.connect(_on_player_queue_empty)
	hand.piece_discarded.connect(_on_piece_placed)
	hand.piece_placed.connect(_on_piece_placed)
	
	deck.pieces = Globals.deck.duplicate()
	
	if auto_draw_piece_on_place:
		while hand.num_pieces < hand.max_pieces:
			draw_from(deck)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Globals.menu()
		
	

func draw_from(pile: PiecePile) -> void:
	if hand.num_pieces >= hand.max_pieces:
		Logger.error("Hand full")
		return
	if pile.is_empty():
		Logger.warn("Cannot draw from empty pile")
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
	

func _on_player_queue_empty() -> void:
	if deck.is_empty() and hand.is_empty():
		Logger.info("Out of pieces")
		Globals.gameover()
	

