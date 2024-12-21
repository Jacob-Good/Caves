extends Control

@onready var portrait_targets : Array = [$Members/Leader,$Members/Member0,$Members/Member1,$Members/Member2]
@onready var player : Node2D = $"../../Player"
var target_portrait : TextureButton

func _ready():
	
	pass
	
	
	
func _process(_delta):
	
	if Input.is_action_just_pressed("hide portraits"):
		
		if $".".visible == true:
			$".".visible = false
		else:
			$".".visible = true



func _on_portrait_mouse_entered():
	
	print("Mouse Detected")
	
	var mousePos = get_viewport().get_mouse_position()
	print(mousePos)
	
	
	for node in portrait_targets:
		if node.get_global_rect().has_point(mousePos):
			target_portrait = node
			break
	
	
	target_portrait.get_child(1).visible = true
	
	


func _on_portrait_mouse_exited():
	
	target_portrait.get_child(1).visible = false


func _on_portrait_area_area_entered(area):
	if 'is_player' in area.get_parent():
		$".".set("modulate", Color(1,1,1,.3))


func _on_portrait_area_area_exited(area):
	if 'is_player' in area.get_parent():
		$".".set("modulate", Color(1,1,1,1))
