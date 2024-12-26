extends Node

# Top bar removed for now, may not need at all? Probably will need eventually
#@onready var window_size : Vector2 = DisplayServer.window_get_size()

var occupied_tiles : Dictionary = {}

var tile_dict : Dictionary = {}

var directions : Array = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,"skip"]

var main_menu : bool = false

var player_coords : Vector2i

func vector_to_string(coord):
	return str(coord.x) + "," + str(coord.y)
	

	
