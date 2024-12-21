extends AnimatedSprite2D

@onready var map = $"../../Map/Ground"
@onready var object_map = $"../../Map/Objects"

@export var npc_data : NpcData

func _ready():
	
	var tile = $"../../Map/Ground".local_to_map(global_position) as Vector2i
	
	Global.tile_dict[Global.vector_to_string($"../../Map/Ground".local_to_map(global_position))] = true
	print(Global.tile_dict)
	
	Global.occupied_tiles.append($"../../Map/Ground".local_to_map(global_position))
	print(Global.occupied_tiles)


func _process(_delta):
	
	
	pass

func move():
	
	var current_tile : Vector2i = map.local_to_map(global_position)
	var direction = Global.directions.pick_random()
	if typeof(direction) == TYPE_STRING:
		return
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x, current_tile.y + direction.y
	)
	
	var tile_data : TileData = map.get_cell_tile_data(target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		print(tile_data.get_custom_data("walkable"))
		return
		
	if Global.occupied_tiles.has(target_tile):
		return
	
	global_position = map.map_to_local(target_tile)
	Global.occupied_tiles.append(target_tile)
	Global.occupied_tiles.remove_at(Global.occupied_tiles.find(current_tile))
	print(Global.occupied_tiles)
	
