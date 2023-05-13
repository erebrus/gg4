extends Node
class_name TurnManager

var elements:Array = []
var elements_moving:Array = []
var tick_pending:bool = false

func _ready():
	Events.announce_death.connect(unregister)

func unregister(element):
	elements.erase(element)
	element.tick_complete.emit()
	elements_moving.erase(element)
	

func register(element):
	elements.append(element)
	element.tick_complete.connect(_on_tick_complete.bind(element))
	if element.is_in_group("player"):
		Events.player_ticked.connect(_on_player_ticked)

func _on_player_ticked()->void:
	if turn_complete():
		tick()
	else:
		tick_pending=true
		
func _on_tick_complete(el)->void:
	if not el in elements_moving:
		Logger.warn("Tried to remove %s from moving list, but element is not there." % [el.name])
	elements_moving.erase(el)
	if el.is_in_group("player"):
		Globals.player_in_turn=false
		Logger.debug("Turn player over")
	if turn_complete():
		Logger.debug("Tick done.")
		if tick_pending:
			tick_pending = false
			tick()
		else:
			Events.turn_complete.emit()

func tick()->void:
	Logger.debug("Tick")
	elements_moving = []
	elements_moving.append_array(elements)
	for el in elements_moving:
		if el.is_in_group("player"):
			Globals.player_in_turn=true
			Logger.debug("Turn player start")
		el.tick()
	
func turn_complete()->bool:
	return elements_moving.is_empty()
	
