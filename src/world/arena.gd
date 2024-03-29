extends TileMap
class_name Arena


const EnemyScene:PackedScene = preload("res://src/characters/enemies/enemy.tscn")
const PlayerScene:PackedScene = preload("res://src/characters/player/player.tscn")
const ObstacleScene:PackedScene = preload("res://src/world/obstacle.tscn")

enum CellType {EMPTY, OBSTACLE}


@export var grid_size_x:int = 15
@export var grid_size_y:int = 8

@export var default_deck:Deck
@export var shuffle_deck:bool = true
@export var show_keys:bool = false
@export var tutorials:Array[String]

var turn_manager:TurnManager

var tile_size:Vector2:
	get:
		return tile_set.tile_size 
#TODO get this from tilemap itself
var grid_size:Vector2 = Vector2(grid_size_x, grid_size_y)


var first_turn:=true
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(tile_set)

	init_children()
	Events.player_queue_empty.connect(check_tutorial)
	Logger.info("Arena initialised.")

func check_tutorial():
	
	if first_turn:		
		first_turn = false
		return
	
	if show_keys:
		Events.request_keys.emit(false)
		show_keys = false
	if tutorials != null and not tutorials.is_empty():
		var msg:String=tutorials.pop_front()
		if msg.length()>0:
			Events.request_tutorial.emit(msg)
		else:
			Events.request_hide_panels.emit()
	else:
		Events.player_queue_empty.disconnect(check_tutorial)
	
func init_children():	
	for child in get_children():
		if child.is_in_group("map_element"):
			child.position = map_to_local(local_to_map(child.position))
			if child.has_method("tick"):
				turn_manager.register(child)
				


func is_in_arena(pos:Vector2)->bool:
	return pos.x >= 0 && pos.x < grid_size_x && pos.y >= 0 && pos.y < grid_size_y 


func get_new_local_position(this_world_pos:Vector2, direction:Vector2i=Vector2.ZERO)->Vector2:

	var this_grid_pos = local_to_map(this_world_pos)
	var new_grid_pos = this_grid_pos + direction

	var new_world_pos:Vector2 = map_to_local(new_grid_pos)
	return new_world_pos

		
