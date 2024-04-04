class_name G extends Node

const ANGLE_UP = -PI/2
const ANGLE_RIGHT = 0
const ANGLE_DOWN = PI/2
const ANGLE_LEFT = PI
const GAME_AREA_OFFSET = Vector2(400, 200)
enum COLLISION_LAYERS { PLAYER=1, NONPLAYER=2, PLAYERSTUFF=3, NONPLAYERSTUFF=4 }

static var game
static var stuff
static var center
static var play_area
static var ships_layer
static var shots_layer
static var player_stuff
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
	stuff.add_child(explosion)

static func glow(color, strength):
	var modulate = Color(1, 1, 1) + color * strength
	modulate.a = 1
	return modulate

static func colored_light(color):
	var max_component = max(color.r, color.g, color.b)
	return color * (1 / max_component) * color * 2.5

static func diminishing_increase(base, level):
	return snapped(base * sqrt(level + 1), 0.01)

static func linear_increase(base, level, magnitude):
	return base + level * magnitude

static func random_position_in_camera_view():
	var camera_position = camera.global_position
	var min_position = camera_position - center
	var max_position = camera_position + center
	return Vector2(randf_range(min_position.x, max_position.x), randf_range(min_position.y, max_position.y))

static func random_boolean():
	return [true, false].pick_random()

static func random_sign(number):
	return [-number, number].pick_random()

static func rotate_towards_target(object_to_rotate, target, rotation_speed):
	var target_angle = G.ANGLE_UP + object_to_rotate.global_position.angle_to_point(target)
	object_to_rotate.rotation = lerp_angle(object_to_rotate.rotation, target_angle, rotation_speed)
