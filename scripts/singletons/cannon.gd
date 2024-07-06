extends Node

const SHOT_TYPE = ["Plasma", "Bullet"] #, "Missile", "Lazer", "Split", "Rail", "Beam"]

const NAME = {
	"Plasma": ["Plasma Cannon", "Plasma Blaster"],
	"Bullet": ["Ballistic Gun", "Gun Turret"]
}
const TEXTURE_NAME = {
	"Plasma": ["Plasma"],
	"Bullet": ["Ballistic"]
}
const SHOT_SCENE = {
	"Plasma": preload("res://scenes/shots/Plasma.tscn"),
	"Bullet": preload("res://scenes/shots/Bullet.tscn"),
	# "Missile": preload("res://scenes/shots/Missile.tscn"),
	# "Lazer": preload("res://scenes/shots/Lazer.tscn"),
	# "Split": preload("res://scenes/shots/Split.tscn"),
	# "Rail": preload("res://scenes/shots/Rail.tscn"),
	# "Beam": preload("res://scenes/shots/Beam.tscn"),
}

const SHOT_RATE = {
	"Single": [1], # 1/s
	"Double": [1, 0.5], # 1.333/s
	"Triple": [1, 0.5, 0.5], # 1.5/s
	"DoubleDouble": [1, 0.2, 0.6, 0.2], # 2/s
}
func multi_shot(amount):
	var result = [1]
	for i in amount:
		result.append(0.03)
	return result

func random_shot_pattern(): # 2% chance to get > 2/s
	var result = []
	for i in range(randi_range(5, 10)):
		result.append(snapped(randf_range(0.2, 1.26), 0.1))
	return result

const ALL_SHOT_PATTERNS = ["Single", "Double", "Triple", "DoubleDouble", "MultiShot", "Random"]

const SHOT_PATTERN = {
	"Plasma": ALL_SHOT_PATTERNS,
	"Bullet": ALL_SHOT_PATTERNS,
	"Missile": ["Single", "Double", "Random"],
	"Split": ["Single"],
	"Lazer": ALL_SHOT_PATTERNS,
	"Rail": ALL_SHOT_PATTERNS,
	"Beam": ["Single"]
}

const SHOT_RATE_BASE = {
	"Plasma": [1, 2],
	"Bullet": [0.5, 1],
	"Missile": [2, 5],
	"Split": [1, 2],
	"Lazer": [0.5, 2],
	"Rail": [2, 3],
	"Beam": [5, 5]
}

func get_shot_rate(shot_type, shot_pattern_type):
	var shot_rate = []
	if shot_pattern_type == "MultiShot":
		shot_rate = multi_shot(randi_range(2, 4))
	elif shot_pattern_type == "Random":
		shot_rate = random_shot_pattern()
	else:
		shot_rate = SHOT_RATE[shot_pattern_type].duplicate()
	var shot_rate_base = snapped(randf_range(SHOT_RATE_BASE[shot_type][0], SHOT_RATE_BASE[shot_type][1]), 0.05)
	for index in range(shot_rate.size()):
		shot_rate[index] *= shot_rate_base
	return shot_rate

const SHOT_SPEED = {
	"Plasma": [500, 700],
	"Bullet": [900, 1100],
	"Missile": [200, 400],
	"Split": [400, 600],
	"Lazer": [0, 0],
	"Rail": [0, 0],
	"Beam": [0, 0]
}

func get_shot_speed(shot_type):
	return randi_range(SHOT_SPEED[shot_type][0], SHOT_SPEED[shot_type][1])

const SHOT_POWER = {
	"Plasma": 1,
	"Bullet": 0.5,
	"Missile": 0.8,
	"Split": 0.8, # 2x0.5, 3x0.4, 4x0.35, 5x0.32, 6x0.3
	"Lazer": 1.2,
	"Rail": 2,
	"Beam": 0
}

const RAINBOW = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.MEDIUM_TURQUOISE, Color.BLUE, Color.PURPLE]
const MATTE = [Color.BURLYWOOD, Color.PALE_GOLDENROD, Color.KHAKI, Color.OLIVE]
const WHITE = [Color.WHITE]
const SHOT_COLOR = {
	"Plasma": RAINBOW,
	"Bullet": MATTE,
	"Missile": WHITE,
	"Split": MATTE,
	"Lazer": RAINBOW,
	"Rail": RAINBOW + WHITE
}

const SHOT_DURATION = {
	"Plasma": [99, 99],
	"Bullet": [99, 99],
	"Missile": [2, 99],
	"Split": [0.5, 2],
	"Lazer": [0.2, 1],
	"Rail": [99, 99],
	"Beam": [1, 5]
}
func get_shot_duration(shot_type):
	return snapped(randf_range(SHOT_DURATION[shot_type][0], SHOT_DURATION[shot_type][1]), 0.05)

const DEG_10 = 0.17453292519943
const DEG_15 = 0.26179938779915
const DEG_20 = 0.34906585039887
const DEG_45 = 0.78539816339745
const DEG_60 = 1.0471975511966
const DEG_120 = 2.0943951023932
const DEG_360 = 6.28318530717959

func get_shot_spread(shot_type, shot_pattern):
	var min_spread = 0
	var max_spread = 0
	if shot_pattern in ["MultiShot", "Random"] || shot_type == "Missile":
		min_spread = DEG_20
		max_spread = DEG_60
	if shot_type == "Bullet":
		max_spread = DEG_15
	if shot_type == "Lazer":
		min_spread = DEG_10
		max_spread = DEG_45
	return snapped(randf_range(min_spread, max_spread), 0.1)

const HOMING_AMOUNT = {
	"Plasma": [0, 0],
	"Bullet": [0, 0],
	"Missile": [DEG_10, DEG_360],
	"Split": [DEG_10, DEG_120],
	"Lazer": [0, 0],
	"Rail": [0, 0],
	"Beam": [0, 0]
}
func get_homing_amount(shot_type):
	return snapped(randf_range(HOMING_AMOUNT[shot_type][0], HOMING_AMOUNT[shot_type][1]), 0.05)

enum HOMING_PRIORITY {RANDOM, CLOSEST, MOSTHP, LEASTPOWER, MOSTPOWER, LEASTHP}

const PENETRATION_CHANCE = { # penetration_count = 1 if penetration_chance > 0 else 0
	"Plasma": [0, 0],
	"Bullet": [0, 0],
	"Missile": [0, 0],
	"Split": [0, 1],
	"Lazer": [0, 1],
	"Rail": [0.5, 1],
	"Beam": [0, 1]
}
func get_penetration_chance(shot_type):
	return snapped(randf_range(PENETRATION_CHANCE[shot_type][0], PENETRATION_CHANCE[shot_type][1]), 0.05)

const RICOCHET_COUNT = {
	"Plasma": [0],
	"Bullet": [0, 1],
	"Missile": [0],
	"Split": [0, 1],
	"Lazer": [0, 1],
	"Rail": [0],
	"Beam": [0]
}

const FALLOF_RATE = {
	"Plasma": [0, 0],
	"Bullet": [0.1, 0.9],
	"Missile": [0, 0],
	"Split": [0],
	"Lazer": [0.2, 0.8],
	"Rail": [0, 0.5],
	"Beam": [0, 0.8]
}
func get_fallof_rate(shot_type):
	return snapped(randf_range(FALLOF_RATE[shot_type][0], FALLOF_RATE[shot_type][1]), 0.05)

func get_area_of_impact(shot_type):
	return randi_range(0, 200) if shot_type == "Missile" else 0

func get_perfect_chance(shot_type):
	return snapped(randf_range(0, 1), 0.001) if shot_type != "Beam" else 0

func get_perfect_multiplier(shot_type):
	return snapped(randf_range(1.1, 2), 0.01) if shot_type != "Beam" else 0

enum DOT_EFFECT {NONE, RADIATION, BURN}

func get_dot_effect(shot_type):
	if shot_type in ["Bullet", "Missile"]:
		var dot_effect_chance = 2/7.0
		return [DOT_EFFECT.RADIATION, DOT_EFFECT.BURN].pick_random() if randf() < dot_effect_chance else DOT_EFFECT.NONE
	elif shot_type == "Plasma":
		var dot_effect_chance = 1/4.0
		return DOT_EFFECT.BURN if randf() < dot_effect_chance else DOT_EFFECT.NONE
	return DOT_EFFECT.NONE

func get_dot_duration(dot_effect):
	if dot_effect == DOT_EFFECT.RADIATION:
		return snapped(randf_range(1, 3), 0.02)
	elif dot_effect == DOT_EFFECT.BURN:
		return randi_range(2, 5)
	return 0

func generate(rarity):
	var shot_type = SHOT_TYPE.pick_random()
	var cannon = CannonDetails.new()
	var shot_pattern_type = SHOT_PATTERN[shot_type].pick_random()
	
	cannon.name = NAME[shot_type].pick_random()
	cannon.rarity = rarity
	cannon.shot_type = shot_type
	cannon.shot_scene = SHOT_SCENE[shot_type]
	cannon.shot_rate = []
	for value in get_shot_rate(shot_type, shot_pattern_type):
		cannon.shot_rate.append(snapped(value, 0.01))
	cannon.texture_name = TEXTURE_NAME[shot_type].pick_random()
	cannon.texture = load("res://media/sprites/cannons/" + cannon.texture_name + ".png")
	cannon.shot_speed = get_shot_speed(shot_type)
	cannon.shot_power = SHOT_POWER[shot_type]
	cannon.shot_color = SHOT_COLOR[shot_type].pick_random()
	cannon.shot_duration = get_shot_duration(shot_type)
	cannon.shot_spread = get_shot_spread(shot_type, shot_pattern_type)
	cannon.homing_amount = get_homing_amount(shot_type)
	cannon.homing_priority = randi_range(0, HOMING_PRIORITY.size() - 1)
	cannon.penetration_chance = get_penetration_chance(shot_type)
	cannon.ricochet_count = RICOCHET_COUNT[shot_type].pick_random()
	cannon.falloff_rate = get_fallof_rate(shot_type)
	cannon.area_of_impact = get_area_of_impact(shot_type)
	cannon.perfect_chance = get_perfect_chance(shot_type)
	cannon.perfect_multiplier = get_perfect_multiplier(shot_type)
	cannon.dot_effect = get_dot_effect(shot_type)
	cannon.dot_duration = get_dot_duration(cannon.dot_effect)

	return cannon

func from_data(data: Dictionary):
	var cannon = CannonDetails.new()

	cannon.name = data["name"]
	cannon.level = data["level"]
	cannon.rarity = data["rarity"]
	cannon.shot_type = data["shot_type"]
	cannon.texture_name = data["texture_name"]
	cannon.texture = load("res://media/sprites/cannons/" + cannon.texture_name + ".png")
	cannon.shot_scene = SHOT_SCENE[data["shot_type"]]
	cannon.shot_rate = []
	for value in data["shot_rate"]:
		cannon.shot_rate.append(snapped(value, 0.01))
	cannon.shot_speed = data["shot_speed"]
	cannon.shot_power = data["shot_power"]
	cannon.shot_color = Color.html(data["shot_color"])
	cannon.shot_duration = data["shot_duration"]
	cannon.shot_spread = data["shot_spread"]
	cannon.homing_amount = data["homing_amount"]
	cannon.homing_priority = data["homing_priority"]
	cannon.penetration_chance = data["penetration_chance"]
	cannon.penetration_count = data["penetration_count"]
	cannon.ricochet_count = data["ricochet_count"]
	cannon.falloff_rate = data["falloff_rate"]
	cannon.area_of_impact = data["area_of_impact"]
	cannon.perfect_chance = data["perfect_chance"]
	cannon.perfect_multiplier = data["perfect_multiplier"]
	cannon.dot_effect = data["dot_effect"]
	cannon.dot_duration = data["dot_duration"]

	return cannon

func get_rewards(tier, rolls, drop_chance, multi_drop_factor):
	var rewards = []
	var roll_value = randf()
	for rarity_probability in G.RARITY_PROBABILITY:
		if roll_value <= rarity_probability.probability * G.tier_rarity_multiplier(PlayerShip.data[DataManager.player_data.selected_player_ship].tier * 0.5 + Pilot.data[DataManager.player_data.selected_pilot].tier * 0.5 + tier) * DataManager.player_data.commander.luck_multiplier:
			rolls -= 1
			if randf() < drop_chance:
				rewards.append(generate(rarity_probability.rarity))
			if rolls > 0:
				drop_chance *= multi_drop_factor
			else:
				break
	return rewards
