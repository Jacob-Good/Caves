extends Node2D

@onready var window_size : Vector2 = DisplayServer.window_get_size()
@onready var map = $Map/Ground
@onready var object_map = $Map/Objects
@onready var camera = $Camera

func _ready():
	$MainMenu.start_flashing()
	
	
	
	
	
	
	
	
func _process(_delta):
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	
	if Input.is_action_just_pressed("space bar") and $MainMenu.flashing:
		$MainMenu.stop_flashing()
		$Map.visible = true
		$Player.visible = true
		
	if Input.is_action_just_pressed("wheel up"):
		camera.zoom += Vector2 (.1,.1)
		
	if Input.is_action_just_pressed("wheel down"):
		camera.zoom -= Vector2 (.1,.1)

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

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_tile = map.local_to_map(map.get_global_mouse_position())
		
		print("mouse Click - NPC Caught @ " + str(clicked_tile) )
