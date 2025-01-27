extends Node

# Top bar removed for now, may not need at all? Probably will need eventually
#@onready var window_size : Vector2 = DisplayServer.window_get_size()

var occupied_tiles : Dictionary = {}

var tile_dict : Dictionary = {}

var directions : Array = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,"skip"]

var main_menu : bool = false

var player_coords : Vector2i

var dragging_item : bool = false

var item_dragged_to

func vector_to_string(coord):
	return str(coord.x) + "," + str(coord.y)
	
func get_all_surrounding_cells(coords : Vector2i, map : TileMapLayer) -> Array:
	var all_tiles : Array
	all_tiles = map.get_surrounding_cells(coords)
	all_tiles.append(map.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER))
	all_tiles.append(map.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER))
	all_tiles.append(map.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER))
	all_tiles.append(map.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER))
	return all_tiles

var chests : Dictionary = {
	"10,13": {"type" : "Wood Chest", "state" : "open", "inventory" : [01, 02, 03]},
	"19,16": {"type" : "Wood Chest", "state" : "open", "inventory" : [04, 05, 06]},
	"29,12": {"type" : "Wood Chest", "state" : "open", "inventory" : [07, 08, 09]},
	"17,4": {"type" : "Wood Chest", "state" : "open", "inventory" : [10, 11, 03]},
	"29,1": {"type" : "Wood Chest", "state" : "open", "inventory" : [10, 05, 02]},
	"31,1": {"type" : "Wood Chest", "state" : "open", "inventory" : [01, 11, 06]},
	"-32,-25": {"type" : "Wood Chest", "state" : "open", "inventory" : [08, 01, 06]}
}

var items : Dictionary = {
	00: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	01: {"name": "Practice Sword", "type": "long blade", "desc": "A wooden sword designed for sparring and not much else. Every great fighter held one of these at some point.", "value": 1, "weight": 1, "damage": 1, "defense": 0, "range": 0, "max_dur": 5, "cur_dur": 5, "texture": "res://images/items/sword_01.png"},
	02: {"name": "Long Sword", "type": "long blade", "desc": "Basic iron long sword. Standard issue for soldiers, guards and adventurers alike.", "value": 10, "weight": 3, "damage": 3, "defense": 1, "range": 0, "max_dur": 20, "cur_dur": 20, "texture": "res://images/items/sword_01.png"},
	03: {"name": "Short Sword", "type": "short blade", "desc": "A short blade typically used as a side weapon or those of shorter stature.", "value": 4, "weight": 2, "damage": 2, "defense": 1, "max_dur": 15, "cur_dur": 15, "range": 0, "texture": "res://images/items/sword_01.png", "trait_01": "nimble"},
	04: {"name": "Spear", "type": "polearm", "desc": "A simple polearm. Standard issue for soldiers and city guard around the lands.", "value": 6, "weight": 2, "damage": 2, "defense": 0, "max_dur": 15, "cur_dur": 15, "range": 0, "texture": "res://images/items/kite_shield_01.png", "trait_01": "reach"},
	05: {"name": "Bastard Sword", "type": "great", "desc": "A large sword that can be used both one and two handed. Typically weilded by knights or people of high regard.", "value": 20, "weight": 6, "damage": 5, "defense": 3, "max_dur": 20, "cur_dur": 20, "range": 0, "texture": "res://images/items/sword_01.png", "trait_01": "versatile", "trait_02": "reach"},
	06: {"name": "Claymore", "type": "great", "desc": "A massive sword only used by the strongest of warriors, or those seeking to overcompensate for something. Avoid being hit by these at all costs.", "value": 30, "weight": 10, "damage": 8, "defense": 2, "max_dur": 25, "cur_dur": 25, "range": 0, "texture": "res://images/items/sword_01.png", "trait_01": "cumbersome", "trait_02": "reach"},
	07: {"name": "Short Bow", "type": "bow", "desc": "A small wooden bow. It's short range makes it a regular choice for hobbyist archers and hunters. Not extremely useful in combat situations.", "value": 4, "weight": 1, "damage": 2, "defense": 0, "max_dur": 15, "cur_dur": 15, "range": 3, "texture": "res://images/items/bow_01.png"},
	08: {"name": "Long Bow", "type": "bow", "desc": "Traditional bow used for military purpouses. Longer range than the short bow. A skilled archer can hit a target at a fairly long range.", "value": 15, "weight": 3, "damage": 4, "defense": 0, "max_dur": 15, "cur_dur": 15, "range": 5, "texture": "res://images/items/bow_01.png", "trait_01": "cumbersome"},
	09: {"name": "Composite Bow", "type": "bow", "desc": "More complex designed bow to allow for the range and power of a long bow with the maneuverability and size of a short bow.", "value": 30, "weight": 2, "damage": 4, "defense": 0, "max_dur": 10, "cur_dur": 10, "range": 5, "texture": "res://images/items/bow_01.png"},
	10: {"name": "Light Crossbow", "type": "crossbow", "desc": "Small one handed mechanical crossbow. Packs a decent punch in a small package but requires time to load and prepare for a second shot.", "value": 20, "weight": 3, "damage": 3, "defense": 0, "max_dur": 20, "cur_dur": 20, "range": 3, "texture": "res://images/items/bow_01.png"},
	11: {"name": "Heavy Crossbow", "type": "crossbow", "desc": "Large device that packs more punch than any bow. Needs two hands to operate and is rather heavy.", "value": 30, "weight": 5, "damage": 5, "defense": 0, "max_dur": 20, "cur_dur": 20, "range": 5, "texture": "res://images/items/bow_01.png", "trait_01": "cumbersome"},
	12: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	13: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	14: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	15: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	16: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	17: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	18: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	19: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	20: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	21: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	22: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	23: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	24: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	25: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	26: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	27: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	28: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	29: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
	30: {"name": "", "type": "", "desc": "", "value": 0, "weight": 0, "damage": 0, "defense": 0, "max_dur": 0, "cur_dur": 0, "range": 0, "texture": ""},
}

var player_inventory : Array

var weapon_types : Array = ["Dagger","Short Sword","Long Sword","Bastard Sword","Great Sword","Hand Axe",
							"Felling Axe","Battle Axe","Great Axe","Club","Mace","Morning Star","Flail",
							"Great Hammer","Warhammer","Quarter Staff","Spear","Halberd","Pole-Axe","Scythe",
							"War Scythe","Scimitar","Falchion","Katana","Rapier"]

var weapons : Dictionary = {
	"Dagger": {"Type": "B", "Attack": 2, "Skills": ["Agility","Short Blades","Throwing","Reflex"], "Traits": [], "Base": [1,1,6,10]},
	"Short Sword": {"Type": "M", "Attack": 3, "Skills": ["Agility","Strength","Short Blades","Reflex"], "Traits": [], "Base": [1,2,2,6]},
	"Long Sword": {"Type": "M", "Attack": 4, "Skills": ["Strength","Long Blades"], "Traits": [], "Base": [1,2,2,7]},
	"Bastard Sword": {"Type": "M", "Attack": 6, "Skills": ["Strength","Long Blades"], "Traits": [], "Base": [2,7,8,9]},
	"Great Sword": {"Type": "M", "Attack": 8, "Skills": ["Strength","Long Blades","Great Weapon"], "Traits": [], "Base": [3,7,8,9]},
	"Hand Axe": {"Type": "B", "Attack": 2, "Skills": ["Agility","Strength","Axes","Throwing"], "Traits": [], "Base": [3,3,7,10]},
	"Felling Axe": {"Type": "M", "Attack": 4, "Skills": ["Strength","Axes"], "Traits": [], "Base": [3,3,7,9]},
	"Battle Axe": {"Type": "M", "Attack": 6, "Skills": ["Strength","Axes"], "Traits": [], "Base": [3,3,7,9]},
	"Great Axe": {"Type": "M", "Attack": 8, "Skills": ["Strength","Axes","Great Weapon"], "Traits": [], "Base": [3,7,9,9]},
	"Club": {"Type": "M", "Attack": 3, "Skills": ["Strentgh","Bludgeons"], "Traits": [], "Base": [4,4,7,7]},
	"Mace": {"Type": "M", "Attack": 4, "Skills": ["Strength","Bludgeons"], "Traits": [], "Base": [4,4,4,9]},
	"Morning Star": {"Type": "M", "Attack": 4, "Skills": ["Strength","Bludgeons"], "Traits": [], "Base": [4,4,4,9]},
	"Great Hammer": {"Type": "M", "Attack": 6, "Skills": ["Strength","Bludgeons","Great Weapon"], "Traits": [], "Base": [4,7,9,9]},
	"War Hammer": {"Type": "M", "Attack": 5, "Skills": ["Strength","Bludgeons"], "Traits": [], "Base": [4,4,7,9]},
	"Flail": {"Type": "M", "Attack": 4, "Skills": [], "Traits": ["Agility","Strength","Bludgeons"], "Base": [4,9,9,9]},
	"Quarter Staff": {"Type": "M", "Attack": 2, "Skills": ["Agility","Strength","Bludgeons","Staffs"], "Traits": [], "Base": [4,7,8,9]},
	"Spear": {"Type": "B", "Attack": 3, "Skills": ["Strength","Polearms"], "Traits": [], "Base": [5,7,8,10]},
	"Halberd": {"Type": "M", "Attack": 4, "Skills": ["Strength","Axes","Polearms"], "Traits": [], "Base": [3,5,8,9]},
	"Pole-Axe": {"Type": "M", "Attack": 4, "Skills": ["Strength","Axes","Bludgeons",'Polearms'], "Traits": [], "Base": [4,5,8,9]},
	"Scythe": {"Type": "M", "Attack": 2, "Skills": ["Agility","Strength","Exotic Weapons"], "Traits": [], "Base": [2,2,3,7]},
	"War Scythe": {"Type": "M", "Attack": 4, "Skills": ["Strength","Exotic Weapons","Polearms"], "Traits": [], "Base": [2,3,5,9]},
	"Scimitar": {"Type": "M", "Attack": 4, "Skills": ["Agility","Strength","Long Blades","Exotic Weapons"], "Traits": [], "Base": [2,3,6,7]},
	"Falchion": {"Type": "M", "Attack": 4, "Skills": ["Agility","Strength","Long Blades","Exotic Weapon"], "Traits": [], "Base": [2,3,6,7]},
	"Katana": {"Type": "M", "Attack": 4, "Skills": ["Agility","Strength","Long Blades","Exotic Weapon"], "Traits": [], "Base": [2,2,6,8]},
	"Rapier": {"Type": "M", "Attack": 3, "Skills": ["Agility","Long Blades","Reflex"], "Traits": [], "Base": [1,1,8,8]},
	"Short Bow": {"Type": "R", "Attack": 3, "Skills": ["Agility","Shooting"], "Traits": [], "Base": [11,12,12,13]},
	"Long Bow": {"Type": "R", "Attack": 4, "Skills": ["Agility","Shooting"], "Traits": [], "Base": [11,11,12,12]},
	"Composite Bow": {"Type": "R", "Attack": 4,  "Skills": ["Agility","Shooting"], "Traits": [], "Base": [11,12,12,13]},
	"Hand Crossbow": {"Type": "R", "Attack": 3,  "Skills": ["Agility","Shooting"], "Traits": [], "Base": [11,11,12,12]},
	"Light Crossbow": {"Type": "R", "Attack": 4,  "Skills": ["Agility","Shooting"], "Traits": [], "Base": [11,11,12,12]},
	"Heavy Crossbow": {"Type": "R", "Attack": 6,  "Skills": ["Agility","Shooting"], "Traits": [], "Base": [11,11,12,12]},
	"Repeating Crossbow": {"Type": "R", "Attack": 4,  "Skills": ["Agility","Shooting","Exotic Weapon"], "Traits": [], "Base": [11,12,12,13]},
	"Stone Bow": {"Type": "R", "Attack": 2,  "Skills": ["Agility","Shooting","Exotic Weapon"], "Traits": [], "Base": [11,11,12,12]},
	"Sling": {"Type": "R", "Attack": 1, "Skills": ["Agility","Throwing"], "Traits": [], "Base": [11,12,12,12]},
	"Dart": {"Type": "R", "Attack": 2, "Skills": ["Agility","Throwing"], "Traits": [], "Base": [11,12,12,12]},
	"Shurikan": {"Type": "R", "Attack": 2, "Skills": ["Agility","Throwing"], "Traits": [], "Base": [11,12,12,12]}
}

var base_weapon_cards : Array = ["","Stab","Slash","Chop","Club","Dig In","Parry",
							"Block","Thrust","Swing","Throw","Aim","Shoot","Let Loose"]

var player_equip : Dictionary = {
	"Head": "",
	"Chest": "",
	"Arms": "",
	"Hands": "",
	"Legs": "",
	"Feet": "",
	"Amulet": "",
	"Ring01": "",
	"Ring02": "",
	"Hand01": "Spear",
	"Hand02": "Dagger",
}
var companion_equip : Dictionary = {
	"Head": "",
	"Chest": "",
	"Arms": "",
	"Hands": "",
	"Legs": "",
	"Feet": "",
	"Amulet": "",
	"Ring01": "",
	"Ring02": "",
	"Hand01": "",
	"Hand02": "",
}

var deck_list : Array


func update_deck (player_gear, companion_gear):
	Global.deck_list.clear()
	var equip_slot =0
	for n in player_gear:
		if Global.player_equip[n] == "":
			equip_slot += 1
			pass
		else:
			if equip_slot < 6:
				Global.deck_list.append_array(Global.armor[player_equip[n]]["Base"])
			if equip_slot < 9:
				Global.deck_list.append_array(Global.accesories[player_equip[n]]["Base"])
			else:
				Global.deck_list.append_array(Global.weapons[player_equip[n]]["Base"])
			equip_slot += 1
			
	equip_slot = 0
	for n in companion_gear:
		if Global.companion_equip[n] == "":
			equip_slot += 1
			pass
		else:
			if equip_slot < 6:
				Global.deck_list.append_array(Global.armor[companion_equip[n]]["Base"])
			if equip_slot < 9:
				Global.deck_list.append_array(Global.accesories[companion_equip[n]]["Base"])
			else:
				Global.deck_list.append_array(Global.weapons[companion_equip[n]]["Base"])
			equip_slot += 1
