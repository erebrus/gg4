extends Control

const Choice = preload("res://src/choose_piece/choice_piece.tscn")


@export var deck: Deck
@export var num_pieces: int = 3
@export var pieces: Array[Piece]


@onready var bg: ColorRect = get_node("ColorRect")
@onready var pieces_container: Container = get_node("%Pieces")


func _ready() -> void:
	bg.color = Globals.TRANSITION_COLOR
	
	if pieces.is_empty():
		var all_options = deck.generate()
		pieces.append_array(all_options.slice(0, num_pieces))
	
	for piece in pieces:
		var scene = Choice.instantiate()
		scene.piece = piece
		scene.selected.connect(_on_piece_selected.bind(piece))
		pieces_container.add_child(scene)
		
	

func _on_piece_selected(piece: Piece) -> void:
	Globals.deck.append(piece)
	Globals.level_manager.next_level()
	SceneManager.change_scene(Globals.MAIN_SCREEN, {
		"pattern":"curtains" ,
		"wait_time":0,
		"invert": true,
		"color": Globals.TRANSITION_COLOR
	})
