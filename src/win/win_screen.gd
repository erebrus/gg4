extends Control


var can_exit = false

@onready var discard_pile := $Deathbag
@onready var deck_pile := $Bag
@onready var balance := $Scale
@onready var title_label := get_node("%Label")


const RANKS = {
	"Shogi": 10,
	"Dead of Winter": 18,
	"Settlers of Catan": 25,
	"Uno": 50
}

func _ready():
	await animate_scale()
	$Timer.start()
	
	await get_tree().create_timer(0.3).timeout
	can_exit = true
	

func _input(event: InputEvent):
	if not can_exit:
		return
	if event is InputEventKey or (event is InputEventMouseButton and event.is_pressed()):
		exit()
	

func exit():
	can_exit = false
	Globals.next_level()
	

func _on_timer_timeout():
	exit()
	

func animate_scale():
	var tween = create_tween()
	discard_pile.global_position.x = balance.right_plate_base.x
	
	tween.tween_property(discard_pile, "position", balance.right_plate_base, 0.3).set_ease(Tween.EASE_IN)
	tween.tween_callback(add_discard_pile_to_plate)
	
	tween.tween_property(balance, "angle", 0.5, 0.2)
	tween.tween_property(balance, "angle", 0.3, 0.1)
	tween.tween_property(balance, "angle", 0.45, 0.1)
	tween.tween_property(balance, "angle", 0.4, 0.1)
	await tween.finished
	
	var final_rank = RANKS.keys().back()
	
	var min_angle = -0.1
	var max_angle = 0.4
	var angle_step = (max_angle - min_angle) / RANKS.size()
	
	var target_angle = min_angle
	
	for rank in RANKS:
		if Globals.level_manager.last_discard_size < RANKS[rank]:
			final_rank = rank
			break
		target_angle += angle_step
	
	title_label.text = "%s - %s" % [Globals.level_manager.last_discard_size, final_rank]
	
	tween = create_tween()
	tween.tween_property(deck_pile, "position", balance.left_plate_base, 0.3).set_ease(Tween.EASE_IN)
	tween.tween_callback(add_deck_pile_to_plate)
	tween.tween_property(balance, "angle", target_angle - 0.1, 0.2)
	tween.tween_property(balance, "angle", target_angle + 0.1, 0.1)
	tween.tween_property(balance, "angle", target_angle - 0.05, 0.1)
	tween.tween_property(balance, "angle", target_angle, 0.1)
	tween.tween_interval(0.2)
	
	await tween.finished
	
	$rank.play()
	$TitlePanel.show()
	

func add_discard_pile_to_plate():
	$squeak.play()
	balance.add_to_right_plate(discard_pile)

func add_deck_pile_to_plate():
	$squeak.play()
	balance.add_to_left_plate(deck_pile)
