class_name Game extends Node2D

const ANGLE_UP = -1.57079637050629
const ANGLE_DOWN = 1.57079637050629
const GAME_AREA_OFFSET_X = 200
const GAME_AREA_OFFSET_Y = 300

var player_scene = preload("res://scenes/player.tscn")
var player

@onready var area = {
	"x": { "min": - GAME_AREA_OFFSET_X, "max": get_viewport().size.x + GAME_AREA_OFFSET_X},
	"y": { "min": - GAME_AREA_OFFSET_Y, "max": get_viewport().size.y + GAME_AREA_OFFSET_Y}
}

var score = 0:
	set(value):
		score = value
		$UI/HUD.score = score

func _ready():
	score = 0
	player = player_scene.instantiate()
	player.cannon_level = 9
	player.shot_speed_level = 50
	player.movement_speed_level = 0
	player.fire_power_level = 1
	player.fire_rate_level = 80
	player.global_position = $PlayerSpawnPosition.global_position
	add_child(player)

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

static func diminishing(base, level):
	return snapped(base * sqrt(level + 1), 0.01)

static func linear(base, level, magnitude):
	return base + level * magnitude

static func random_boolean():
	return [true, false][randi() % 2]
