extends TextureRect

@export var data : ItemData

var base_import_data

var drag_pos = null

var original_position

var original_container

var original_node_slot

var hovering_over

func _ready():
	original_position = position
	original_container = $".."
	original_node_slot = self.get_index()
	print(original_node_slot)


func _process(delta):
	pass
	
func populate_data(import):
	base_import_data = import
	var item_data = Global.items[import]
	if item_data["texture"] == "":
		$".".texture = null
	else:
		$".".texture = ResourceLoader.load(item_data["texture"])
	
	data.name = item_data["name"]
	data.type = item_data["type"]
	data.desc = item_data["desc"]
	data.value = item_data["value"]
	data.weight = item_data["weight"]
	data.damage = item_data["damage"]
	data.defense = item_data["defense"]
	data.range = item_data["range"]
	data.max_dur = item_data["max_dur"]
	data.cur_dur = item_data["cur_dur"]
	if item_data.has("trait_01"):
		data.trait_01 = item_data["trait_01"]
	if item_data.has("trait_02"):
		data.trait_02 = item_data["trait_02"]
	if item_data.has("trait_03"):
		data.trait_03 = item_data["trait_03"]


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"../..".move_to_front()
			self.move_to_front()
			original_position = $".".position
			drag_pos = get_global_mouse_position() - $".".position
			Global.dragging_item = true
		else:
			drag_pos = null
			$"..".move_child(self, original_node_slot)
			if hovering_over == null or hovering_over == original_container:
				self.position = original_position
			else:
				var target_slot = hovering_over.get_child(hovering_over.get_parent().filled_slots)
				print(target_slot)
				target_slot.populate_data(base_import_data)
				$"..".move_child(self, original_node_slot)
				$"../..".update_container_from(original_node_slot)
				target_slot.get_parent().get_parent().update_container_to(base_import_data)
				self.populate_data(00)
				self.position = original_position
				
				
			Global.dragging_item = false
			
	if event is InputEventMouseMotion and drag_pos:
		$".".set_position(get_global_mouse_position() - drag_pos)
		
func is_item():
	pass
