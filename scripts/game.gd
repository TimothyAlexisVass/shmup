class_name Game extends Node2D

var level = 1
var challenge = G.CHALLENGE.NONE

func _enter_tree():
	G.game = self
	G.center = get_viewport().size / 2.0
	G.play_area = { "min": -G.GAME_AREA_OFFSET, "max": Vector2(get_viewport().size) + G.GAME_AREA_OFFSET }
	G.play_area_fourth = (G.play_area.max - G.play_area.min) / 4.0
	G.bottom_layer = $ViewLayers/BottomLayer
	G.ships_layer = $ViewLayers/ShipsLayer
	G.player_layer = $ViewLayers/PlayerLayer
	G.top_layer = $ViewLayers/TopLayer
	G.shots_layer = $ViewLayers/ShotsLayer
	G.spawn_manager = $SpawnManager

func _ready():
	G.viewport_size = get_viewport().get_size()
	DataManager.load_data()
	G.player = $SpawnManager.spawn_player_ship($SpawnManager.player_ships.keys().pick_random())

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func win():
	print("You win!")
