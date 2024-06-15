extends Node

enum CATEGORY {resources, pilots, player_ships}

enum PILOT {Xurim, Mia, Lance}

enum PLAYER_SHIP {Excalibur, Justice, Blade}
func selected_ship_name():
	return PLAYER_SHIP.keys()[DataManager.player_data.selected_ship]

var pilots: Array
var player_ships: Array

enum RESOURCE {Eternium, Veritasium, Smaragdus, Rubinus, Sapphirus, Rhodium, Aurum, Argentum, Cuprum, Aluminium}
var resources: Array
var items: Array
var chests: Array


func _enter_tree():
	set_pilots_array()
	set_player_ships_array()
	set_resources_array()

func by_probability_ascending(a, b):
	return a["probability"] < b["probability"]

func set_pilots_array():
	var pilot_tiers = {
		"Xurim": 1.0,
		"Mia": 0.01,
		"Lance": 0.0
	}
	for pilot_name in PILOT:
		var base_tier = pilot_tiers[pilot_name]
		pilots.append(
			{
				"category": CATEGORY.pilots,
				"name": pilot_name,
				"tier": int(base_tier),
				"texture": load("res://assets/sprites/pilots/" + pilot_name + ".png"),
				"probability": 1.4 ** -base_tier
			}
		)

func set_player_ships_array():
	var player_ship_tiers = {
		"Excalibur": 1.0,
		"Justice": 0.01,
		"Blade": 0.0
	}
	for player_ship_name in PLAYER_SHIP:
		var base_tier = player_ship_tiers[player_ship_name]
		player_ships.append(
			{
				"category": CATEGORY.player_ships,
				"name": player_ship_name,
				"tier": int(base_tier),
				"texture": load("res://assets/sprites/player_ships/" + player_ship_name + ".png"),
				"probability": 1.4 ** -base_tier
			}
		)

func set_resources_array():
	var resource_tiers = [20, 18, 16, 14, 12, 10, 7, 4, 2, 1]
	for index in range(len(resource_tiers)):
		var resource_name = RESOURCE.keys()[index]
		resources.append(
			{
				"category": CATEGORY.resources,
				"name": resource_name,
				"tier": resource_tiers[index],
				"texture": load("res://assets/sprites/resources/" + resource_name + ".png"),
				"probability": Exchange.rates["Aluminium"] / Exchange.rates[resource_name]
			}
		)
