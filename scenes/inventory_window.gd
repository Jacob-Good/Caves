extends Control

var drag_pos = null

var filled_slots : int = 0

var adj_tiles : Array

var container_coords : Vector2i

var player_inventory = Global.player_inventory

var item_scene: PackedScene = preload("res://scenes/item.tscn")

var is_open : bool = false

func _process(delta):
	
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			$".".visible = false
			is_open = false
		else:
			$".".visible = true
			is_open = true



# Window Dragging Funcionality
func _on_outer_border_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$".".move_to_front()
			drag_pos = get_global_mouse_position() - $".".position
		else:
			drag_pos = null
			
	if event is InputEventMouseMotion and drag_pos:
		$".".set_position(get_global_mouse_position() - drag_pos)

func populate_items():
	var slots : Array = $ItemSlots.get_children()
	filled_slots = player_inventory.size()
	for n in filled_slots:
		slots[n].populate_data(player_inventory[n])
		
func basic_populate_items(contents):
	filled_slots = player_inventory.size()
	var slots : Array = $ItemSlots.get_children()
	var num = 0
	for n in slots:
		print(filled_slots)
		if num < filled_slots:
			n.populate_data(player_inventory[num])
		else:
			n.populate_data(00)
		num += 1


func _on_close_button_button_down() -> void:
	self.visible = false
	is_open = false
	

func _on_item_slots_mouse_entered():
	if Global.dragging_item:
		Global.item_dragged_to = $ItemSlots
		

func _on_item_slots_mouse_exited():
	if Global.dragging_item:
		Global.item_dragged_to = null

func revert_item(target : TextureRect):
	var items = $ItemSlots.get_children()
	var target_item = items.find(target)
	
	var cycles = filled_slots - target_item
	
	for n in cycles:
		items[target_item + n].populate_data(target_item + n + 1)


func _on_inventory_area_area_entered(area):
	if "is_item" in area.get_parent():
		area.get_parent().hovering_over = $ItemSlots

func _on_inventory_area_area_exited(area):
	if "is_item" in area.get_parent():
		area.get_parent().hovering_over = null
		
func update_container_from(target_slot):
	Global.player_inventory.remove_at(target_slot)
	player_inventory = Global.player_inventory
	basic_populate_items(player_inventory)
	
	
func update_container_to(item_id):
	Global.player_inventory.append(item_id)
	print(player_inventory)
	#player_inventory = Global.player_inventory
	basic_populate_items(player_inventory)
