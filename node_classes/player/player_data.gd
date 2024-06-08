class_name PlayerData extends Resource

# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
var name_validator = RegEx.create_from_string("^[\\p{L}\\p{M}\\ \\-\\']+$")

var commander = {
	"name": "",
	"rank": 0,
	"cannon_level": 1,
	"shot_speed_level": 1,
	"movement_speed_level": 1,
	"fire_power_level": 1,
	"fire_rate_level": 1
}

var resources = {
	"Aluminium": 100,
	"Cuprum": 0,
	"Argentum": 0,
	"Aurum": 0,
	"Rhodium": 0,
	"Sapphirus": 0,
	"Rubinus": 0,
	"Smaragdus": 0,
	"Veritasium": 0,
	"Eternium": 1,
}

var selected_ship = "Blade"

var available_ships = ["Blade"]

var levels = {
	"1": 1
}

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
