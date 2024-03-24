class_name Spawner extends Node

var ship_scene = preload("res://scenes/ship.tscn")
var player_ship_scene = preload("res://scenes/player.tscn")

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

var player_ships = {
	"playerShip1_blue": {
		"shot_speed_base": 400,
		"movement_speed_base": 800,
		"fire_power_base": 1,
		"fire_rate_base": 1,
		"shot_color": Color(1, 1.5, 8),
		"shot_type": "plasma"
	},
	"playerShip2_orange": {
		"shot_speed_base": 600,
		"movement_speed_base": 500,
		"fire_power_base": 2,
		"fire_rate_base": 0.5,
		"shot_color": Color(4, 1.2, 1),
		"shot_type": "plasma"
	},
	"playerShip3_green": {
		"shot_speed_base": 400,
		"movement_speed_base": 500,
		"fire_power_base": 1,
		"fire_rate_base": 1,
		"shot_color": Color(1, 4, 1.2),
		"shot_type": "plasma"
	},
}

func _enter_tree():
	for ship in ships:
		ships[ship]["texture"] = load("res://assets/sprites/ships/" + ship + ".png")
		ships[ship]["collision_shape"] = CollisionShapeGenerator.generate(ships[ship]["texture"].get_image())
	for player_ship in player_ships:
		player_ships[player_ship]["texture"] = load("res://assets/sprites/player_ships/" + player_ship + ".png")
		player_ships[player_ship]["graze_area"] = CollisionShapeGenerator.generate(player_ships[player_ship]["texture"].get_image())

func spawn_ship(ship_type):
	var ship = ship_scene.instantiate()
	ship.initialize(ships[ship_type])
	ship.global_position = Vector2(randf_range(50, get_viewport().size.x), - ship.height)
	ships_layer.add_child(ship)

func spawn_player_ship(player_ship_type):
	var player_ship = player_ship_scene.instantiate()
	player_ship.initialize(player_ships[player_ship_type], DataManager.player_data.levels)
	get_viewport().warp_mouse(Vector2(540, 1340))
	player_ship.global_position = Vector2(670, 1550)
	game.add_child(player_ship)
	return player_ship

func _on_ship_spawn_timer_timeout():
	spawn_ship(ships.keys().pick_random())
