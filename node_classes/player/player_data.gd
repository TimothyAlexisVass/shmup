class_name PlayerData extends Resource

# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
var name_validator = RegEx.create_from_string("^[\\p{L}\\p{M}\\ \\-\\']+$")

var commander = {
	"name": "",
	"rank": 0, # Used for commander upgrades and experience multiplier
	"pilot_ability_multiplier": 1,
	"ship_ability_multiplier": 1,
	"graze_power_multiplier": 1,
	"fire_power_multiplier": 1,
	"experience_multiplier": 1,
	"exchange_multiplier": 1,
	"magnet_multiplier": 1,
	"luck_multiplier": 1,
}

var ships = {
	"Blade": {
		"main_fire_rate_level": 1,
		"main_shot_speed_level": 1,
		"main_fire_power_level": 1,
		"ship_ability_level": 1,
		"movement_speed_level": 1,
		"graze_area_radius_level": 1
	},
	"Justice": {
		"main_fire_rate_level": 1,
		"main_shot_speed_level": 1,
		"main_fire_power_level": 1,
		"ship_ability_level": 1,
		"movement_speed_level": 1,
		"graze_area_radius_level": 1
	}
}

var pilots = {
	"Lance": {
		"max_cannons": 1,
		"max_slots": 0,
		"maneuver_level": 1,
		"pilot_ability_level": 1,
		"graze_area_radius_multiplier": 1,
		"graze_power_level": 1,
	},
	"Mia": {
		"max_cannons": 0,
		"max_slots": 1,
		"maneuver_level": 1,
		"pilot_ability_level": 1,
		"graze_area_radius_multiplier": 1,
		"graze_power_level": 1,
	}
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
