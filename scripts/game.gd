class_name Game extends Node2D

func _enter_tree():
	G.game = self
	G.center = get_viewport().size / 2.0
	G.play_area = { "min": -G.GAME_AREA_OFFSET, "max": Vector2(get_viewport().size) + G.GAME_AREA_OFFSET }

func _ready():
	G.stuff = $Stuff
	G.player_stuff = $Stuff/PlayerStuff
	G.ships_layer = $Stuff/TopLayer/Ships
	G.shots_layer = $Stuff/TopLayer/Shots
	G.viewport_size = get_viewport().get_size()
	DataManager.load_data()
	G.player = $Spawner.spawn_player_ship($Spawner.player_ships.keys().pick_random())

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
