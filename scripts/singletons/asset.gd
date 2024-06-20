extends Node

enum ASSET {Eternium, Veritasium, Smaragdus, Rubinus, Sapphirus, Rhodium, Aurum, Argentum, Cuprum, Aluminium}
var assets: Array

func _enter_tree():
	set_assets_array()

func set_assets_array():
	var asset_tiers = {
		"Eternium": 20,
		"Veritasium": 18,
		"Smaragdus": 16,
		"Rubinus": 14,
		"Sapphirus": 12,
		"Rhodium": 10,
		"Aurum": 7,
		"Argentum": 4,
		"Cuprum": 2,
		"Aluminium": 1
	}
	for asset_name in asset_tiers:
		assets.append(
			{
				"name": asset_name,
				"tier": asset_tiers[asset_name],
				"texture": load("res://assets/sprites/assets/" + asset_name + ".png"),
				"probability": Exchange.rates["Aluminium"] / Exchange.rates[asset_name]
			}
		)


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
