extends ItemList

func _ready():
	for pilot in Stuff.pilots:
		add_item(pilot.name, pilot.texture, pilot.name in DataManager.player_data.available_pilots)
		move_item(item_count - 1, 0)
		if pilot.name == DataManager.player_data.selected_pilot:
			select(0)

func _on_item_selected(index):
	DataManager.player_data.selected_pilot = get_item_text(index)
