class_name PlayerData extends Resource

var name_validator = RegEx.new()

func _enter_tree():
	# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
	name_validator.compile("^[\\p{L}\\p{M}\\ \\-\\']+$")

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
	"Eternium": 0,
}

var levels = {
	"1": 0
}

var config = {
	"time_scale": 1
}

func set_user_name(name: String):
	if name_validator.search(name) != null:
		commander.name = name
