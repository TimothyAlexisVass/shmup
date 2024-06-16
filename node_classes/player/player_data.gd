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
	"fire_rate_level": 1,
	"magnet_strength": 10
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

var selected_player_ship = "Justice":
	set(value):
		selected_player_ship = value
		DataManager.save_data()

var selected_pilot = "Lance":
	set(value):
		selected_pilot = value
		DataManager.save_data()

var available_player_ships = ["Blade", "Justice"]

var available_pilots = Stuff.PILOT.keys()

var levels = {
	"1": 10,
	"2": 9,
	"3": 8,
	"4": 7,
	"5": 6,
	"6": 5,
	"7": 4,
	"8": 3,
	"9": 2,
	"10": 1,
	"11": 0
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
