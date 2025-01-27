extends Node2D

@onready var window_size : Vector2 = DisplayServer.window_get_size()
@onready var map = $Map/Ground
@onready var object_map = $Map/Objects
@onready var camera = $Camera

var container_scene: PackedScene = preload("res://scenes/container_window.tscn")

func _ready():
	$MainMenu.start_flashing() # Disabled because we are skipping the main menu

	
func _process(_delta):
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("space bar"):
		if Global.main_menu:
			$MainMenu.stop_flashing()
			$Map.visible = true
			$Player.visible = true
		else:
			world_turn()
		
	# Following two inputs need to be fixed because they screw up alot of stuff with the view window
	if Input.is_action_just_pressed("wheel up"):
		camera.zoom += Vector2 (.1,.1)
		
	if Input.is_action_just_pressed("wheel down"):
		camera.zoom -= Vector2 (.1,.1)
		
	# Debug input just to test new features
	if Input.is_action_just_pressed("test debug"):
		open_deck_list()

# Currently makes all "ai" creatures take a turn
func world_turn():
	
	npc_turn()
	beast_turn()
	

func npc_turn():
	var npcs : Array = $NPCs.get_children()
	for npc in npcs:
		npc.move()
		
func beast_turn():
	var beasts : Array = $Beasts.get_children()
	for beast in beasts:
		beast.move()

# Input for clicking on a tile on the map. Opens the inspect window.
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_tile : Vector2i = map.local_to_map(map.get_global_mouse_position())
		
		$InspectWindow.setup_window(clicked_tile)
	

# Test function for player and ai to see if they can move into a space. May be made obsolete when grid pathfinding is introduced.
func is_tile_walkable(coord):
	
	var tile_data : TileData = map.get_cell_tile_data(coord)
	var object_tile_data : TileData = object_map.get_cell_tile_data(coord)
	
	if tile_data.get_custom_data("walkable") == false:
		return false
		
	if object_tile_data != null and object_tile_data.get_custom_data("walkable") == false:
		return false
		
	if Global.occupied_tiles.has(str(coord)):
		return false
		
	
	return true
	
# Function that the interact window calls to split up the interact buttons function.
func object_interact(tile:TileData, coords:Vector2i):
	var type = tile.get_custom_data("type")
	
	match type:
		"door open":
			object_map.set_cell(coords, 5, Vector2i(2,0))
			$InspectWindow.update_window(coords)
			
		"door closed":
			object_map.set_cell(coords, 5, Vector2i(3,0))
			$InspectWindow.update_window(coords)
			
		"chest":
			var contents : Array
			contents = Global.chests[Global.vector_to_string(coords)]["inventory"].duplicate()
			var container = container_scene.instantiate() as Control
			container.position = object_map.map_to_local(coords)
			container.populate_items(contents, coords, map)
			$Containers.add_child(container)
			
		"bed":
			print("this is a bed")
			
func open_deck_list():
	Global.update_deck(Global.player_equip, Global.companion_equip)
	print(Global.deck_list)
	for n in Global.deck_list:
		print(Global.base_weapon_cards[n])
	
