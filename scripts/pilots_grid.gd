extends ItemList

# var ship_selection_button_scene = preload("res://node_classes/player/ship_selection_button.tscn")

func _ready():
	var index = 0
	for pilot_name in G.pilots_sprites.keys():
		add_item(pilot_name, load(G.pilots_sprites[pilot_name].full_path), pilot_name in DataManager.player_data.available_pilots)
		if pilot_name == DataManager.player_data.selected_pilot:
			select(index)
		index += 1

func _on_item_selected(index):
	DataManager.player_data.selected_pilot = get_item_text(index)
