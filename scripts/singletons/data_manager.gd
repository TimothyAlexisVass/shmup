extends Node

var player_data = PlayerData.new()

var user_handle = null
var recovery_token = null

const SAVE_FILE_PATH = "user://user_data.save"
const ENCRYPTION_PASSWORD = "your_secure_password_here"

func _enter_tree():
	load_user()

func save_user():
	var file = FileAccess.open_encrypted_with_pass(SAVE_FILE_PATH, FileAccess.WRITE, ENCRYPTION_PASSWORD)
	if file:
		file.store_string(user_handle + "\n" + recovery_token)
		file.close()
	else:
		printerr("Failed to save user data.")

func load_user():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open_encrypted_with_pass(SAVE_FILE_PATH, FileAccess.READ, ENCRYPTION_PASSWORD)
		if file:
			var data = file.get_as_text()
			var lines = data.split("\n")
			user_handle = lines[0].strip_edges()
			recovery_token = lines[1].strip_edges()
			file.close()
		else:
			printerr("Failed to load user data.")
	else:
		printerr("User data file does not exist.")

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
	assert(loaded_data.has("player"))
	if user_handle in [loaded_data.player.user_handle, null] and recovery_token in [loaded_data.player.recovery_token, null]:
		if user_handle == null:
			user_handle = loaded_data.player.user_handle
			recovery_token = loaded_data.player.recovery_token
			save_user()
		player_data.commander = loaded_data.commander
		player_data.player_ship = loaded_data.player_ship
		for player_ship_name in player_data.player_ship:
			var player_ship = player_data.player_ship[player_ship_name]
			for cannon in player_ship.cannons:
				player_ship.cannons[cannon] = Cannon.from_data(player_ship.cannons[cannon])

		player_data.pilot = loaded_data.pilot
		player_data.levels = loaded_data.levels
		player_data.asset = loaded_data.asset
		player_data.selected_pilot = loaded_data.player.selected_pilot
		player_data.selected_player_ship = loaded_data.player.selected_player_ship
		for cannon_id in loaded_data.cannon:
			player_data.cannon[int(cannon_id)] = Cannon.from_data(loaded_data.cannon[cannon_id])

		Exchange.rates = loaded_data.exchange_rates
		Asset.initialize()

func set_assets(assets):
	for asset in assets:
		player_data.asset[asset] = assets[asset]
