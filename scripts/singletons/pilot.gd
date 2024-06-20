extends Node

var all = []

var tier_0 = ["Lance", "Mia"]
var tier_1 = ["Xurim"]
var tier_2 = ["Elenya"]
var tier_3 = ["Leonard"]
var tier_4 = ["Adrian"]
var tier_5 = ["Sibba"]
var tier_6 = ["Roshon"]
var tier_7 = ["Auro"]
var tier_8 = ["Gemini"]
var tier_9 = ["Marcus"]
var tier_10 = ["Korina"]
var tier_11 = ["Dez"]
var tier_12 = ["Halcyon"]
var tier_13 = ["Felix"]
var tier_14 = ["Vexar"]
var tier_15 = ["Cy"]
var tier_16 = ["Biana"]
var tier_17 = ["Jaquen"]
var tier_18 = ["Urion"]
var tier_19 = ["Yaspar"]
var tier_20 = ["Imrina"]

var data = {}

func _enter_tree():
	for int_tier in range(21):
		for pilot_name in tier(int_tier):
			var entry = {
					"name": pilot_name,
					"texture": load("res://assets/sprites/pilots/" + pilot_name + ".png"),
					"rarity": G.rarity(int_tier)
				}
			data[pilot_name] = entry
			all.append(data[pilot_name])

func tier(int_tier):
	return get("tier_" + str(int_tier))
