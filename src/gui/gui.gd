extends PanelContainer


const DISCARD_VERTICAL_OFFSET = -500
const PATH_IN_OUT = 200
const DISCARD_TIME = 1

@export var auto_draw_piece_on_place: bool = true

var exit_reached := false

@onready var deck: PiecePile = get_node("%DeckPile")
@onready var discard_pile: PiecePile = get_node("%DiscardPile")
@onready var hand: Hand = get_node("%Hand")


func _ready() -> void:
	hand.piece_discarded.connect(_on_piece_discarded)
	hand.piece_placed.connect(_on_piece_placed)
	
	Events.piece_given.connect(hand.add)
	Events.trigger_discard.connect(_on_discard_triggered)
	Events.trigger_discard_fetch.connect(_on_discard_fetch_triggered)
	Events.level_complete.connect(func(): exit_reached = true)
	Events.player_queue_empty.connect(_on_player_queue_empty)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Globals.menu()
	

func set_deck_pieces(_pieces:Array[Piece]):
	deck.pieces = _pieces
	
	if auto_draw_piece_on_place:
		_fill_hand()
		
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
	
	await get_tree().create_timer(0.3).timeout
	
	return true


func _discard_piece(piece: Piece, scene: Node2D) -> void:
	# create path
	var start_position = scene.position + hand.position
	var end_position = discard_pile.get_rect().get_center()
	var middle = (end_position.x - start_position.x) * 0.7 + start_position.x
	var middle_position = Vector2(middle, end_position.y + DISCARD_VERTICAL_OFFSET)
	
	var curve = Curve2D.new()
	curve.add_point(start_position)
	curve.add_point(middle_position)
	curve.add_point(end_position)
	curve.set_point_out(0, Vector2(0, -PATH_IN_OUT))
	curve.set_point_in(1, Vector2(-PATH_IN_OUT,0))
	curve.set_point_out(1, Vector2(PATH_IN_OUT,0))
	curve.set_point_in(2, Vector2(0, -PATH_IN_OUT))
	
	var path = Path2D.new()
	path.curve = curve
	add_child(path)
	move_child(path, 0)
	
	var follow = PathFollow2D.new()
	follow.progress_ratio = 0
	path.add_child(follow)
	
	# Setup start
	follow.add_child(scene)
	scene.rotation = PI/2
	scene.unselect()
	
	# Tween discard
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(follow, "progress_ratio", 1, DISCARD_TIME)
	tween.tween_property(scene, "scale", Vector2(0.2,0.2), DISCARD_TIME)
	await tween.finished
	
	path.queue_free()
	discard_pile.add_piece(piece)
	

func _fill_hand() -> void:
	while hand.num_pieces < hand.max_pieces and not deck.is_empty():
		await draw_from(deck)
	
	if deck.is_empty() and hand.is_empty():
		Logger.info("Out of pieces")
		Events.out_of_pieces.emit()
	

func _on_piece_discarded(piece: Piece, scene: Node2D) -> void:
	_discard_piece(piece, scene)
	

func _on_piece_placed(piece: Piece, scene: Node2D) -> void:
	_discard_piece(piece, scene)
	

func _on_deck_pile_gui_input(event: InputEvent) -> void:
	if auto_draw_piece_on_place:
		return
	# todo: we can probably delete this and avoid extra complexity/errors
	if event is InputEventMouseButton and event.is_pressed():
		if await draw_from(deck):
			Events.piece_drawn.emit()
	

func _on_player_queue_empty() -> void:
	if not exit_reached:
		_fill_hand()
	

func _on_discard_triggered() -> void:
	hand.discard(RngUtils.int_range(0,hand.num_pieces-1))
	

func _on_discard_fetch_triggered() -> void:
	await draw_from(discard_pile, true)
