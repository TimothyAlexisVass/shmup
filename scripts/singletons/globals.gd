extends Node2D

const DEBUG = false

enum COLLISION_LAYERS { PLAYER=1, NONPLAYER=2, PLAYERSTUFF=3, NONPLAYERSTUFF=4 }
enum CHALLENGE { NONE, EASY, MEDIUM, ELITE, APEX }
enum RARITY { COMMON=0, NOTABLE=1, RARE=2, EPIC=3, LEGENDARY=4, SUPREME=5, TRANSCENDENT=9 }
const RARITY_PROBABILITY = [
	{"rarity": RARITY.TRANSCENDENT, "probability": 0.00077},
	{"rarity": RARITY.SUPREME, "probability": 0.0018},
	{"rarity": RARITY.LEGENDARY, "probability": 0.005},
	{"rarity": RARITY.EPIC, "probability": 0.017},
	{"rarity": RARITY.RARE, "probability": 0.05},
	{"rarity": RARITY.NOTABLE, "probability": 0.2},
	{"rarity": RARITY.COMMON, "probability": 1}
]

func tier_rarity_multiplier(tier):
	return 0.4 + 0.1 * tier

const ANGLE_UP = -PI/2
const ANGLE_RIGHT = 0
const ANGLE_DOWN = PI/2
const ANGLE_LEFT = PI
const GAME_AREA_OFFSET = Vector2(400, 200)
const HEALTH_TWEEN_TIME = 0.4
const RARITY_COLOR = {
	RARITY.COMMON: Color(0, 0, 0, 0.6),
	RARITY.NOTABLE: Color(0.8, 1.7, 3.2, 0.6),
	RARITY.RARE: Color(2.7, 0.8, 2.7, 0.6),
	RARITY.EPIC: Color(2.7, 0.5, 0.8, 0.6),
	RARITY.LEGENDARY: Color(2.7, 1.7, 0.8, 0.6),
	RARITY.SUPREME: Color(2.7, 2.7, 0.8, 0.6),
	RARITY.TRANSCENDENT: Color(1.5, 1.5, 1.5, 0.6)
}
const RARITY_BACKGROUND_COLOR = {
	RARITY.COMMON: Color(0.4, 0.4, 0.4),
	RARITY.NOTABLE: Color(0, 0, 1),
	RARITY.RARE: Color(1, 0, 1),
	RARITY.EPIC: Color(1, 0, 0),
	RARITY.LEGENDARY: Color(1, 0.5, 0),
	RARITY.SUPREME: Color(1, 1, 0),
	RARITY.TRANSCENDENT: Color(1, 1, 1)
}

const DEG_10 = 0.17453292519943
const DEG_15 = 0.26179938779915
const DEG_20 = 0.34906585039887
const DEG_45 = 0.78539816339745
const DEG_60 = 1.0471975511966
const DEG_120 = 2.0943951023932
const DEG_360 = 6.28318530717959

# Active instances
@onready var root = get_tree().root
@onready var shmup = root.get_node("Shmup")
var level
var spawn_manager
var camera
var player
var modals
var market
var popup_overlay

# Viewport and play area
var viewport_size
var center
var play_area
var touching = 0

# Layers
var view_layers
var bottom_layer # For visual effects
var player_layer # For player ships and stuff
var ships_layer # For non-player ships
var top_layer # For powerups and important things
var shots_layer # For shots

const RARITY_STARS = {
	RARITY.COMMON: "⭐", # 🟤
	RARITY.NOTABLE: "⭐⭐", # 🔵
	RARITY.RARE: "⭐⭐⭐", # 🟣
	RARITY.EPIC: "⭐⭐⭐⭐", # 🔴
	RARITY.LEGENDARY: "⭐⭐⭐⭐⭐", # 🟠
	RARITY.SUPREME: "⭐⭐⭐⭐⭐⭐", # 🟡
	RARITY.TRANSCENDENT: "⭐⭐⭐⭐⭐⭐⭐"  # ⚪
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
	elif base is Array:
		for index in range(base.size()):
			base.set(index, snapped(base[index] / sqrt(skill_level / float(dampening_factor) + 1), 0.01))
		return base

func diminishing_increase(base, skill_level, dampening_factor = 1):
	if base is float:
		return snapped(base * sqrt(skill_level / float(dampening_factor) + 1), 0.01)
	elif base is Array:
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

func rotate_towards_target(object_to_rotate, target, rotation_speed, sprite_angle = G.ANGLE_UP):
	var target_angle = sprite_angle + object_to_rotate.global_position.angle_to_point(target)
	object_to_rotate.rotation = lerp_angle(object_to_rotate.rotation, target_angle, rotation_speed)

func humanize(text: String) -> String:
	return text.to_snake_case().replace("_", " ").capitalize()

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
	if abs(value) < 1:
		suffix = " mg"
		value *= 1000
	elif abs(value) >= 1_000 and abs(value) < 1_000_000:
		suffix = " kg"
		value /= 1_000
	elif abs(value) >= 1_000_000:
		suffix = " t"
		value /= 1_000_000
	return str(G.smart_snap(value) if smart_snapped else value) + suffix

func sum(array: Array):
	return float(array.reduce(func(accum, number): return accum + number, 0))

func average(array: Array):
	return sum(array) / float(array.size())

func clear_nodes_from(parent):
	if parent.get_child_count() < 1: return
	for node in parent.get_children():
		node.queue_free()

# Experience and rank functionality
const INITIAL_EXPERIENCE = 500
const EXPERIENCE_INCREASE_FACTOR = 1.155

func experience_required_for(rank):
	return ceil(INITIAL_EXPERIENCE * ((EXPERIENCE_INCREASE_FACTOR**rank - 1) / (EXPERIENCE_INCREASE_FACTOR - 1)))

func rank_from_experience(experience):
	return floor(log(((experience * (EXPERIENCE_INCREASE_FACTOR - 1)) + INITIAL_EXPERIENCE) / INITIAL_EXPERIENCE) / log(EXPERIENCE_INCREASE_FACTOR))
