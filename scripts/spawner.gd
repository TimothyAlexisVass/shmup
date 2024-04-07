extends Node2D

var player_ship_scene = preload("res://node_classes/player/player.tscn")

var spawn_ships = true

var ships = {
	"SabreTight": preload("res://scenes/ships/SabreTight.tscn"),
	"VashPurpura": preload("res://scenes/ships/VashPurpura.tscn")
}

var explosions = {
	"fire_explosion": preload("res://scenes/explosions/fire_explosion.tscn")
}

var normal_maps = {
	"vash": preload("res://assets/sprites/ships/vash/vash_normal.png")
}

var player_ships = {
	"Blade": {
		"normal_map": normal_maps["vash"],
		"shot_speed_base": 900,
		"movement_speed_base": 10,
		"fire_power_base": 1,
		"fire_rate_base": 1,
		"shot_color": Color(0, 0.2, 1),
		"shot_type": 0,
		"explosion": explosions["fire_explosion"]
	}
}

@onready var spawn_points = {
	0: Vector2(G.center.x, G.play_area.min.y),
	1: Vector2(G.play_area.max.x - G.play_area_fourth.x, G.play_area.min.y),
	2: Vector2(G.play_area.max.x, G.play_area.min.y),
	3: Vector2(G.play_area.max.x, G.play_area.min.y + G.play_area_fourth.y),
	4: Vector2(G.play_area.max.x, G.center.y),
	5: Vector2(G.play_area.max.x, G.play_area.max.y - G.play_area_fourth.y),
}

func _ready():
	for player_ship in player_ships:
		player_ships[player_ship]["texture"] = load("res://assets/sprites/player_ships/" + player_ship + ".png")

func spawn_ship(ship_scene, spawn_point = null):
	var ship = ship_scene.instantiate()
	if spawn_point:
		spawn_point.x = G.random_sign(spawn_point.x)
		ship.global_position = spawn_point
	G.ships_layer.add_child(ship)

func spawn_player_ship(player_ship_type):
	get_viewport().warp_mouse(Vector2(540, 1540))
	var player_ship = player_ship_scene.instantiate()
	player_ship.initialize(player_ships[player_ship_type], DataManager.player_data.levels)
	G.game.add_child(player_ship)
	return player_ship

func _on_ship_spawn_timer_timeout():
	if get_tree().get_nodes_in_group("Ships").size() == 0:
		spawn_ship(ships[ships.keys().pick_random()], spawn_points[spawn_points.keys().pick_random()])
