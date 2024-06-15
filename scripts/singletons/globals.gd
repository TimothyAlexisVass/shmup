extends Node2D

const DEBUG = false

const ANGLE_UP = -PI/2
const ANGLE_RIGHT = 0
const ANGLE_DOWN = PI/2
const ANGLE_LEFT = PI
const GAME_AREA_OFFSET = Vector2(400, 200)
const HEALTH_TWEEN_TIME = 0.4
const RARITY_COLOR = {
	0: Color(0, 0, 0, 0.6),
	1: Color(0.8, 1.7, 3.2, 0.6),
	2: Color(2.7, 0.8, 2.7, 0.6),
	3: Color(2.7, 0.5, 0.8, 0.6),
	4: Color(2.7, 1.7, 0.8, 0.6),
	5: Color(1.7, 2.7, 0.8, 0.6),
	9: Color(1.5, 1.5, 1.5, 0.6)
}
enum COLLISION_LAYERS { PLAYER=1, NONPLAYER=2, PLAYERSTUFF=3, NONPLAYERSTUFF=4 }
enum CHALLENGE { NONE, EASY, MEDIUM, ELITE, APEX }

# Active instances
var level_selection
var modals
var level
var spawn_manager
var camera
var player

# Viewport and play area
var viewport_size
var center
var play_area
var touching = 0

# Layers
var view_layers
var bottom_layer # For visual effects
var ships_layer # For non-player ships
var player_layer # For player ships and stuff
var top_layer # For powerups and important things
var shots_layer # For shots

const RARITY = {
	0: "🟤",
	1: "🔵⭐🔵",
	2: "🟣⭐🟣⭐🟣",
	3: "🔴⭐🔴⭐🔴⭐🔴",
	4: "🟠⭐🟠⭐🟠⭐🟠⭐🟠",
	5: "🟡⭐🟡⭐🟡⭐🟡⭐🟡⭐🟡",
	9: "⚪⭐⚪⭐⚪⭐⚪⭐⚪⭐⚪⭐⚪" 
}

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			touching += 1
		else:
			touching = max(0, touching - 1)

func explode(object):
	var explosion_instance = object.explosion.instantiate()
	explosion_instance.global_position = object.global_position
	for particle in explosion_instance.get_children():
		particle.get_process_material().scale_min *= object.explosion_scale
		particle.get_process_material().scale_max *= object.explosion_scale
		particle.emitting = true
	bottom_layer.add_child(explosion_instance)

func glow(color, strength):
	var new_modulate = Color(1, 1, 1) + color * strength
	new_modulate.a = 1
	return new_modulate

func colored_light(color):
	var max_component = max(color.r, color.g, color.b)
	return color * (1 / max_component) * color * 2.5

func diminishing_increase(base, skill_level):
	return snapped(base * sqrt(skill_level + 1), 0.01)

func linear_increase(base, skill_level, magnitude):
	return base + skill_level * magnitude

func random_position_in_camera_view():
	var camera_min = camera.get_min()
	var camera_max = camera.get_max()
	return Vector2(randf_range(camera_min.x, camera_max.x), randf_range(camera_min.y, camera_max.y))

func random_boolean():
	return [true, false].pick_random()

func random_sign(number):
	return [-number, number].pick_random()

func rotate_towards_target(object_to_rotate, target, rotation_speed):
	var target_angle = G.ANGLE_UP + object_to_rotate.global_position.angle_to_point(target)
	object_to_rotate.rotation = lerp_angle(object_to_rotate.rotation, target_angle, rotation_speed)
	
func smart_snap(value):
	if value < 5:
		return snapped(value, 0.01)
	elif value < 20:
		return snapped(value, 0.1)
	return snapped(value, 1)

func rarity(tier):
	return int(tier/3.5) if tier < 20 else 9
