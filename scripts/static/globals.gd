class_name Globals extends Node

const ANGLE_UP = -1.57079637050629
const ANGLE_DOWN = 1.57079637050629
const GAME_AREA_OFFSET = Vector2(400, 200)

static var center
static var play_area

static func diminishing(base, level):
	return snapped(base * sqrt(level + 1), 0.01)

static func linear(base, level, magnitude):
	return base + level * magnitude

static func random_boolean():
	return [true, false][randi() % 2]
