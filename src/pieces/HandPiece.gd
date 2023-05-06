extends MarginContainer


signal selected
signal unselected


@export var piece: Piece


@onready var sprite: TextureRect = get_node("%Sprite")


var is_selected:= false


func _ready() -> void:
	sprite.texture = piece.texture
	modulate = Color.RED
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if is_selected:
			unselect()
		else:
			select()
	

func select() -> void:
	if is_selected:
		return
	is_selected = true
	modulate = Color.YELLOW
	selected.emit()
	

func unselect() -> void:
	if not is_selected:
		return
	is_selected = false
	modulate = Color.RED
	unselected.emit()
	
