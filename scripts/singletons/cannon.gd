extends Node

const SHOT_TYPE = ["Plasma", "Bullet"] #, "Missile", "Lazer", "Split", "Rail", "Beam"

const SHOT_SCENE = {
	"Plasma": preload("res://scenes/shots/Plasma.tscn"),
	"Bullet": preload("res://scenes/shots/Bullet.tscn"),
	# "Missile": preload("res://scenes/shots/Missile.tscn"),
	# "Lazer": preload("res://scenes/shots/Lazer.tscn"),
	# "Split": preload("res://scenes/shots/Split.tscn"),
	# "Rail": preload("res://scenes/shots/Rail.tscn"),
	# "Beam": preload("res://scenes/shots/Beam.tscn"),
}

const NAME = {
	"Plasma": ["Plasma Cannon", "Plasma Blaster"],
	"Bullet": ["Ballistic Cannon", "Gun Turret"]
}

const TEXTURE = {
	"Plasma Cannon": preload("res://media/sprites/cannons/Plasma.png"),
	"Plasma Blaster": preload("res://media/sprites/cannons/Plasma.png"),
	"Ballistic Cannon": preload("res://media/sprites/cannons/Ballistic.png"),
	"Gun Turret": preload("res://media/sprites/cannons/Ballistic.png")
}

enum HOMING_PRIORITY {RANDOM, CLOSEST, MOSTHP, LEASTPOWER, MOSTPOWER, LEASTHP}
enum DOT_EFFECT {NONE, RADIATION, BURN}

func from_data(data: Dictionary):
	var cannon = CannonDetails.new()

	cannon.name = data["name"]
	cannon.level = data["level"]
	cannon.rarity = data["rarity"]
	cannon.shot_type = data["shot_type"]
	cannon.texture_name = data["texture_name"]
	cannon.texture = TEXTURE[cannon.name]
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

func generate_reward(rarity):
	var shot_type = SHOT_TYPE.pick_random()
	var cannon_name = NAME[shot_type].pick_random()
	return {
		"rarity": rarity,
		"shot_type": shot_type,
		"name": cannon_name,
		"texture": TEXTURE[cannon_name]
	}

func generate_rewards(tier, rolls, drop_chance, multi_drop_factor, requesting_object):
	var roll_value = randf()
	for rarity_probability in G.RARITY_PROBABILITY:
		if roll_value <= rarity_probability.probability * G.tier_rarity_multiplier(PlayerShip.data[DataManager.player_data.selected_player_ship].tier * 0.5 + Pilot.data[DataManager.player_data.selected_pilot].tier * 0.5 + tier) * DataManager.player_data.commander.luck_multiplier:
			rolls -= 1
			if randf() < drop_chance:
				requesting_object.rewards.append(generate_reward(rarity_probability.rarity))
			if rolls > 0:
				drop_chance *= multi_drop_factor
			else:
				break
