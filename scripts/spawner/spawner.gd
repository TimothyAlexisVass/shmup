class_name Spawner extends Node

var ship_scene = preload("res://scenes/ship.tscn")
var player_scene = preload("res://scenes/player.tscn")

@onready var game = get_node("/root/Game")
@onready var stuff = game.get_node("Stuff")
@onready var ships_layer = stuff.get_node("TopLayer/Ships")

var ships = {
	"spaceShips_001": {
		"total_hit_points": 10,
		"speed": 150,
		"points": 100
	},
	"spaceShips_002": {
		"total_hit_points": 2,
		"speed": 800,
		"points": 600
	},
	"spaceShips_003": {
		"total_hit_points": 50,
		"speed": 50,
		"points": 800
	},
	"spaceShips_004": {
		"total_hit_points": 5,
		"speed": 350,
		"points": 200
	},
	"spaceShips_007": {
		"total_hit_points": 20,
		"speed": 100,
		"points": 400
	}
}

var players = {
	"playerShip1_blue": {
		"projectile_speed_base": 100,
		"movement_speed_base": 2000,
		"fire_power_base": 1,
		"fire_rate_base": 0.5
	},
	"playerShip2_orange": {
		"projectile_speed_base": 200,
		"movement_speed_base": 1000,
		"fire_power_base": 1,
		"fire_rate_base": 0.5
	},
	"playerShip3_green": {
		"projectile_speed_base": 100,
		"movement_speed_base": 1000,
		"fire_power_base": 1,
		"fire_rate_base": 2
	},
}

func _enter_tree():
	for ship in ships:
		ships[ship]["texture"] = load("res://assets/sprites/" + ship + ".png")
		ships[ship]["collision_shape"] = CollisionShapeGenerator.generate(ships[ship]["texture"].get_image())
	for player in players:
		players[player]["texture"] = load("res://assets/sprites/" + player + ".png")
		players[player]["graze_area"] = CollisionShapeGenerator.generate(players[player]["texture"].get_image())

func spawn_ship(ship_type):
	var ship = ship_scene.instantiate()
	ship.initialize(ships[ship_type])
	ship.global_position = Vector2(randf_range(50, get_viewport().size.x), - ship.height)
	ships_layer.add_child(ship)

func spawn_player(player_type):
	var player = player_scene.instantiate()
	player.initialize(players[player_type])
	player.cannon_level = 1
	player.projectile_speed_level = 0
	player.movement_speed_level = 0
	player.fire_power_level = 0
	player.fire_rate_level = 1
	get_viewport().warp_mouse(Vector2(540, 1340))
	player.global_position = Vector2(670, 1550)
	game.add_child(player)

func _on_ship_spawn_timer_timeout():
	spawn_ship(ships.keys().pick_random())
