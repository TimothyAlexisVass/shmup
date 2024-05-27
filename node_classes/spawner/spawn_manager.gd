class_name SpawnManager extends Node2D

var player_ship_scene = preload("res://node_classes/player/player.tscn")

var level_completed = false
var wave = 0

var ships = {
	1: {
		#"Raketa": preload("res://scenes/ships/Raketa.tscn"),
		#"Vallin": preload("res://scenes/ships/Vallin.tscn"),
		"Vash": preload("res://scenes/ships/Vash.tscn"),
		#"Volyn": preload("res://scenes/ships/Volyn.tscn"),
	},
	2: {
		"Wail": preload("res://scenes/ships/Wail.tscn"),
	},
	3: {
		"Garra": preload("res://scenes/ships/Garra.tscn"),
		"Ranoka": preload("res://scenes/ships/Ranoka.tscn"),
		"Raxes": preload("res://scenes/ships/Raxes.tscn"),
		"Rayaxes": preload("res://scenes/ships/Rayaxes.tscn"),
		"Relay": preload("res://scenes/ships/Relay.tscn"),
		"Rillin": preload("res://scenes/ships/Rillin.tscn"),
		"Rucha": preload("res://scenes/ships/Rucha.tscn"),
		"Rugnor": preload("res://scenes/ships/Rugnor.tscn"),
		"Rugnat": preload("res://scenes/ships/Rugnat.tscn"),
		"Ryvnian": preload("res://scenes/ships/Ryvnian.tscn"),
		"Sectoid": preload("res://scenes/ships/Sectoid.tscn"),
		"Sledge": preload("res://scenes/ships/Sledge.tscn"),
		"Sabir": preload("res://scenes/ships/Sabir.tscn"),
		"Sabre": preload("res://scenes/ships/Sabre.tscn"),
		"Sabran": preload("res://scenes/ships/Sabran.tscn"),
		"Slyce": preload("res://scenes/ships/Slyce.tscn"),
		"Slychar": preload("res://scenes/ships/Slychar.tscn"),
		"Somanda": preload("res://scenes/ships/Somanda.tscn"),
		"Styx": preload("res://scenes/ships/Styx.tscn"),
		"Tamarana": preload("res://scenes/ships/Tamarana.tscn"),
		"Trusha": preload("res://scenes/ships/Trusha.tscn"),
		"Tuur": preload("res://scenes/ships/Tuur.tscn"),
		"Vaboom": preload("res://scenes/ships/Vaboom.tscn"),
		"Varilan": preload("res://scenes/ships/Varilan.tscn"),
		"Vashu": preload("res://scenes/ships/Vashu.tscn"),
		"Velin": preload("res://scenes/ships/Velin.tscn"),
		"Verimus": preload("res://scenes/ships/Verimus.tscn"),
		"Vusion": preload("res://scenes/ships/Vusion.tscn"),
		"Weruna": preload("res://scenes/ships/Weruna.tscn"),
		"Xenor": preload("res://scenes/ships/Xenor.tscn"),
		"Yorran": preload("res://scenes/ships/Yorran.tscn"),
		"Yorria": preload("res://scenes/ships/Yorria.tscn"),
		"Zaryan": preload("res://scenes/ships/Zaryan.tscn"),
		"Zaryshan": preload("res://scenes/ships/Zaryshan.tscn"),
		"Zleukh": preload("res://scenes/ships/Zleukh.tscn"),
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
var spawn_points = {}

@onready var ships_left_for_next_wave = Spawn.ships_left_for_next_wave(G.level.number)[G.level.challenge]
@onready var max_spawn_point = Spawn.max_spawn_point(G.level.number)
@onready var waves = Spawn.WAVE_TIER[G.level.number]
@onready var number_of_waves = waves.size()

func _ready():
	for spawn_point_marker in G.ships_layer.get_node("SpawnPoints").get_children():
		spawn_points[spawn_point_marker.name.to_int()] = spawn_point_marker
	for player_ship in player_ships:
		player_ships[player_ship]["texture"] = load("res://assets/sprites/player_ships/" + player_ship + ".png")

func enqueue_wave(wave_number):
	var wave_tier = waves[wave_number]
	var wave_type = Spawn.wave_type()
	var wave_modification = Spawn.wave_modification()
	var spawn_at_points = Spawn.at_points(max_spawn_point[wave_tier], wave_type, wave_modification)
	var total_amount = Spawn.spawn_amount(wave_tier)
	var amount_per_spawn_point = ceil(total_amount / float(spawn_at_points.size()))

	if G.DEBUG:
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
			spawn_points[spawn_point].add_child(spawner_instance)
			spawner_instance.spawn(spawn_scene, spawn.amount)
			if G.DEBUG:
				prints("enqueued:", spawn.amount, "at:", spawn_point)
	elif wave < number_of_waves and waiting_for.is_empty():
		if get_tree().get_nodes_in_group("Ships").size() <= ships_left_for_next_wave:
			enqueue_wave(wave)
			wave += 1
