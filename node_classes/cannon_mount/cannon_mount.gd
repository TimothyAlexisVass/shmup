class_name CannonMount extends Line2D

var shoot_timer = 0
var shot_index = 0
@export var cannon: CannonDetails = null

func _enter_tree():
	owner = get_parent().owner
	width = 0
	set_physics_process(false)
	call_deferred("check_cannon")

func _physics_process(delta):
	shoot_timer += delta
	if shoot_timer >= float(cannon.shot_rate[shot_index]):
		shoot()
		if shot_index < cannon.shot_rate.size() - 1:
			shot_index += 1
		else:
			shot_index = 0
		shoot_timer = 0

func shoot():
	var shot = cannon.shot_scene.instantiate()
	shot.global_position = global_position
	shot.rotation = global_rotation
	shot.speed = cannon.shot_speed
	shot.source = owner
	shot.power = cannon.shot_power
	shot.modulate = cannon.shot_color
	shot.duration = cannon.shot_duration
	shot.homing_amount = cannon.homing_amount
	shot.homing_priority = cannon.homing_priority
	shot.penetration_chance = cannon.penetration_chance
	shot.penetration_count = cannon.penetration_count
	shot.ricochet_count = cannon.ricochet_count
	shot.falloff_rate = cannon.falloff_rate
	shot.area_of_impact = cannon.area_of_impact
	shot.perfect_chance = cannon.perfect_chance
	shot.perfect_multiplier = cannon.perfect_multiplier
	shot.dot_effect = cannon.dot_effect
	shot.dot_duration = cannon.dot_duration

	if owner is Player:
		G.player_layer.add_child(shot)
	else:
		G.shots_layer.add_child(shot)

func check_cannon():
	if not cannon:
		queue_free()
