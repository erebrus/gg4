class_name Deck extends Resource

@export var pieces: Array[Piece]


func random() -> Piece:
	return pieces.pick_random().duplicate()
	
# DOUBTS:
# - option 1: fixed "deck" with number of pieces of each shape -> when deck runs out game over / reshuffle
# - option 2: infite number of pieces
#		- different probability for each piece shape
