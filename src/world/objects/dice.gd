extends Area2D
class_name Dice

enum FaceType {ATTACK_PIECE, CHARGE_PIECE, BLOCK_PIECE, 
	SPRINT_PIECE, GET_FROM_DISCARD, DISCARD_ONE
#	, RESHUFFLE_HAND, , DISCARD_HAND
	} 

var faces:Array[FaceType]
# Called when the node enters the scene tree for the first time.
func _ready():
	RngUtils.array(FaceType.values(), 6 , true).map(func(x): x as FaceType)
		
	Logger.info("dice set with %s" % [faces])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	Events.request_dice_roll.emit(faces)	
	queue_free()
	
