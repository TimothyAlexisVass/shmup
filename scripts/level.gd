class_name Level extends Node2D

var number = 1
var challenge = G.CHALLENGE.NONE

var fire_explosion = preload("res://scenes/explosions/fire_explosion.tscn")

func _enter_tree():
	G.level = self
	G.viewport_size = get_viewport().get_visible_rect().size
	G.center = G.viewport_size / 2.0
	G.play_area = { "min": -G.GAME_AREA_OFFSET, "max": Vector2(get_viewport().size) + G.GAME_AREA_OFFSET }
	G.bottom_layer = $ViewLayers/BottomLayer
	G.ships_layer = $ViewLayers/ShipsLayer
	G.player_layer = $ViewLayers/PlayerLayer
	G.top_layer = $ViewLayers/TopLayer
	G.shots_layer = $ViewLayers/ShotsLayer
	G.spawn_manager = $SpawnManager

func _ready():
	G.player = $SpawnManager.spawn_player_ship()

func _physics_process(_delta):
	if Input.is_action_just_pressed("devbomb"):
		for ship in get_tree().get_nodes_in_group("Ships"):
			ship.take_damage(ship.current_health)

func win():
	DataManager.win(number)
	Switch.to_level_selection()
