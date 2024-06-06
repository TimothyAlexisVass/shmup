class_name PlayerData extends Resource

var name_validator = RegEx.new()

func _enter_tree() -> void:
	# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
	name_validator.compile("^[\\p{L}\\p{M}\\ \\-\\']+$")

var commander = {
	"cannon_level": 1,
	"shot_speed_level": 1,
	"movement_speed_level": 1,
	"fire_power_level": 1,
	"fire_rate_level": 1
}

var pilot = {
	"intelligence": 1,
	"charm": 1,
	"rank": 1
}

var levels = {
	"1": 0
}

var user = {
	"name": ""
}

var config = {
	"time_scale": 1
}

func set_user_name(name: String):
	if name_validator.search(name) != null:
		user.name = name
