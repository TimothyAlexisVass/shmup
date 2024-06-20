class_name ItemsGrid extends GridContainer

@export_enum("pilot", "player_ship") var item_type: String

@onready var database = G.database(item_type)

const GRID_ITEM_SCENE = preload("res://node_classes/items_grid/grid_item.tscn")

func _ready():
	for int_tier in range(21):
		for item_name in database.tier(int_tier):
			var item = database.data[item_name]
			var item_button = GRID_ITEM_SCENE.instantiate()
			var texture_button = item_button.get_node("PanelContainer/TextureButton")
			var name_label = texture_button.get_node("Name")
			var rarity_label = texture_button.get_node("Rarity")
			name_label.get_theme_stylebox("normal").bg_color = G.RARITY_BACKGROUND_COLOR[item.rarity]
			name_label.get_theme_stylebox("normal").bg_color.a = 0.3
			rarity_label.get_theme_stylebox("normal").bg_color = G.RARITY_BACKGROUND_COLOR[item.rarity]
			rarity_label.get_theme_stylebox("normal").bg_color.a = 0.3
			item_button.get_theme_stylebox("panel").border_color = G.RARITY_BACKGROUND_COLOR[item.rarity] + Color(0.6, 0.6, 0.6)
			texture_button.texture_normal = item.texture
			texture_button.get_node("Name").text = item.name
			texture_button.get_node("Rarity").text = G.RARITY_STARS[item.rarity]
			item_button.name = item.name
			add_child(item_button)
			if item.name in DataManager.player_data["available_" + item_type]:
				texture_button.connect("pressed", Callable(self, "_on_item_button_pressed").bind(item_button))
				texture_button.modulate.a = 0.8
				item_button.get_theme_stylebox("panel").border_color.a = 0.8
				move_child(item_button, 0)
			else:
				texture_button.modulate.a = 0.2
				item_button.get_theme_stylebox("panel").border_color.a = 0.3
			if item.name == DataManager.player_data.get("selected_" + item_type):
				texture_button.modulate.a = 1
				item_button.get_theme_stylebox("panel").border_color.a = 1

func _on_item_button_pressed(selected_button):
	for item_button in get_children():
		var texture_button = item_button.get_node("PanelContainer/TextureButton")
		if item_button.name in DataManager.player_data.get("available_" + item_type):
			texture_button.modulate.a = 0.8
			item_button.get_theme_stylebox("panel").border_color.a = 0.8
		else:
			texture_button.modulate.a = 0.2
			item_button.get_theme_stylebox("panel").border_color.a = 0.3
	selected_button.get_node("PanelContainer/TextureButton").modulate.a = 1
	selected_button.get_theme_stylebox("panel").border_color.a = 1
	DataManager.player_data.set("selected_" + item_type, selected_button.name)
	print("Selecting item ", selected_button.name)
	pass # Replace with function body.
