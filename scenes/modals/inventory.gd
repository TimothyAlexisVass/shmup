extends GridContainer

@export_enum("cannon", "device") var item_type: String

const INVENTORY_ITEM_SCENE = preload("res://scenes/modals/inventory_slot.tscn")

var inventory_cannon_details_grid
var inventory_cannon_name

@onready var items = DataManager.player_data.get(item_type)

func _ready():
	for item in items:
		add_inventory_item(items[item])

func add_inventory_item(item_details):
	var inventory_item = INVENTORY_ITEM_SCENE.instantiate()
	var texture_button = inventory_item.get_node("TextureButton")
	texture_button.texture_normal = load("res://media/sprites/cannons/" + item_details.shot_type + ".png")
	
	if texture_button.pressed.is_connected(_on_inventory_item_pressed):
		texture_button.pressed.disconnect(_on_inventory_item_pressed)
	texture_button.pressed.connect(_on_inventory_item_pressed.bind(item_details))
	add_child(inventory_item)

func _on_inventory_item_pressed(item_details):
	inventory_cannon_name.text = item_details.name + " (" + item_details.shot_type + ")"
	for cannon_property in inventory_cannon_details_grid.get_children():
		cannon_property.get_node("label").text = ""
		cannon_property.get_node("value").text = ""
		if item_details:
			var value = item_details.get(cannon_property.name)
			if value is Array or (value && value > 0):
				cannon_property.get_node("label").text = cannon_property.name.replace("_", " ").capitalize()
				cannon_property.get_node("value").text = str(value)
