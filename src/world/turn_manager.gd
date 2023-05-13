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
		Events.trigger_tick.connect(_on_trigger_tick)

func _on_trigger_tick()->void:
	if turn_complete():
		tick()
	else:
		tick_pending=true
	

func _on_tick_complete(el)->void:
	if not el in elements_moving:
		Logger.warn("Tried to remove %s from moving list, but element is not there." % [el.name])
	elements_moving.erase(el)
	
	if turn_complete():
		Events.turn_complete.emit()
		
		Logger.debug("Tick done. Pending: %s" % tick_pending)
		if tick_pending:
			tick_pending = false
			tick()
		

func tick()->void:
	Logger.debug("Tick")
	elements_moving = []
	elements_moving.append_array(elements)
	
	for el in elements_moving:
		el.tick()
	

func turn_complete()->bool:
	return elements_moving.is_empty()
	
