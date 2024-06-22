extends Node

var shot_types = ["Plasma", "Bullet", "Missile", "Lazer", "Split", "Rail", "Beam"]
var shot_patterns = {
	"Single": [1], # 1/s
	"Double": [1, 0.5], # 1.333/s
	"Triple": [1, 0.5, 0.5], # 1.5/s
	"DoubleDouble": [1, 0.2, 0.6, 0.2], # 2/s
	"MultiShot": null,
	"Random": null
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

const SHOT_RATE = {
	"Plasma": [1, 2],
	"Bullet": [0.5, 1],
	"Missile": [2, 5],
	"Split": [1, 2],
	"Lazer": [0.5, 2],
	"Rail": [2, 3],
	"Beam": [5]
}

const SHOT_SPEED = {
	"Plasma": [500, 700],
	"Bullet": [900, 1100],
	"Missile": [200, 400],
	"Split": [400, 600],
	"Lazer": null,
	"Rail": null,
	"Beam": null
}

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
	"Plasma": null,
	"Bullet": null,
	"Missile": [3, 10],
	"Split": [0.3, 1],
	"Lazer": [0.2, 1],
	"Rail": null,
	"Beam": [1, 5]
}

const DEG_10 = 0.17453292519943
const DEG_15 = 0.26179938779915
const DEG_20 = 0.34906585039887
const DEG_45 = 0.78539816339745
const DEG_60 = 1.0471975511966
const DEG_120 = 2.0943951023932
const DEG_360 = 6.28318530717959

func shot_spread(shot_type, shot_pattern):
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
	"Plasma": null,
	"Bullet": null,
	"Missile": [DEG_10, DEG_360],
	"Split": [DEG_10, DEG_120],
	"Lazer": null,
	"Rail": null,
	"Beam": null
}

const HOMING_PRIORITY = ["Closest", "Least_HP", "Most_HP", "Choice"]

const PENETRATION_CHANCE = { # penetration_count = 1 if penetration_chance > 0 else 0
	"Plasma": null,
	"Bullet": null,
	"Missile": null,
	"Split": [0, 1],
	"Lazer": [0, 1],
	"Rail": [0.5, 1],
	"Beam": [0, 1]
}

const RICOCHET_COUNT = {
	"Plasma": null,
	"Bullet": [0, 1],
	"Missile": null,
	"Split": [0, 1],
	"Lazer": [0, 1],
	"Rail": null,
	"Beam": null
}

const FALLOF_RATE = {
	"Plasma": null,
	"Bullet": [0.1, 0.9],
	"Missile": null,
	"Split": [0],
	"Lazer": [0.2, 0.8],
	"Rail": [0, 0.5],
	"Beam": [0, 0.8]
}

func area_of_impact(shot_type):
	return 200 if shot_type == "Missile" else null

func critical_chance(shot_type):
	return snapped(randf_range(0, 5), 0.1) if shot_type != "Beam" else null

func critical_multiplier(shot_type):
	return snapped(randf_range(1.1, 2), 0.1) if shot_type != "Beam" else null

func dot_effect(shot_type):
	if shot_type in ["Bullet", "Missile"]:
		return [null, null, null, null, null, null, "Radiation", "Burn"].pick_random()
	elif shot_type == "Plasma":
		return [null, null, null, "Burn"].pick_random()
	return null

func dot_duration(dot_effect):
	if dot_effect == "Burn":
		return 5
	elif dot_effect == "Radiation":
		return 1
	return null
