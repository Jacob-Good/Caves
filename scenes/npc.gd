extends AnimatedSprite2D

@onready var map = $"../../Map/Ground"
@onready var object_map = $"../../Map/Objects"
@onready var game = $"../.."

@export var data : NpcData

func _ready():
	
	Global.tile_dict[Global.vector_to_string($"../../Map/Ground".local_to_map(global_position))] = true
	
	Global.occupied_tiles[str($"../../Map/Ground".local_to_map(global_position))] = self


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
	# Currently obsolete by game function, may remove later 
	#var tile_data : TileData = map.get_cell_tile_data(target_tile)
	#var object_tile_data : TileData = object_map.get_cell_tile_data(target_tile)
	
	if game.is_tile_walkable(target_tile) == false:
		return
	
	global_position = map.map_to_local(target_tile)
	Global.occupied_tiles[str(target_tile)] = self
	Global.occupied_tiles.erase(str(current_tile))
	
