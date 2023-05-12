class_name Hand extends MarginContainer


signal piece_placed(piece: Piece)
signal piece_discarded(piece: Piece)


const HandPiece = preload("res://src/gui/hand/hand_piece.tscn")


@export var max_pieces: int = 4
var num_pieces:
	get:
		return pieces.size()
	

var selected_piece: Piece
var pieces: Dictionary


@onready var piece_container = get_node("%Pieces")
@onready var draw_sound: AudioStreamPlayer = $sfx/draw
@onready var select_sound: AudioStreamPlayer = $sfx/select


func _ready():
	Events.player_damaged.connect(_on_player_damaged)
	Events.player_bumped.connect(_on_player_bumped)
	

func _input(_event):
	if Input.is_action_just_pressed("ui_left"):
		choose_previous_piece()
	if Input.is_action_just_pressed("ui_right"):
		choose_next_piece()
	
	if Input.is_action_just_pressed("ui_accept"):
		_on_accept_button_pressed()
	

func add(piece: Piece) -> void:
	var scene = HandPiece.instantiate()
	draw_sound.play()
	scene.piece = piece
	scene.selected.connect(_on_piece_selected.bind(piece))
	scene.accepted.connect(_on_piece_accepted.bind(piece))
	scene.unselected.connect(_on_piece_unselected.bind(piece))
	pieces[piece] = scene
	piece_container.add_child(scene)
	

func discard(idx:int = 0 )->void:
	if idx < 0 or idx >= piece_container.get_child_count():
		Logger.warn("Tried to discard invalid index %d" % idx)
		Events.out_of_pieces.emit()
		return

	var handpiece = piece_container.get_child(idx)
	piece_container.remove_child(handpiece)
	var discarded_piece = handpiece.piece
	pieces.erase(discarded_piece)
	handpiece.queue_free()
	
	piece_discarded.emit(discarded_piece)
	
	var piece_count:int = piece_container.get_child_count()
	if piece_count == 0:
		selected_piece = null
	else:
		select_piece_by_index(idx, false)


func is_empty() -> bool:
	return pieces.is_empty()
	

func choose_previous_piece()->void:
	var idx = get_index_of_piece(selected_piece)
	if idx == -1:
		Logger.warn("No piece selected, so we can't select previous piece")
		return
	select_piece_by_index(idx - 1, true)

func choose_next_piece()->void:
	var idx = get_index_of_piece(selected_piece)
	if idx == -1:
		Logger.warn("No piece selected, so we can't select next piece")
		return
	select_piece_by_index(idx + 1, true)
	

func place_piece() -> void:
	var idx = get_index_of_piece(selected_piece)
	pieces[selected_piece].place()
	piece_container.remove_child(pieces[selected_piece])
	pieces.erase(selected_piece)
	piece_placed.emit(selected_piece)
	
	var piece_count:int = piece_container.get_child_count()

	if piece_count == 0:
		selected_piece = null
	else:
		# todo: only select after commands are played out?
		select_piece_by_index(idx, false)
	

func get_index_of_piece(piece:Piece) -> int:
	return pieces.keys().find(piece)
	

func select_piece_by_index(idx:int, rollover:bool)->void:
	if pieces.size() == 0:
		Logger.warn("Cannot select piece of idx %d on empty hand."  % idx)
		return
	
	if idx >= pieces.size():
		idx = 0 if rollover else pieces.size() - 1
	if idx < 0:
		idx = pieces.size() - 1 if rollover else 0
	
	pieces[pieces.keys()[idx]].select()
	

func _on_piece_selected(piece: Piece) -> void:
	selected_piece = piece
	var idx = get_index_of_piece(piece)
	select_sound.pitch_scale = 1 + (-0.45 + 0.3 * idx)
	select_sound.play()
	for child in piece_container.get_children():
		if child.piece != piece:
			child.unselect()
	

func _on_piece_unselected(piece: Piece) -> void:
	if selected_piece == piece:
		selected_piece = null
	

func _on_accept_button_pressed():
	if selected_piece != null:
		place_piece()

func _on_piece_accepted(piece: Piece) -> void:
	if piece != selected_piece:
		return
	place_piece()
	

func _on_player_damaged(dmg:int)->void:
	for i in range(dmg): #(clamp(dmg, 0, pieces.size())):
		discard()
	

func _on_player_bumped()->void:
	if piece_container.get_child_count():
		discard(RngUtils.int_range(0, pieces.size()-1))
	else:
		Logger.warn("Tried to discard card, but hand is empty.")
	
	
