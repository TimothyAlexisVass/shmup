extends Node

var player_data = PlayerData.new()

func change(category, item_name, amount):
	player_data[category][item_name] += amount
	save_data()

func level_up(category, stat):
	change(category, stat, 1)

func level_down(category, stat):
	change(category, stat, -1)

func win(level):
	var level_key = str(level)
	var next_level_key = str(level + 1)
	player_data.levels[level_key] = min(10, player_data.levels[level_key] + 1)
	if not player_data.levels.has(next_level_key):
		player_data.levels[next_level_key] = 0
	save_data()

func save_data():
	var _data_to_save = {
		"commander": player_data.commander,
		"player_ship": player_data.player_ship,
		"pilot": player_data.pilot,
		"asset": player_data.asset,
		"levels": player_data.levels,
		"selected_pilot": player_data.selected_pilot,
		"selected_player_ship": player_data.selected_player_ship
	}

func handle_loaded_data(loaded_data):
	if loaded_data.has("commander"):
		player_data.commander = loaded_data.commander
	if loaded_data.has("player_ship"):
		player_data.player_ship = loaded_data.player_ship
	if loaded_data.has("levels"):
		player_data.levels = loaded_data.levels
	if loaded_data.has("asset"):
		player_data.asset = loaded_data.asset
	if loaded_data.has("selected_pilot"):
		player_data.selected_pilot = loaded_data.selected_pilot
	if loaded_data.has("selected_player_ship"):
		player_data.selected_player_ship = loaded_data.selected_player_ship
