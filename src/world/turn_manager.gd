extends Node
class_name TurnManager

@export var enable_debug_mode := true

var elements:Array = []
var elements_moving:Array = []

func register(element):
	elements.append(element)
	element.tick_complete.connect(on_tick_complete.bind(element))

func on_tick_complete(el):
	if not el in elements_moving:
		Logger.warn("Tried to remove %s from moving list, but element is not there." % [el.name])
	elements_moving.erase(el)
	if turn_complete():
		Logger.debug("Tick done.")
func tick():
	Logger.debug("Tick")
	elements_moving = []
	elements_moving.append_array(elements)
	for el in elements_moving:
		el.tick()
	
func turn_complete()->bool:
	return elements_moving.is_empty()
	
func _input(_event):
	if turn_complete() and enable_debug_mode and Input.is_action_just_pressed("ui_accept"):
		tick() 
