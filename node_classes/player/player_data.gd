class_name PlayerData extends Resource

var name_validator = RegEx.new()

func _enter_tree() -> void:
	# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
	name_validator.compile("^[\\p{L}\\p{M}\\ \\-\\']+$")

var overall = {
	"cannon_level": 6,
	"shot_speed_level": 10,
	"movement_speed_level": 0,
	"fire_power_level": 0,
	"fire_rate_level": 5
}

var levels = {
	1: 10,
	2: 9,
	3: 8,
	4: 7,
	5: 6,
	6: 5,
	7: 4,
	8: 3,
	9: 2,
	10: 1,
	11: 0
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
