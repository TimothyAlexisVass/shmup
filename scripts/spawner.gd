extends Node

var player_ship_scene = preload("res://node_classes/player/player.tscn")

var ships = {
	"spaceShips_001": preload("res://scenes/ships/spaceShips_001.tscn"),
	"spaceShips_002": preload("res://scenes/ships/spaceShips_002.tscn"),
	"spaceShips_003": preload("res://scenes/ships/spaceShips_003.tscn"),
	"spaceShips_004": preload("res://scenes/ships/spaceShips_004.tscn")
}

var explosions = {
	"fire_explosion": preload("res://scenes/explosions/fire_explosion.tscn")
}

var player_ships = {
	"Blues": {
		"shot_speed_base": 900,
		"movement_speed_base": 800,
		"fire_power_base": 1,
		"fire_rate_base": 1,
		"shot_color": Color(1, 1.2, 4),
		"shot_type": 0,
		"explosion": explosions["fire_explosion"]
	},
	"Naranja": {
		"shot_speed_base": 600,
		"movement_speed_base": 500,
		"fire_power_base": 2,
		"fire_rate_base": 0.5,
		"shot_color": Color(4, 1.2, 1),
		"shot_type": 0,
		"explosion": explosions["fire_explosion"]
	},
	"GreenGo": {
		"shot_speed_base": 600,
		"movement_speed_base": 500,
		"fire_power_base": 1,
		"fire_rate_base": 1,
		"shot_color": Color(1, 4, 1.2),
		"shot_type": 0,
		"explosion": explosions["fire_explosion"]
	}
}

func _ready():
	for player_ship in player_ships:
		player_ships[player_ship]["texture"] = load("res://assets/sprites/player_ships/" + player_ship + ".png")
		player_ships[player_ship]["graze_area"] = CollisionShapeGenerator.generate(player_ships[player_ship]["texture"].get_image())
		player_ships[player_ship]["ship_name"] = player_ship

func spawn_ship(ship_scene):
	var ship = ship_scene.instantiate()
	G.ships_layer.add_child(ship)

func spawn_player_ship(player_ship_type):
	var player_ship = player_ship_scene.instantiate()
	player_ship.initialize(player_ships[player_ship_type], DataManager.player_data.levels)
	get_viewport().warp_mouse(Vector2(540, 1540))
	player_ship.global_position = Vector2(620, 1750)
	G.game.add_child(player_ship)
	return player_ship

func _on_ship_spawn_timer_timeout():
	spawn_ship(ships[ships.keys()[3]])
	# spawn_ship(ships[ships.keys().pick_random()])
