class_name DataManager extends Node


const SAVE_DIR = "user://saves/"
const SAVE_FILE = "save.json"
const SECURITY_KEY = "VERY_SECRET_KEY"

static var player_data = PlayerData.new()

static func save_data():
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	var file = FileAccess.open_encrypted_with_pass(SAVE_DIR + SAVE_FILE, FileAccess.WRITE, SECURITY_KEY)
	if not file:
		printerr(FileAccess.get_open_error())
		return
	
	var data_to_save = {
		"player_levels": player_data.levels
	}
	file.store_string(JSON.stringify(data_to_save, "\t"))
	file.close()

static func load_data():
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
		
		player_data.levels = loaded_data.player_levels
	else:
		printerr("Save file doesn't exist")
