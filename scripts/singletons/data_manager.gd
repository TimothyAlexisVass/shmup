extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE = "save.json"
const SECURITY_KEY = "VERY_SECRET_KEY"

var player_data = PlayerData.new()

func _enter_tree():
	load_data()

func add(category, item_name, amount):
	player_data[category][item_name] += amount
	save_data()

func change(stat, amount):
	if player_data.commander.has(stat):
		player_data.commander[stat] += amount
		print("Level up: ", stat, " to ", player_data.commander[stat])
		save_data()

func level_up(stat):
	change(stat, 1)

func level_down(stat):
	change(stat, -1)

func win(level):
	var level_key = str(level)
	var next_level_key = str(level + 1)
	player_data.levels[level_key] = min(10, player_data.levels[level_key] + 1)
	if not player_data.levels.has(next_level_key):
		player_data.levels[next_level_key] = 0
	save_data()

func save_data():
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	var file = FileAccess.open_encrypted_with_pass(SAVE_DIR + SAVE_FILE, FileAccess.WRITE, SECURITY_KEY)
	if not file:
		printerr(FileAccess.get_open_error())
		return
	
	var data_to_save = {
		"commander": player_data.commander,
		"resources": player_data.resources,
		"levels": player_data.levels,
		"selected_pilot": player_data.selected_pilot,
		"available_pilots": player_data.available_pilots,
		"selected_ship": player_data.selected_ship,
		"available_ships": player_data.available_ships
	}
	file.store_string(JSON.stringify(data_to_save, "\t"))
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_DIR + SAVE_FILE):
		var file = FileAccess.open_encrypted_with_pass(SAVE_DIR + SAVE_FILE, FileAccess.READ, SECURITY_KEY)
		if not file:
			printerr(FileAccess.get_open_error())
			return

		var content = file.get_as_text()
		file.close()
		
		var loaded_data = JSON.parse_string(content)
		if loaded_data == null:
			printerr("Cannot parse save file as JSON")
			return

		print_debug(loaded_data)

		player_data.commander = loaded_data.commander
		player_data.levels = loaded_data.levels
		player_data.resources = loaded_data.resources
		player_data.selected_pilot = loaded_data.selected_pilot
		player_data.available_pilots = loaded_data.available_pilots
		player_data.selected_ship = loaded_data.selected_ship
		player_data.available_ships = loaded_data.available_ships
	else:
		print("Save file doesn't exist")
