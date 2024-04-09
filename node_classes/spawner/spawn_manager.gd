class_name SpawnManager extends Node2D

var player_ship_scene = preload("res://node_classes/player/player.tscn")

var level_completed = false
var wave = 0

var ships = {
	1: {
		"VashPurpura": preload("res://scenes/ships/VashPurpura.tscn")
	},
	2: {
		"SabreTight": preload("res://scenes/ships/SabreTight.tscn")
	}
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

var spawner_scene = preload("res://node_classes/spawner/spawner.tscn")
var spawners = {}

@onready var ships_left_for_next_wave = Spawn.ships_left_for_next_wave(G.game.level)[G.game.challenge]
@onready var max_spawn_point = Spawn.max_spawn_point(G.game.level)
@onready var waves = Spawn.WAVE_LEVEL[G.game.level]
@onready var number_of_waves = waves.size()

func _enter_tree():
	var spawn_points = {
		-5: Vector2(G.play_area.min.x, G.play_area.max.y - G.play_area_fourth.y),
		-4: Vector2(G.play_area.min.x, G.center.y),
		-3: Vector2(G.play_area.min.x, G.play_area.min.y + G.play_area_fourth.y),
		-2: Vector2(G.play_area.min.x, G.play_area.min.y),
		-1: Vector2(G.play_area.min.x + G.play_area_fourth.x, G.play_area.min.y),
		0: Vector2(G.center.x, G.play_area.min.y),
		1: Vector2(G.play_area.max.x - G.play_area_fourth.x, G.play_area.min.y),
		2: Vector2(G.play_area.max.x, G.play_area.min.y),
		3: Vector2(G.play_area.max.x, G.play_area.min.y + G.play_area_fourth.y),
		4: Vector2(G.play_area.max.x, G.center.y),
		5: Vector2(G.play_area.max.x, G.play_area.max.y - G.play_area_fourth.y),
	}
	for key in spawn_points:
		spawners[key] = spawner_scene.instantiate()
		spawners[key].global_position = spawn_points[key]
		add_child(spawners[key])

func _ready():
	for player_ship in player_ships:
		player_ships[player_ship]["texture"] = load("res://assets/sprites/player_ships/" + player_ship + ".png")

func spawn(wave_number):
	var wave_level = waves[wave_number]
	var wave_type = Spawn.wave_type()
	var wave_modification = Spawn.wave_modification()
	var wave_max_spawn_point = max_spawn_point[wave_level]
	var spawn_at_points = Spawn.at_points(wave_max_spawn_point, wave_type, wave_modification)
	
	prints("Wave:", wave, "level of wave:", wave_level, "spawning at points:", spawn_at_points, "max spawn point:", wave_max_spawn_point, "wave_type:", Spawn.WAVE_TYPE.keys()[wave_type-1], "modification:", Spawn.WAVE_MODIFICATION.keys()[wave_modification-1])
	match wave_type:
		Spawn.WAVE_TYPE.MIRROR:
			for spawn_point in spawn_at_points:
				for spawner in [spawners[-spawn_point], spawners[spawn_point]]:
					spawners[spawn_point].spawn(ships[wave_level].values().pick_random(), Spawn.spawn_amount(wave_level))
					if spawn_point == 0:
						break
		Spawn.WAVE_TYPE.ALTERNATE:
			for spawn_point in spawn_at_points:
				spawners[spawn_point].spawn(ships[wave_level].values().pick_random(), Spawn.spawn_amount(wave_level))
		Spawn.WAVE_TYPE.FLOW:
			for spawn_point in spawn_at_points:
				spawners[spawn_point].spawn(ships[wave_level].values().pick_random(), Spawn.spawn_amount(wave_level))

func spawn_player_ship(player_ship_type):
	get_viewport().warp_mouse(Vector2(540, 1540))
	var player_ship = player_ship_scene.instantiate()
	player_ship.initialize(player_ships[player_ship_type], DataManager.player_data.levels)
	G.game.add_child(player_ship)
	return player_ship

func _on_wave_timer_timeout():
	if level_completed:
		$WaveTimer.stop()
		G.game.win()
	elif wave < number_of_waves:
		if get_tree().get_nodes_in_group("Ships").size() <= ships_left_for_next_wave:
			spawn(wave)
			wave += 1
