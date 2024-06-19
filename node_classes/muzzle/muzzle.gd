class_name Muzzle extends Line2D

var shoot_timer = 0
var shot_index = 0
@export var cannon: Cannon = null

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

	if owner is Player:
		G.player_layer.add_child(shot)
	else:
		G.shots_layer.add_child(shot)

func check_cannon():
	if cannon:
		set_physics_process(true)
	else:
		queue_free()
