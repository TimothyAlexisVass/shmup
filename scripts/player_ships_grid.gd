extends ItemList

# var ship_selection_button_scene = preload("res://node_classes/player/ship_selection_button.tscn")

func _ready():
	var index = 0
	for ship_name in G.player_ship_sprites.keys():
		add_item(ship_name, load(G.player_ship_sprites[ship_name].full_path), ship_name in DataManager.player_data.available_ships)
		if ship_name == DataManager.player_data.selected_ship:
			select(index)
		index += 1

func _on_item_selected(index):
	DataManager.player_data.selected_ship = get_item_text(index)
