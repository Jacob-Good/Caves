extends TextureRect

@export var data : ItemData


func _ready():
	pass



func _process(delta):
	pass
	
func populate_data(import):
	var item_data = Global.items[import]
	print(item_data["texture"])
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
