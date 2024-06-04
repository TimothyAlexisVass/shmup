class_name G extends Node2D

const DEBUG = true

const ANGLE_UP = -PI/2
const ANGLE_RIGHT = 0
const ANGLE_DOWN = PI/2
const ANGLE_LEFT = PI
const GAME_AREA_OFFSET = Vector2(400, 200)
const HEALTH_TWEEN_TIME = 0.4
const TIER_COLOR = {
	0: Color(0, 0, 0, 0.2),
	1: Color(0.8, 1.7, 3.2, 0.2),
	2: Color(2.7, 0.8, 2.7, 0.2),
	3: Color(2.7, 0.5, 0.8, 0.2),
	4: Color(2.7, 1.7, 0.8, 0.2),
	5: Color(1.7, 2.7, 0.8, 0.2),
	9: Color(1.5, 1.5, 1.5, 0.2)
}
enum COLLISION_LAYERS { PLAYER=1, NONPLAYER=2, PLAYERSTUFF=3, NONPLAYERSTUFF=4 }
enum CHALLENGE { NONE, EASY, MEDIUM, ELITE, APEX }

static var level
static var level_selection
static var spawn_manager
static var stuff
static var center
static var play_area
static var play_area_fourth
static var bottom_layer # For visual effects
static var ships_layer # For non-player ships
static var player_layer # For player ships and stuff
static var top_layer # For powerups and important things
static var shots_layer # For shots and most important things
static var viewport_size

static var camera
static var player

static func explode(object):
	var explosion = object.explosion.instantiate()
	explosion.global_position = object.global_position
	for particle in explosion.get_children():
		particle.get_process_material().scale_min *= object.explosion_scale
		particle.get_process_material().scale_max *= object.explosion_scale
		particle.emitting = true
	bottom_layer.add_child(explosion)

static func glow(color, strength):
	var modulate = Color(1, 1, 1) + color * strength
	modulate.a = 1
	return modulate

static func colored_light(color):
	var max_component = max(color.r, color.g, color.b)
	return color * (1 / max_component) * color * 2.5

static func diminishing_increase(base, skill_level):
	return snapped(base * sqrt(skill_level + 1), 0.01)

static func linear_increase(base, skill_level, magnitude):
	return base + skill_level * magnitude

static func random_position_in_camera_view():
	var camera_min = camera.get_min()
	var camera_max = camera.get_max()
	return Vector2(randf_range(camera_min.x, camera_max.x), randf_range(camera_min.y, camera_max.y))

static func random_boolean():
	return [true, false].pick_random()

static func random_sign(number):
	return [-number, number].pick_random()

static func rotate_towards_target(object_to_rotate, target, rotation_speed):
	var target_angle = G.ANGLE_UP + object_to_rotate.global_position.angle_to_point(target)
	object_to_rotate.rotation = lerp_angle(object_to_rotate.rotation, target_angle, rotation_speed)
