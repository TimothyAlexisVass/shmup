extends ItemList

func _ready():
	for ship in Stuff.player_ships:
		add_item(ship.name, ship.texture, ship.name in DataManager.player_data.available_ships)
		move_item(item_count - 1, 0)
		if ship.name == DataManager.player_data.selected_ship:
			select(0)

func _on_item_selected(index):
	DataManager.player_data.selected_ship = get_item_text(index)
