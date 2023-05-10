class_name LevelManager extends Node

var levels:Array[PackedScene] = [
	preload("res://src/world/levels/level_1.tscn"),
	preload("res://src/world/arena.tscn"),
	
	
]
var current_deck:Array[Piece]
var current_level:int = 0
var highest_level:int = 0

const path="usr://game_conf.tres"

func _ready():
	load_data()


func is_last_level() -> bool:
	return current_level >= levels.size()
	

func next_level():
	current_level += 1
	if current_level >= levels.size():
		current_level = 0
	

func reset_level():
	current_level=0

func get_current_level()->PackedScene:
	return levels[current_level]

func get_next_level()->PackedScene:
	current_level += 1
	if current_level >= levels.size():
		current_level = 0
	return get_current_level()
		
func load_data():
	if ResourceLoader.exists(path):
		var conf:GameConfiguration = ResourceLoader.load(path)	as GameConfiguration
		current_deck = conf.current_deck
		current_level = clamp(conf.last_level, 0, levels.size()-1)
		highest_level = clamp(conf.highest_level, 0, levels.size()-1)
		
		Logger.info("Config loaded.")
	else:
		Logger.info("No configuration found.")

func save_data():
	var conf := GameConfiguration.new()
	conf.current_deck = current_deck
	conf.last_level = current_level
	conf.highest_level = highest_level
	
	var error = ResourceSaver.save(conf, path)
	if error != OK:
		Logger.error("Failure!")
	else:
		Logger.info("Config saved.")

func _exit_tree():
	save_data()
