class_name Muzzle extends Line2D

@export var shot_scene: PackedScene
@export var hit_effect_scene: PackedScene
@export var rate_of_fire: float = 1.0
@export var shot_speed: float = 200.0

func _ready():
	$Timer.wait_time = 1.0 / rate_of_fire
	width = 0

func _on_timer_timeout():
	var shot = shot_scene.instantiate()
	shot.global_position = global_position
	var line_angle = Globals.ANGLE_LEFT + get_point_position(1).angle_to(get_point_position(0))
	shot.rotation = global_rotation + line_angle
	shot.speed = shot_speed
	shot.get_node("Sprite").modulate = default_color
	Globals.shots_layer.add_child(shot)
