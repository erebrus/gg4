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

func _ready():
	Events.player_damaged.connect(on_player_damaged)
	Events.player_bumped.connect(on_player_bumped)

func add(piece: Piece) -> void:
	var scene = HandPiece.instantiate()
	$sfx/draw.play()
	scene.piece = piece
	scene.selected.connect(_on_piece_selected.bind(piece))
	scene.unselected.connect(_on_piece_unselected.bind(piece))
	pieces[piece] = scene
	piece_container.add_child(scene)
	#if it's the first piece of the hand, select it
	if not selected_piece:
		scene.select()	
		_on_piece_selected(piece)
	

func is_empty() -> bool:
	return pieces.is_empty()
	

func _on_piece_selected(piece: Piece, do_sound:=false) -> void:
	selected_piece = piece
	if do_sound:
		$sfx/select.play()
	for child in piece_container.get_children():
		if child.piece != piece:
			child.unselect()
	

func _on_piece_unselected(piece: Piece) -> void:
	if selected_piece == piece:
		selected_piece = null
	

func _on_left_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].rotate_left()
		$sfx/rotate.play()
	

func _on_right_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].rotate_right()
		$sfx/rotate.play()

func _on_accept_button_pressed():
	if selected_piece != null:
		var idx = get_index_of_piece(selected_piece)
		pieces[selected_piece].place()
		piece_container.remove_child(pieces[selected_piece])
		pieces.erase(selected_piece)
		piece_placed.emit(selected_piece)
		
		var piece_count:int = piece_container.get_child_count()

		if piece_count == 0:
			selected_piece = null
		else:
			select_piece_by_index(idx, false, false)

			
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


func get_index_of_piece(piece:Piece)->int:
	for idx in range(piece_container.get_child_count()):
		if piece_container.get_child(idx).piece == piece:
			return idx
	return -1


func select_piece_by_index(idx:int, rollover:bool, do_sound:=true)->void:
	if piece_container.get_child_count() == 0:
		Logger.warn("Cannot select piece of idx %d on empty hand."  % idx)
		return
	
	if idx >= piece_container.get_child_count():
		idx = 0 if rollover else piece_container.get_child_count() - 1
	if idx < 0:
		idx = piece_container.get_child_count() - 1 if rollover else 0

	var new_piece:Piece = piece_container.get_child(idx).piece
	piece_container.get_child(idx).select()
	_on_piece_selected(new_piece, do_sound)


func _input(_event):		
	if Input.is_action_just_pressed("ui_up"):
		_on_left_button_pressed()
	if Input.is_action_just_pressed("ui_down"):
		_on_right_button_pressed()
		
	if Input.is_action_just_pressed("ui_left"):
		choose_previous_piece()
	if Input.is_action_just_pressed("ui_right"):
		choose_next_piece()
	
	if Input.is_action_just_pressed("ui_accept"):
		_on_accept_button_pressed()
		
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

func on_player_damaged(dmg:int)->void:
	for i in range (dmg):#clamp(dmg, 0, piece_container.get_child_count())):
		discard()

func on_player_bumped()->void:
	if piece_container.get_child_count():
		discard(RngUtils.int_range(0, piece_container.get_child_count()-1))
	else:
		Logger.warn("Tried to discard card, but hand is empty.")
