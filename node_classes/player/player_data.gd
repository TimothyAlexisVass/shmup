class_name PlayerData extends Resource

# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
var name_validator = RegEx.create_from_string("^[\\p{L}\\p{M}\\ \\-\\']+$")

var commander = {}
var player_ship = {}
var pilot = {}
var asset = {}
var cannon = {}
var device = {}

var selected_player_ship = "Justice":
	set(value):
		selected_player_ship = value
		DataManager.save_data()

var selected_pilot = "Lance":
	set(value):
		selected_pilot = value
		DataManager.save_data()

var levels = {}

var config = {
	"time_scale": 1
}

func set_commander_name(name: String):
	if name_validator.search(name):
		commander.name = name
		DataManager.save_data()

func filter_invalid_characters(name: String) -> String:
	var valid_chars = []
	for character in name:
		if name_validator.search(character):
			valid_chars.append(character)
	return "".join(valid_chars)
