extends Control

var drag_pos = null

var filled_slots : int = 0

var adj_tiles : Array

var container_coords : Vector2i

func _process(delta):
	
	if adj_tiles.has(Global.player_coords) != true:
		queue_free()



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

func populate_items(contents : Array, coords : Vector2i, map : TileMapLayer):
	adj_tiles = Global.get_all_surrounding_cells(coords, map)
	container_coords = coords
	var slots : Array = $ItemSlots.get_children()
	for n in contents.size():
		slots[n].populate_data(contents[n])
		filled_slots += 1


func _on_close_button_button_down() -> void:
	queue_free()
	

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
	Global.chests[Global.vector_to_string(container_coords)]["inventory"].remove_at(target_slot)
	
	
	
func update_container_to(item_id):
	Global.chests[Global.vector_to_string(container_coords)]["inventory"].append(item_id)
