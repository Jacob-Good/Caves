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

var chests : Dictionary = {
	"10,13": {"type" : "Wood Chest", "state" : "open", "inventory" : [01, 02, 03]},
	"19,16": {"type" : "Wood Chest", "state" : "open", "inventory" : [01, 01, 01]},
	"29,12": {"type" : "Wood Chest", "state" : "open", "inventory" : [01, 02, 02]},
	"17,4": {"type" : "Wood Chest", "state" : "open", "inventory" : [01, 01, 03]},
	"29,1": {"type" : "Wood Chest", "state" : "open", "inventory" : [02, 02, 02]},
	"31,1": {"type" : "Wood Chest", "state" : "open", "inventory" : [02, 03, 03]},
}

var items : Dictionary = {
	01: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	02: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	03: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	04: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	05: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	06: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	07: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	08: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	09: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	10: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	11: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""},
	12: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "texture": ""}
}
