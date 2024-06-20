extends Node

var all = []

var data = {}

func by_probability(a, b):
	return a["probability"] < b["probability"]

func _enter_tree():
	for asset_name in Exchange.all:
		data[asset_name] = {
			"name": asset_name,
			"texture": load("res://media/sprites/assets/" + asset_name + ".png"),
			"probability": Exchange.rates["Aluminium"] / Exchange.rates[asset_name]
		}
		all.append(data[asset_name])
	all.sort_custom(by_probability)
	for item in [[0, 20], [1, 18], [2, 16], [3, 14], [4, 12], [5, 10], [6, 7], [7, 4], [8, 2], [9, 1]]:
		var index = item[0]
		var tier = item[1]
		all[index]["tier"] = tier
		all[index]["rarity"] = G.rarity(tier)

func get_rewards(_tier, _rolls, _multi_drop_factor):
	var rewards = []
	rewards.append(data["Aluminium"])
	return rewards

'''
for drop in drop_table:
	if rolls == 0:
		return
	if roll_value <= drop.probability * self.tier / float(drop.tier):
		var drop_try = randf()
		if drop_try < drop_chance:
			rewards_to_drop.append(drop)
			if rolls > 1:
				drop_chance *= multi_drop_factor
		rolls -= 1
'''
