extends Control

var drag_pos = null

var filled_slots : int = 0

var adj_tiles : Array

var container_coords : Vector2i

var chest_contents : Array

var item_scene: PackedScene = preload("res://scenes/item.tscn")

func _process(delta):
	
	if adj_tiles.has(Global.player_coords) != true:
		queue_free()



# Window Dragging Funcionality
func _on_outer_border_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			move_container_to_front()
			drag_pos = get_global_mouse_position() - $".".position
		else:
			drag_pos = null
			
	if event is InputEventMouseMotion and drag_pos:
		$".".set_position(get_global_mouse_position() - drag_pos)

func populate_items(contents : Array, coords : Vector2i, map : TileMapLayer):
	chest_contents = contents
	adj_tiles = Global.get_all_surrounding_cells(coords, map)
	container_coords = coords
	var slots : Array = $ItemSlots.get_children()
	filled_slots = contents.size()
	for n in filled_slots:
		slots[n].populate_data(contents[n])
		
func basic_populate_items(contents):
	filled_slots = contents.size()
	var slots : Array = $ItemSlots.get_children()
	var num = 0
	for n in slots:
		print("basic populate items func" + str(filled_slots))
		if num < filled_slots:
			n.populate_data(contents[num])
			print("Populated data for " + str(contents[num]))
		else:
			n.populate_data(00)
			print("Populated null data")
		num += 1


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
		area.get_parent().hovering_over = $"."

func _on_inventory_area_area_exited(area):
	if "is_item" in area.get_parent():
		area.get_parent().hovering_over = null
		
func update_container_from(target_slot):
	Global.chests[Global.vector_to_string(container_coords)]["inventory"].remove_at(target_slot)
	chest_contents = Global.chests[Global.vector_to_string(container_coords)]["inventory"].duplicate()
	basic_populate_items(chest_contents)
	
	
func update_container_to(item_id):
	Global.chests[Global.vector_to_string(container_coords)]["inventory"].append(item_id)
	chest_contents = Global.chests[Global.vector_to_string(container_coords)]["inventory"].duplicate()
	basic_populate_items(chest_contents)
	
func move_container_to_front():
	self.move_to_front()
	$"..".move_to_front()

func shift_container(shift):
	global_position = global_position - shift
