extends Node2D

@onready var map = $"../Map/Ground"
@onready var object_map = $"../Map/Objects"
@onready var game = $".."
@onready var camera = $"../Camera"

@export var player : PlayerData

var check_north : bool = false

var turn_taken : bool = false

func _ready():
	
	Global.occupied_tiles.append($"../Map/Ground".local_to_map(global_position) as Vector2i)
	print(Global.occupied_tiles)

func _process(_delta):
	
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
		
	if Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
		
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
		
	if Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
		
	if Input.is_action_just_pressed("focus map"):
		camera.position = global_position
		
	if turn_taken == true:
		game.world_turn()
		turn_taken = false
		
		
func move(direction : Vector2):
	# Get current map vactor 2i
	var current_tile : Vector2i = map.local_to_map(global_position)
	print(current_tile)
	#get target tile vector 21
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x, current_tile.y + direction.y
	)
	print(target_tile)
	#get custome data layer on tile
	var tile_data : TileData = map.get_cell_tile_data(target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		end()
		return
		
	if Global.occupied_tiles.has(target_tile):
		end()
		return
		
	#move player
	global_position = map.map_to_local(target_tile)
	Global.occupied_tiles.append(target_tile)
	Global.occupied_tiles.remove_at(Global.occupied_tiles.find(current_tile))
	print(Global.occupied_tiles)
	
	
	# Function to set bool that triggers world turn
	end()
	

func end():
	turn_taken = true

func is_player():
	pass


func _on_screen_exited():
	var window_size = DisplayServer.window_get_size()
	var position_difference = global_position - camera.get_screen_center_position()
	var x : float = position_difference.x / window_size.x
	var y : float = position_difference.y / window_size.y
	
	if x > .5:
		camera.position.x += window_size.x
	if x < -.5:
		camera.position.x -= window_size.x
	if y > .5:
		camera.position.y += window_size.y
	if y < -.5:
		camera.position.y -= window_size.y
