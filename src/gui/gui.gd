extends PanelContainer


@export var auto_draw_piece_on_place: bool = true


@onready var deck: PiecePile = get_node("%DeckPile")
@onready var discard: PiecePile = get_node("%DiscardPile")
@onready var hand: Hand = get_node("%Hand")


func _ready() -> void:
	Events.player_queue_empty.connect(_on_player_queue_empty)
	hand.piece_discarded.connect(_on_piece_discarded)
	hand.piece_placed.connect(_on_piece_placed)
	Events.piece_given.connect(hand.add)
	Events.trigger_discard.connect(_on_discard_triggered)
	Events.trigger_discard_fetch.connect(_on_discard_fetch_triggered)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Globals.menu()
	

func set_deck_pieces(_pieces:Array[Piece]):
	deck.pieces = _pieces
	
	if auto_draw_piece_on_place:
		while hand.num_pieces < hand.max_pieces:
			if draw_from(deck):
				Events.piece_drawn.emit()
		
	await get_tree().create_timer(0.3).timeout
	hand.pieces.values().front().select()
	

func draw_from(pile: PiecePile, do_random:=false) -> bool:
	if hand.num_pieces >= hand.max_pieces:
		Logger.error("Hand full")
		return true
	if pile.is_empty():
		Logger.warn("Cannot draw from empty pile")
		return false
	
	hand.add(pile.draw_piece(do_random))
	return true


func _on_piece_placed(piece: Piece) -> void:
	discard.add_piece(piece)

func _on_piece_discarded(piece: Piece) -> void:
	discard.add_piece(piece)
	if deck.is_empty():
		Events.out_of_pieces.emit()	

	

func _on_deck_pile_gui_input(event: InputEvent) -> void:
	if auto_draw_piece_on_place:
		return
	
	if event is InputEventMouseButton and event.is_pressed():
		if draw_from(deck):
			Events.piece_drawn.emit()
	

func _on_player_queue_empty() -> void:
	if deck.is_empty() and hand.is_empty():
		Logger.info("Out of pieces")
		Globals.gameover()
		Events.out_of_pieces.emit()
	else:
		while hand.num_pieces < hand.max_pieces and not deck.is_empty():
			draw_from(deck)

func _on_discard_triggered() -> void:
	hand.discard(RngUtils.int_range(0,hand.num_pieces-1))

func _on_discard_fetch_triggered() -> void:
	draw_from(discard, true)
