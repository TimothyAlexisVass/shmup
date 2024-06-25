class_name PlayerData extends Resource

# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
var name_validator = RegEx.create_from_string("^[\\p{L}\\p{M}\\ \\-\\']+$")

var commander = {
	"name": "",
	"experience": 0,
	"pilot_ability_multiplier": 1,
	"ship_ability_multiplier": 1,
	"graze_power_multiplier": 1,
	"shot_power_multiplier": 1,
	"device_effect_multiplier": 1,
	"perfect_chance_multiplier": 1,
	"perfect_multiplier": 1,
	"exchange_multiplier": 1,
	"magnet_multiplier": 1,
	"luck_multiplier": 1
	}

var player_ship = {
	"Virtue": {
		"main_shot_rate_level": 5,
		"main_shot_speed_level": 0,
		"main_shot_power_level": 0,
		"movement_speed_level": 0,
		"graze_area_radius_level": 1,
		"cannons": ["Ballistic", "Ballistic"]
	},
	"Justice": {
		"main_shot_rate_level": 5,
		"main_shot_speed_level": 0,
		"main_shot_power_level": 0,
		"movement_speed_level": 0,
		"graze_area_radius_level": 1,
		"cannons": ["Plasma", "Plasma"]
	},
	"Excalibur": {
		"main_shot_rate_level": 5,
		"main_shot_speed_level": 0,
		"main_shot_power_level": 0,
		"movement_speed_level": 0,
		"graze_area_radius_level": 1,
		"cannons": ["Plasma", "Plasma"]
	}
}

var pilot = {
	"Lance": {
		"max_cannons": 3,
		"max_devices": 0,
		"maneuver_level": 1,
		"pilot_ability_level": 1,
		"graze_area_radius_multiplier": 1,
		"graze_power_level": 1,
	},
	"Mia": {
		"max_cannons": 1,
		"max_devices": 0,
		"maneuver_level": 1,
		"pilot_ability_level": 1,
		"graze_area_radius_multiplier": 1,
		"graze_power_level": 1,
	}
}

var asset = {
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
