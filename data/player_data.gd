class_name PlayerData extends Resource

var name_validator = RegEx.new()

func _enter_tree() -> void:
	# Regular expression pattern to match letters, spaces, hyphens, and apostrophes from various languages
	name_validator.compile("^[\\p{L}\\p{M}\\ \\-\\']+$")

var levels = {
	"cannon_level": 3,
	"shot_speed_level": 0,
	"movement_speed_level": 0,
	"fire_power_level": 0,
	"fire_rate_level": 20
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
