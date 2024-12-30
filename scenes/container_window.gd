extends Control

var drag_pos = null

var filled_slots : int




# Window Dragging Funcionality
func _on_outer_border_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drag_pos = get_global_mouse_position() - $".".position
		else:
			drag_pos = null
			
	if event is InputEventMouseMotion and drag_pos:
		$".".set_position(get_global_mouse_position() - drag_pos)

func populate_items(contents : Array):
	var slots : Array = $ItemSlots.get_children()
	for n in contents.size():
		slots[n].populate_data(contents[n])
		filled_slots += 1


func _on_close_button_button_down() -> void:
	queue_free()
