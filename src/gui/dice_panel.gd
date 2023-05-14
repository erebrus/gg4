extends Control


const TEXTURES = {
	Dice.FaceType.GET_FROM_DISCARD: preload("res://assets/gfx/dice/faces/draw_from_discard.png"), 
	Dice.FaceType.DISCARD_ONE: preload("res://assets/gfx/dice/faces/discard_one.png") 
}
const PIECES = {
	Dice.FaceType.ATTACK_PIECE: preload("res://src/gui/pieces/attack.tres"),
	Dice.FaceType.CHARGE_PIECE: preload("res://src/gui/pieces/charge.tres"),
	Dice.FaceType.BLOCK_PIECE: preload("res://src/gui/pieces/shield.tres"),
	Dice.FaceType.SPRINT_PIECE: preload("res://src/gui/pieces/sprint.tres")
}


@onready var player:=$AnimationPlayer
@onready var face_texture:=$Dice/Face
@onready var timer:=$Timer
@onready var piece:=$Dice/BasePiece


var faces:Array[Dice.FaceType]
var face=null

func _ready():
	Events.request_dice_roll.connect(on_dice_roll)
	

func change_face():
	face = faces[RngUtils.int_range(0, 5)]
	if face == Dice.FaceType.DISCARD_ONE or face == Dice.FaceType.GET_FROM_DISCARD:
		piece.hide()
		face_texture.show()
		face_texture.texture = TEXTURES[face]
	else:
		piece.show()
		face_texture.hide()
		
		piece.commands = PIECES[face].commands
	

func on_dice_roll(new_faces:Array[Dice.FaceType] ):
	faces = new_faces
	face=null
	change_face()
	player.play("show")
	await player.animation_finished
	player.play("roll")
	$sfx_roll.play()
	timer.start()	
	await player.animation_finished
	timer.stop()
	
	Logger.debug("Selected dice face=%s" % Dice.FaceType.keys()[face])
	match face:
		Dice.FaceType.GET_FROM_DISCARD:
			Events.trigger_discard_fetch.emit()
		Dice.FaceType.DISCARD_ONE:
			Events.trigger_discard.emit()
		_:
			Events.piece_given.emit(PIECES[face].copy())
	
	Events.dice_roll_complete.emit()
	await get_tree().create_timer(3).timeout
	player.play("hide")
	

func _on_timer_timeout():
	change_face()
	
