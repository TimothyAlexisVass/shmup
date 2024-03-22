class_name Game extends Node2D

const ANGLE_UP = -1.57079637050629
const ANGLE_DOWN = 1.57079637050629
const GAME_AREA_OFFSET = Vector2(400, 200)

var player_scene = preload("res://scenes/player.tscn")
var player

@onready var area = {
	"min": -GAME_AREA_OFFSET,
	"max": Vector2(get_viewport().size) + GAME_AREA_OFFSET
}

var score = 0:
	set(value):
		score = value
		$UI/HUD.score = score

func _ready():
	score = 0
	player = $Spawner.spawn_player($Spawner.players.keys().pick_random())

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
