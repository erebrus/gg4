extends Area2D
class_name Dice

enum FaceType {ATTACK_PIECE, CHARGE_PIECE, BLOCK_PIECE, 
	SPRINT_PIECE, GET_FROM_DISCARD, DISCARD_ONE
#	, RESHUFFLE_HAND, , DISCARD_HAND
	} 

@export var faces:Array[FaceType]
@export var do_random:=true
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dice_roll_complete.connect(_on_dice_roll_completed)
	if do_random:
		var t_faces = RngUtils.array(FaceType.values(), 6) 
		for t in t_faces:
			if faces == null:
				faces = [t]
			else:
				faces.append(t)
			
		Logger.info("dice set with %s" % [faces])
	else:
		assert(faces !=null and faces.size()==6)
	$Sprite2D.play("default",)

func _on_dice_roll_completed():
	if player == null:
		return
	player.clear_suspension()
	queue_free()

func _on_body_entered(body):
	player = body
	player.suspend_tick()
	$Sprite2D.play("fade")
	Events.request_dice_roll.emit(faces)	
	await $Sprite2D.animation_finished
	var tween:=create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "modulate", Color(1,1,1,0),.25)
	
	
