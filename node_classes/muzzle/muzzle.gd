class_name Muzzle extends Line2D

@export var shot_scene: PackedScene = preload("res://scenes/shots/plasma.tscn")
@export var hit_effect_scene: PackedScene = preload("res://scenes/hit_effects/plasma.tscn")
@export var rate_of_fire: float = 1.0
@export var shot_speed: float = 200.0

@onready var source = get_parent().get_parent()

func _ready():
	$Timer.wait_time = 1.0 / rate_of_fire
	width = 0

func _on_timer_timeout():
	var shot = shot_scene.instantiate()
	shot.global_position = global_position
	var line_angle = get_point_position(1).angle_to(get_point_position(0))
	shot.rotation = global_rotation + line_angle
	shot.speed = shot_speed
	shot.hit_effect_scene = hit_effect_scene
	shot.source = source
	
	shot.modulate = default_color

	if source is Player:
		G.player_stuff.add_child(shot)
	else:
		G.shots_layer.add_child(shot)
