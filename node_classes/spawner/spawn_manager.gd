class_name SpawnManager extends Node2D

var player_ship_scene = preload("res://node_classes/player/player.tscn")

var level_completed = false
var wave = 0

var ships = {
	1: {
		"Vash": preload("res://scenes/ships/1/Vash.tscn"),
		"Vashu": preload("res://scenes/ships/1/Vashu.tscn"),
		"Sabre": preload("res://scenes/ships/1/Sabre.tscn"),
		"Sabran": preload("res://scenes/ships/1/Sabran.tscn"),
	},
	2: {
		"Sabir": preload("res://scenes/ships/2/Sabir.tscn"),
		"Garra": preload("res://scenes/ships/2/Garra.tscn")
	},
	3: {
		
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
var waiting_for = []
var wave_queue = []
var spawn_points

@onready var ships_left_for_next_wave = Spawn.ships_left_for_next_wave(G.level.number)[G.level.challenge]
@onready var max_spawn_point = Spawn.max_spawn_point(G.level.number)
@onready var waves = Spawn.WAVE_TIER[G.level.number]
@onready var number_of_waves = waves.size()

func _enter_tree():
	spawn_points = {
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

func _ready():
	for player_ship in player_ships:
		player_ships[player_ship]["texture"] = load("res://assets/sprites/player_ships/" + player_ship + ".png")

func enqueue_wave(wave_number):
	var wave_tier = waves[wave_number]
	var wave_type = Spawn.wave_type()
	var wave_modification = Spawn.wave_modification()
	var spawn_at_points = Spawn.at_points(max_spawn_point[wave_tier], wave_type, wave_modification)
	var total_amount = Spawn.spawn_amount(wave_tier)
	var amount_per_spawn_point = ceil(total_amount / float(spawn_at_points.size()))

	print("\n--------------------------------------")
	print("Wave: ", wave, " (level ", wave_tier, ")")
	print("Spawning at points: ", spawn_at_points, " - ", Spawn.WAVE_TYPE.keys()[wave_type-1], "/", Spawn.WAVE_MODIFICATION.keys()[wave_modification-1])

	match wave_type:
		Spawn.WAVE_TYPE.MIRROR:
			amount_per_spawn_point = ceil(amount_per_spawn_point / 2.0)
			wave_queue.append({
				"wave_tier": wave_tier,
				"amount": amount_per_spawn_point,
				"sequence": spawn_at_points + Spawn.points_at_opposite_side(spawn_at_points)
			})
		Spawn.WAVE_TYPE.ALTERNATE:
			amount_per_spawn_point = ceil(amount_per_spawn_point / 1.5)
			for sequence in [spawn_at_points, Spawn.points_at_opposite_side(spawn_at_points)]:
				wave_queue.append({
					"wave_tier": wave_tier,
					"amount": amount_per_spawn_point,
					"sequence": sequence
				})
		Spawn.WAVE_TYPE.FLOW:
			for spawn_point in spawn_at_points:
				wave_queue.append({
					"wave_tier": wave_tier,
					"amount": amount_per_spawn_point,
					"sequence": [spawn_point]
				})
	

func spawn_player_ship(player_ship_type):
	get_viewport().warp_mouse(Vector2(540, 1540))
	var player_ship = player_ship_scene.instantiate()
	player_ship.initialize(player_ships[player_ship_type], DataManager.player_data.levels)
	G.level.add_child(player_ship)
	return player_ship

func _on_wave_timer_timeout():
	if level_completed:
		$WaveTimer.stop()
		G.level.win()
	elif wave_queue.size() > 0 and waiting_for.is_empty():
		var spawn = wave_queue.pop_front()
		for spawn_point in spawn.sequence:
			var spawn_scene = ships[spawn.wave_tier].values().pick_random()
			var spawner_instance = spawner_scene.instantiate()
			spawner_instance.global_position = spawn_points[spawn_point]
			add_child(spawner_instance)
			spawner_instance.spawn(spawn_scene, spawn.amount)
			prints("enqueued:", spawn.amount, "at:", spawn_point)
	elif wave < number_of_waves and waiting_for.is_empty():
		if get_tree().get_nodes_in_group("Ships").size() <= ships_left_for_next_wave:
			enqueue_wave(wave)
			wave += 1
	
