class_name Muzzle extends Line2D

var timer

@export var shot_scene: PackedScene = preload("res://scenes/shots/plasma.tscn")
@export var fire_rate: float = 1.0
@export var shot_speed: float = 500.0
@export var fire_power: float = 1.0

func _enter_tree():
	owner = get_parent().owner
	timer = $Timer
	width = 0

func first_shot():
	shoot()
	timer.disconnect("timeout", first_shot)
	timer.connect("timeout", shoot)
	timer.one_shot = false
	timer.start(1.0 / fire_rate)

func shoot():
	var shot = shot_scene.instantiate()
	shot.global_position = global_position
	shot.rotation = global_rotation
	shot.speed = shot_speed
	shot.source = owner
	shot.power = fire_power
	shot.modulate = default_color

	if owner is Player:
		G.player_layer.add_child(shot)
	else:
		G.shots_layer.add_child(shot)
