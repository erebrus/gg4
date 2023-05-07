extends TileMap
#
#@export var debug_mode := false
#@export var layers_to_process:Array[int] = []
#@export var tile_scenes:Dictionary= {}
#
#@onready var half_cell_size := cell_size * 0.5
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	await get_tree().process_frame
#	_replace_tiles_with_scenes()
#
#func _replace_tiles_with_scenes(scene_dictionary:Dictionary = tile_scenes):
#	for layer in layers_to_process:
#		for tile_pos in get_used_cells(layer):
#			var tile_id = get_cell_source_id(layer, tile_pos)			
#			if scene_dictionary.has(tile_id):
#				var obj_scene = scene_dictionary[tile_id]
#				_replace_tile_with_object(tile_id, layer, tile_pos, obj_scene)
#
#func _replace_tile_with_object(tile_id:int, layer:int , tile_pos:Vector2, object_scene:PackedScene, parent: Node = self):
#	#clear cel in tilemap		
#	if get_cell_tile_data(layer, tile_pos) and not debug_mode:
#		set_cell(layer,tile_pos,-1)
#
#	#spawn the object
#	if object_scene:
#		var obj = object_scene.instantiate()
#		var offset=Vector2(8,8)
#		if obj.has_method("get_tilemap_offset"):
#			offset = obj.get_tilemap_offset()
#		if obj.has_method("init_tileset_id"):
#			obj.init_tileset_id(tile_id)
#		var obj_pos = map_to_world(tile_pos) + offset
#		parent.add_child(obj)
#		obj.global_position = to_global(obj_pos)
#		if is_cell_transposed(tile_pos.x, tile_pos.y):
#			obj.rotation = PI/2
#		if is_cell_x_flipped(tile_pos.x, tile_pos.y):
#			obj.rotation = PI/2
#		if is_cell_y_flipped(tile_pos.x, tile_pos.y):
#			obj.rotation = PI/2
#		if debug_mode:
#			schedule_blink(obj)
#
#
#func schedule_blink(obj):
#	obj.visible = not obj.visible
#	yield(get_tree().create_timer(1),"timeout")		
#	schedule_blink(obj)
