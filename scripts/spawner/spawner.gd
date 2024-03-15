class_name Spawner extends Node

var ship_scene = preload("res://scenes/ship.tscn")

@onready var game = get_node('/root/Game')

var ships = {
	"buff": {
		"texture": preload("res://assets/sprites/spaceShips_001.png"),
		"total_hit_points": 10,
		"speed": 150,
		"points": 100
	},
	"brawler": {
		"texture": preload("res://assets/sprites/spaceShips_002.png"),
		"total_hit_points": 2,
		"speed": 800,
		"points": 600
	},
	"gigant": {
		"texture": preload("res://assets/sprites/spaceShips_003.png"),
		"total_hit_points": 50,
		"speed": 50,
		"points": 800
	},
	"diver": {
		"texture": preload("res://assets/sprites/spaceShips_004.png"),
		"total_hit_points": 5,
		"speed": 350,
		"points": 200
	},
	"technoid": {
		"texture": preload("res://assets/sprites/spaceShips_007.png"),
		"total_hit_points": 20,
		"speed": 100,
		"points": 400
	}
}

func _ready():
	pass

func spawn(ship_type):
	var ship = ship_scene.instantiate()
	ship.initialize(ships[ship_type])
	ship.global_position = Vector2(randf_range(50, get_viewport().size.x - 50), -50)
	game.add_child(ship)

func _on_ship_spawn_timer_timeout():
	spawn(ships.keys().pick_random())
