extends CanvasLayer

@onready var game = $".."
@onready var map = $"../Map/Ground"
@onready var object_map = $"../Map/Objects"

var tile_data_array : Array
var has_entity : bool
var has_object : bool


var target_coords : Vector2i
var entity : AnimatedSprite2D
var object : TileData
var terrain : TileData
var adj_tiles : Array

var window_open : bool = false

func setup_window(clicked_tile : Vector2i):
	
	update_window(clicked_tile)
	
	display_window(has_entity, has_object)
	
	
func display_window(has_entity, has_object):
	window_open = true
	
	if has_entity == false and has_object == false:
		open_terrain()
		
	$".".visible = true
	
func update_window(coords):
	
	data_from_coord(coords)
	
	if has_entity:
		entity = tile_data_array.pop_front()
		%EntityTexture.texture = ResourceLoader.load(entity.data.portrait_path)
		%EntityName.text = "Name : " + entity.data.name
		if entity.data.interactable:
			%EntityInteract.text = "Can Interact : Yes"
			%EntityInteractButton.disabled = false
		else:
			%EntityInteract.text = "Can Interact : No"
			%EntityInteractButton.disabled = true
		%EntityExists.visible = true
		%NoEntityWindow.visible = false
	else:
		%EntityExists.visible = false
		%NoEntityWindow.visible = true
	
	if has_object:
		object = tile_data_array.pop_front()
		%ObjectTexture.texture = ResourceLoader.load(object.get_custom_data("texture"))
		%ObjectName.text = "Name : " + object.get_custom_data("description")
		if object.get_custom_data("interactable"):
			%ObjectInteract.text = "Can Interact : Yes"
			%ObjectInteractButton.disabled = false
		else:
			%ObjectInteract.text = "Can Interact : No"
			%ObjectInteractButton.disabled = true
	
		%ObjectExists.visible = true
		%NoObjectWindow.visible = false
	
	else:
		%ObjectExists.visible = false
		%NoObjectWindow.visible = true
		
	terrain = tile_data_array.pop_front()
	%TerrainTexture.texture = ResourceLoader.load(terrain.get_custom_data("texture"))
	%TerrainType.text = "Type : " + terrain.get_custom_data("description")
	if terrain.get_custom_data("walkable"):
		%CanTraverse.text = "Can Traverse : Yes"
	else:
		%CanTraverse.text = "Can Traverse : No"

func close_window():
	close_terrain()
	$".".visible = false
	window_open = false
	
func open_terrain():
	%TerrainOpen.visible = false
	%TerrainClose.visible = true
	%TerrainWindow.visible = true
	%TerrainWindow.mouse_filter = Control.MOUSE_FILTER_STOP
	
func close_terrain():
	%TerrainOpen.visible = true
	%TerrainClose.visible = false
	%TerrainWindow.visible = false
	%TerrainWindow.mouse_filter = Control.MOUSE_FILTER_PASS
	
func entity_interact_pushed():
	pass
	
func object_interact_pushed():
	
	if adj_tiles.has(Global.player_coords):
		game.object_interact(object, target_coords)
	else:
		var tween = create_tween()
		tween.tween_property(%NotAdjObj, "modulate", Color (1,1,1,1), 1)
		tween.tween_property(%NotAdjObj, "modulate", Color (1,1,1,0), 1)

func data_from_coord(coord):
	target_coords = coord
	adj_tiles = Global.get_all_surrounding_cells(target_coords, map)
	has_entity = false
	has_object = false
	
	var tile_data : TileData = map.get_cell_tile_data(coord)
	if tile_data != null:
		tile_data_array.append(tile_data)
	
		var object_tile_data : TileData = object_map.get_cell_tile_data(coord)
		if object_tile_data != null:
			tile_data_array.push_front(object_tile_data)
			has_object = true
			
		
		if Global.occupied_tiles.has(str(coord)):
			var clicked_entity = Global.occupied_tiles[str(coord)]
			tile_data_array.push_front(clicked_entity)
			has_entity = true
			
			
	# Dont know if I need this?
	#if tile_data.is_empty():
		#return
