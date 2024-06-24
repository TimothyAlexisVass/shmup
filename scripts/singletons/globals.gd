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
	5: Color(2.7, 2.7, 0.8, 0.6),
	9: Color(1.5, 1.5, 1.5, 0.6)
}
const RARITY_BACKGROUND_COLOR = {
	0: Color(0.4, 0.4, 0.4),
	1: Color(0, 0, 1),
	2: Color(1, 0, 1),
	3: Color(1, 0, 0),
	4: Color(1, 0.5, 0),
	5: Color(1, 1, 0),
	9: Color(1, 1, 1)
}
enum COLLISION_LAYERS { PLAYER=1, NONPLAYER=2, PLAYERSTUFF=3, NONPLAYERSTUFF=4 }
enum CHALLENGE { NONE, EASY, MEDIUM, ELITE, APEX }

# Active instances
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

const RARITY_STARS = {
	0: "⭐", # 🟤
	1: "⭐⭐", # 🔵
	2: "⭐⭐⭐", # 🟣
	3: "⭐⭐⭐⭐", # 🔴
	4: "⭐⭐⭐⭐⭐", # 🟠
	5: "⭐⭐⭐⭐⭐⭐", # 🟡
	9: "⭐⭐⭐⭐⭐⭐⭐"  # ⚪
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

func diminishing_decrease(base, skill_level, dampening_factor = 1):
	if base is float:
		return snapped(base / sqrt(skill_level / float(dampening_factor) + 1), 0.01)
	elif base is PackedFloat32Array:
		for index in range(base.size()):
			base.set(index, snapped(base[index] / sqrt(skill_level / float(dampening_factor) + 1), 0.01))
		return base

func diminishing_increase(base, skill_level, dampening_factor = 1):
	if base is float:
		return snapped(base * sqrt(skill_level / float(dampening_factor) + 1), 0.01)
	elif base is PackedFloat32Array:
		for index in range(base.size()):
			base.set(index, snapped(base[index] * sqrt(skill_level / float(dampening_factor) + 1), 0.01))
		return base

func linear_increase(base, maximum, skill_level, maximum_skill_level):
	return base + skill_level * (maximum - base) / float(maximum_skill_level)

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

func rarity(int_tier):
	return int(int_tier/3.5) if int_tier < 20 else 9

func probability(int_tier):
	return 1.55**-int_tier

func database(category):
	return get_tree().root.get_node(category.to_pascal_case())

func display_weight(value, smart_snapped = true):
	var suffix = " g"
	if value < 1:
		suffix = " mg"
		value *= 1000
	elif value >= 1_000 and value < 1_000_000:
		suffix = " kg"
		value /= 1_000
	elif value >= 1_000_000:
		suffix = " t"
		value /= 1_000_000
	return str(G.smart_snap(value) if smart_snapped else value) + suffix
