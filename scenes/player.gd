extends Node2D

@onready var map = $"../Map/Ground"
@onready var object_map = $"../Map/Objects"
@onready var game = $".."
@onready var camera = $"../Camera"

@export var data : PlayerData

var check_north : bool = false

var turn_taken : bool = false

func _ready():
	
	Global.occupied_tiles[str($"../Map/Ground".local_to_map(global_position))] = self
	Global.player_coords = $"../Map/Ground".local_to_map(global_position)

func _process(_delta):
	
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
		
	if Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
		
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
		
	if Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
		
	# Input to move the camera to the players current position.
	if Input.is_action_just_pressed("focus map"):
		
		var shift : Vector2 = camera.position - global_position
		
		var windows : Array = $"../Containers".get_children()
		windows.append($"../InventoryWindow")
		for n in windows:
			n.shift_container(shift)
		
		camera.position = global_position
		
	if turn_taken == true:
		game.world_turn()
		turn_taken = false
		
		
# Called everytime the player inputs a move command
func move(direction : Vector2):
	# Get current map vactor 2i
	var current_tile : Vector2i = map.local_to_map(global_position)
	#get target tile vector 21
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x, current_tile.y + direction.y
	)

	
	if game.is_tile_walkable(target_tile) == false:
		end()
		return
	

	#move player
	global_position = map.map_to_local(target_tile)
	Global.occupied_tiles[str(target_tile)] = self
	Global.player_coords = target_tile
	Global.occupied_tiles.erase(str(current_tile))
	
	
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
	
	var windows = $"../Containers".get_children()
	windows.append($"../InventoryWindow")
	
	if x > .5:
		camera.position.x += window_size.x
		for n in windows:
			n.shift_container(Vector2 (window_size.x * -1, 0))
	if x < -.5:
		camera.position.x -= window_size.x
		for n in windows:
			n.shift_container(Vector2 (window_size.x, 0))
	if y > .5:
		camera.position.y += window_size.y
		for n in windows:
			n.shift_container(Vector2 (0, window_size.y * -1))
	if y < -.5:
		camera.position.y -= window_size.y
		for n in windows:
			n.shift_container(Vector2 (0, window_size.y))
