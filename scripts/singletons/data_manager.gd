extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE = "save.json"
const SECURITY_KEY = "VERY_SECRET_KEY"

var player_data = PlayerData.new()

func _enter_tree():
	load_data()

func level_up(stat):
	if player_data.overall.has(stat):
		player_data.overall[stat] += 1
	save_data()

func save_data():
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	var file = FileAccess.open_encrypted_with_pass(SAVE_DIR + SAVE_FILE, FileAccess.WRITE, SECURITY_KEY)
	if not file:
		printerr(FileAccess.get_open_error())
		return
	
	var data_to_save = {
		"overall": player_data.overall,
		"levels": player_data.levels
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

		player_data.overall = loaded_data.overall
		player_data.levels = loaded_data.levels
	else:
		print("Save file doesn't exist")
