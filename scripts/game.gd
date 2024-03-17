class_name Game extends Node2D

var player_scene = preload("res://scenes/player.tscn")
var player

var score := 0:
	set(value):
		score = value
		$UI/HUD.score = score

func _ready():
	score = 0
	player = player_scene.instantiate()
	player.cannon_level = 2
	player.shot_speed_level = 30
	player.fire_power_level = 1
	player.fire_rate_level = 50
	player.global_position = $PlayerSpawnPosition.global_position
	add_child(player)

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if is_instance_valid(player):
		$Stuff.global_position.x = -(player.global_position.x - 555)/2
		$Stuff.global_position.y = -(player.global_position.y - 1111)/3

static func diminishing(base, level):
	return snapped(base * sqrt(level + 1), 0.01)
