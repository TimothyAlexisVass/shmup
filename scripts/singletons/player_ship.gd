extends Node

var all = []

var tier_0 = ["Justice", "Blade"]
var tier_1 = ["Excalibur"]
var tier_2 = []
var tier_3 = []
var tier_4 = []
var tier_5 = []
var tier_6 = []
var tier_7 = []
var tier_8 = []
var tier_9 = []
var tier_10 = []
var tier_11 = []
var tier_12 = []
var tier_13 = []
var tier_14 = []
var tier_15 = []
var tier_16 = []
var tier_17 = []
var tier_18 = []
var tier_19 = []
var tier_20 = []

var data = {}

func _enter_tree():
	for int_tier in range(21):
		for player_ship_name in tier(int_tier):
			var entry = {
					"name": player_ship_name,
					"tier": int_tier,
					"scene": load("res://scenes/player_ships/" + player_ship_name +  ".tscn"),
					"texture": load("res://media/sprites/player_ships/" + player_ship_name + ".png"),
					"rarity": G.rarity(int_tier)
				}
			data[player_ship_name] = entry
			all.append(data[player_ship_name])

func tier(int_tier):
	return get("tier_" + str(int_tier))
