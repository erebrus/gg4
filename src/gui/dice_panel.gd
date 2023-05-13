extends Control

@onready var player:=$AnimationPlayer
@onready var face_texture:=$Dice/Face
@onready var timer:=$Timer

var faces:Array[Dice.FaceType]
var face=null
var textures:Array[Texture]=[ preload("res://src/world/objects/dicef1.png"),
	preload("res://src/world/objects/dicef2.png"),
	preload("res://src/world/objects/dicef3.png"),
	preload("res://src/world/objects/dicef4.png"),
	preload("res://src/world/objects/dicef5.png"),
	preload("res://src/world/objects/dicef6.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.request_dice_roll.connect(on_dice_roll)



func on_dice_roll(new_faces:Array[Dice.FaceType] ):
	faces = new_faces
	face=null
	player.play("show")
	await player.animation_finished
	player.play("roll")
	$sfx_roll.play()
	timer.start()	
	await player.animation_finished
	timer.stop()


	Logger.debug("Selected dice face=%s" % Dice.FaceType.keys()[face])
	match face:
		Dice.FaceType.ATTACK_PIECE:
			Events.piece_given.emit(preload("res://src/gui/pieces/attack.tres"))
		Dice.FaceType.CHARGE_PIECE:
			Events.piece_given.emit(preload("res://src/gui/pieces/charge.tres"))
		Dice.FaceType.BLOCK_PIECE:
			Events.piece_given.emit(preload("res://src/gui/pieces/shield.tres"))
		Dice.FaceType.SPRINT_PIECE:
			Events.piece_given.emit(preload("res://src/gui/pieces/sprint.tres"))
		Dice.FaceType.GET_FROM_DISCARD:
			Events.trigger_discard_fetch.emit()
		Dice.FaceType.DISCARD_ONE:
			Events.trigger_discard.emit()
	Events.dice_roll_complete.emit()
	await get_tree().create_timer(1).timeout
	player.play("hide")

func _on_timer_timeout():
	face = faces[RngUtils.int_range(0, 5)]
	face_texture.texture = textures[face]
