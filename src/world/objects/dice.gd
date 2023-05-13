extends Area2D
class_name Dice

enum FaceType {ATTACK_PIECE, CHARGE_PIECE, BLOCK_PIECE, 
	SPRINT_PIECE, GET_FROM_DISCARD, DISCARD_ONE
#	, RESHUFFLE_HAND, , DISCARD_HAND
	} 

var faces:Array[FaceType]
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dice_roll_complete.connect(_on_dice_roll_completed)
	var t_faces = RngUtils.array(FaceType.values(), 6 , true) 
	for t in t_faces:
		if faces == null:
			faces = [t]
		else:
			faces.append(t)
		
	Logger.info("dice set with %s" % [faces])

func _on_dice_roll_completed():
	if player == null:
		return
	player.clear_suspension()
	queue_free()

func _on_body_entered(body):
	player = body
	player.suspend_tick()

	Events.request_dice_roll.emit(faces)	
	
	
	
