class_name Game extends Node2D

var player_scene = preload("res://scenes/player.tscn")
var player
var stuff

func _enter_tree():
	Globals.game = self
	Globals.center = get_viewport().size / 2.0
	Globals.play_area = { "min": -Globals.GAME_AREA_OFFSET, "max": Vector2(get_viewport().size) + Globals.GAME_AREA_OFFSET }

func _ready():
	stuff = $Stuff
	DataManager.load_data()
	player = $Spawner.spawn_player_ship($Spawner.player_ships.keys().pick_random())

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func tween_property(object, parameter, final_value, duration):
	if is_instance_valid(object):
		var tween = create_tween()
		if is_instance_valid(object):
			tween.tween_property(object, parameter, final_value, duration)
		else:
			tween.kill()
