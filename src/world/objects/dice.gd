extends Area2D

enum FaceType {ATTACK_PIECE, CHARGE_PIECE, BLOCK_PIECE, 
	SPRINT_PIECE, GET_FROM_DISCARD, DISCARD_ONE
#	, RESHUFFLE_HAND, , DISCARD_HAND
	} 

var faces:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	faces = RngUtils.array(FaceType.values(), 6 , true)
	Logger.info("dice set with %s" % [faces])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var face:FaceType = RngUtils.array(faces)[0]
	Logger.debug("Selected dice face=%s" % FaceType.keys()[face])
	match face:
		FaceType.ATTACK_PIECE:
			Events.piece_given.emit(preload("res://src/gui/pieces/attack.tres"))
	queue_free()
	
