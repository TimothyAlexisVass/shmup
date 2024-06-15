class_name ItemsGrid extends GridContainer

@export var item_type: String

@onready var list_type = item_type + "s"

var grid_item_scene = preload("res://node_classes/items_grid/grid_item.tscn")

func _ready():
	for item in Stuff.get(list_type):
		var item_button = grid_item_scene.instantiate()
		var texture_button = item_button.get_node("TextureButton")
		texture_button.texture_normal = item.texture
		texture_button.get_node("Name").text = item.name
		texture_button.get_node("Rarity").text = G.RARITY[G.rarity(item.tier)]
		item_button.name = item.name
		add_child(item_button)
		if item.name in DataManager.player_data["available_" + list_type]:
			texture_button.connect("pressed", Callable(self, "_on_item_button_pressed").bind(item_button))
			texture_button.modulate.a = 0.8
			move_child(item_button, 0)
		else:
			texture_button.modulate.a = 0.2
		if item.name == DataManager.player_data.get("selected_" + item_type):
			texture_button.modulate.a = 1

func _on_item_button_pressed(selected_button):
	for item_button in get_children():
		var texture_button = item_button.get_node("TextureButton")
		if item_button.name in DataManager.player_data.get("available_" + list_type):
			texture_button.modulate.a = 0.8
		else:
			texture_button.modulate.a = 0.2
	selected_button.get_node("TextureButton").modulate.a = 1
	DataManager.player_data.set("selected_" + item_type, selected_button.name)
	print("Selecting item ", selected_button.name)
	pass # Replace with function body.
