class_name Spawner extends Node

var ship_scene = preload("res://scenes/ship.tscn")

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

func _enter_tree():
	for ship in ships:
		ships[ship]["texture"] = load("res://assets/sprites/" + ship + ".png")
		ships[ship]["collision_shape"] = CollisionShapeGenerator.generate(ships[ship]["texture"].get_image())

func spawn(ship_type):
	var ship = ship_scene.instantiate()
	ship.initialize(ships[ship_type])
	ship.global_position = Vector2(randf_range(50, get_viewport().size.x), -stuff.global_position.y - ship.height)
	ships_layer.add_child(ship)

func _on_ship_spawn_timer_timeout():
	spawn(ships.keys().pick_random())
