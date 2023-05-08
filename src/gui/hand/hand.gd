class_name Hand extends MarginContainer


signal piece_placed(piece: Piece)


const HandPiece = preload("res://src/gui/hand/hand_piece.tscn")


@export var max_pieces: int = 4
var num_pieces:
	get:
		return pieces.size()
	

var selected_piece: Piece
var pieces: Dictionary


@onready var piece_container = get_node("%Pieces")


func add(piece: Piece) -> void:
	var scene = HandPiece.instantiate()
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
	

func _on_piece_selected(piece: Piece) -> void:
	selected_piece = piece
	for child in piece_container.get_children():
		if child.piece != piece:
			child.unselect()
	

func _on_piece_unselected(piece: Piece) -> void:
	if selected_piece == piece:
		selected_piece = null
	

func _on_left_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].rotate_left()
	

func _on_right_button_pressed():
	if selected_piece != null:
		pieces[selected_piece].rotate_right()
	

func _on_accept_button_pressed():
	if selected_piece != null:
		var piece_count:int = piece_container.get_child_count()
		var idx = get_index_of_piece(selected_piece)
		pieces[selected_piece].place()
		piece_container.remove_child(pieces[selected_piece])
		pieces.erase(selected_piece)
		piece_placed.emit(selected_piece)
		
		piece_count = piece_container.get_child_count()
		if piece_count == 0:
			selected_piece = null
		else:
			if idx >= piece_count:
				idx = piece_count - 1
			var hand_piece = piece_container.get_child(idx)
			hand_piece.select()
			var new_selected_piece = hand_piece.piece
			_on_piece_selected(new_selected_piece)
			
func choose_previous_piece()->void:
	var idx = get_index_of_piece(selected_piece)
	if idx == -1:
		Logger.warn("No piece selected, so we can't select previous piece")
		return
	idx -= 1
	if idx < 0:
		idx = piece_container.get_child_count() - 1
	var new_piece:Piece = piece_container.get_child(idx).piece
	piece_container.get_child(idx).select()
	_on_piece_selected(new_piece)

func get_index_of_piece(piece:Piece)->int:
	for idx in range(piece_container.get_child_count()):
		if piece_container.get_child(idx).piece == piece:
			return idx
	return -1
	
func choose_next_piece()->void:
	var idx = get_index_of_piece(selected_piece)
	if idx == -1:
		Logger.warn("No piece selected, so we can't select next piece")
		return
	idx += 1
	if idx >= piece_container.get_child_count():
		idx = 0
	var new_piece:Piece = piece_container.get_child(idx).piece
	piece_container.get_child(idx).select()
	_on_piece_selected(new_piece)


func _input(_event):		
	if Input.is_action_just_pressed("ui_up"):
		_on_left_button_pressed()
	if Input.is_action_just_pressed("ui_down"):
		_on_left_button_pressed()
		
	if Input.is_action_just_pressed("ui_left"):
		choose_previous_piece()
	if Input.is_action_just_pressed("ui_right"):
		choose_next_piece()
	
	if Input.is_action_just_pressed("ui_accept"):
		_on_accept_button_pressed()
		
