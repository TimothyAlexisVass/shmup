class_name Globals extends Node

const ANGLE_UP = -1.57079637050629
const ANGLE_DOWN = 1.57079637050629
const GAME_AREA_OFFSET = Vector2(400, 200)

static var stuff
static var center
static var play_area

static var player

static var explosion_scenes = {
	"fire_explosion": preload("res://scenes/fire_explosion.tscn"),
	"electric_explosion": preload("res://scenes/electric_explosion.tscn")
}

static func explode(object):
	var explosion_scale = max(object.width, object.height) / 200.0
	var explosion = explosion_scenes[object.explosion_type].instantiate()
	explosion.global_position = object.global_position
	for particle in explosion.get_children():
		particle.get_process_material().scale_min *= explosion_scale
		particle.get_process_material().scale_max *= explosion_scale
		particle.emitting = true
	stuff.add_child(explosion)

static func diminishing(base, level):
	return snapped(base * sqrt(level + 1), 0.01)

static func linear(base, level, magnitude):
	return base + level * magnitude

static func random_boolean():
	return [true, false][randi() % 2]
