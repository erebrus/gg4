extends TileMap
class_name Arena


signal tick()


const EnemyScene:PackedScene = preload("res://src/Characters/Enemies/Enemy.tscn")
const PlayerScene:PackedScene = preload("res://src/Characters/Player/Player.tscn")
const ObstacleScene:PackedScene = preload("res://src/World/Obstacle.tscn")

enum CellType {EMPTY, OBSTACLE}


@export var grid_size_x:int = 15
@export var grid_size_y:int = 9
@export var enable_debug_elements := true
@export var enable_debug_mode := true

@export var start_position:Vector2 = Vector2(1,1)

var tile_size:Vector2 
var grid_size:Vector2 = Vector2(grid_size_x, grid_size_y)

var grid:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(tile_set)
	tile_size = tile_set.tile_size

	init_grid()
	init_player()
	if enable_debug_elements:
		init_debug_obstacles()
		init_debug_enemies()
	Logger.info("Arena initialised.")

func init_player():
	var player:Character = PlayerScene.instantiate()
	add_child(player)
	player.position = map_to_local(start_position)
	tick.connect(player.tick)
	
func init_debug_enemies():
	add_debug_enemy(Vector2i(3,8))
func init_debug_obstacles():
	add_debug_obstacle(Vector2i(4,5))
	
func add_debug_enemy(cell_pos:Vector2i)->void:
	var enemy:Enemy = EnemyScene.instantiate()
	add_child(enemy)
	enemy.position = map_to_local(cell_pos)
	tick.connect(enemy.tick)
	
func add_debug_obstacle(cell_pos:Vector2i)->void:
	var o = ObstacleScene.instantiate()	
	grid[cell_pos.x][cell_pos.y] = CellType.OBSTACLE
	add_child(o)
	o.position = map_to_local(cell_pos)		
	
func init_grid():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(CellType.EMPTY)

func is_in_arena(pos:Vector2)->bool:
	return pos.x >= 0 && pos.x < grid_size_x && pos.y >= 0 && pos.y < grid_size_y 

func check_for_obstacle(pos)->bool:
	if !is_in_arena(pos):
		return false
	if grid[pos.x][pos.y]==CellType.OBSTACLE:
		return true		
	return false
	
func is_cell_vacant(this_grid_pos=Vector2(), direction=Vector2()):	
	var target_grid_pos:Vector2 = local_to_map(this_grid_pos) + direction
	# Check if target cell is within the grid
	if is_in_arena(target_grid_pos):
		# If within grid return true if target cell is empty
		if grid[target_grid_pos.x][target_grid_pos.y] == CellType.EMPTY:
			return true
		else:
			return false
	return false
	
func update_child_pos(this_world_pos, direction, type)->Vector2:

	var this_grid_pos = local_to_map(this_world_pos)
	var new_grid_pos = this_grid_pos + direction



	var new_world_pos:Vector2 = map_to_local(new_grid_pos)
	return new_world_pos

func _input(event):
	if enable_debug_mode and Input.is_action_just_pressed("ui_accept"):
		tick.emit()
		
