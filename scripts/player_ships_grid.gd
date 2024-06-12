extends ItemList

func _ready():
	for ship_name in Stuff.PLAYER_SHIP:
		var ship_index = Stuff.PLAYER_SHIP[ship_name]
		add_item(ship_name, Stuff.player_ships[ship_index].texture, ship_name in DataManager.player_data.available_ships)
		move_item(item_count - 1, 0)
		if ship_name == DataManager.player_data.selected_ship:
			select(0)

func _on_item_selected(index):
	DataManager.player_data.selected_ship = get_item_text(index)
