extends GridContainer

@export_enum("cannon", "device") var item_type: String

const INVENTORY_ITEM_SCENE = preload("res://scenes/modals/inventory_slot.tscn")

@onready var items = DataManager.player_data.get(item_type)

func _ready():
	for item in items:
		add_inventory_item(items[item])

func add_inventory_item(item):
	var inventory_item = INVENTORY_ITEM_SCENE.instantiate()
	var texture_node = inventory_item.get_node("Texture")
	texture_node.texture = load("res://media/sprites/cannons/" + item.shot_type + ".png")
	add_child(inventory_item)
