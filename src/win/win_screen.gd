extends "res://src/gameover/gameover.gd"


func set_data(num_pieces: int) -> void:
	var pieces_label: Label = get_node("%PiecesLabel")
	pieces_label.text = str(num_pieces)
