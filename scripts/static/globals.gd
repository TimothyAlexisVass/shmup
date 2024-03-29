class_name G extends Node

const ANGLE_UP = -PI/2
const ANGLE_RIGHT = 0
const ANGLE_DOWN = PI/2
const ANGLE_LEFT = PI
const GAME_AREA_OFFSET = Vector2(400, 200)

static var game
static var stuff
static var player_stuff
static var ships_layer
static var shots_layer
static var center
static var play_area

static var player

static func explode(object):
	var explosion = object.explosion.instantiate()
	explosion.global_position = object.global_position
	for particle in explosion.get_children():
		particle.get_process_material().scale_min *= object.explosion_scale
		particle.get_process_material().scale_max *= object.explosion_scale
		particle.emitting = true
	stuff.add_child(explosion)

static func diminishing(base, level):
	return snapped(base * sqrt(level + 1), 0.01)

static func linear(base, level, magnitude):
	return base + level * magnitude

static func random_boolean():
	return [true, false].pick_random()

static func random_sign(number):
	return number * [-1, 1].pick_random()
