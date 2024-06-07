extends Node

const INITIAL = {
	"Rhodium": 151,
	"Sapphirus": 1177,
	"Rubinus": 4777,
	"Smaragdus": 27777,
	"Veritasium": 234567,
	"Eternium": 7777777
}

const metals = ["Aluminium", "Cuprum", "Argentum", "Aurum", "Rhodium"]
const gems = ["Sapphirus", "Rubinus", "Smaragdus"]
const fictional = ["Veritasium", "Eternium"]

var rates = {
	"Aluminium": 0.0026,
	"Cuprum": 0.0103,
	"Argentum": 1.0071,
	"Aurum": 76.3931,
	"Rhodium": 151,
	"Sapphirus": 1177,
	"Rubinus": 4777,
	"Smaragdus": 27777,
	"Veritasium": 234567,
	"Eternium": 7777777
}

func change():
	var market_prices = get_market_prices()
	for metal in market_prices.keys():
		rates[metal] = market_prices[metal]
	for x in INITIAL.keys():
		var factor = (rates[x] - INITIAL[x]) / float(INITIAL[x])
		var random_factor = randf_range(0.95 - factor, 1.05 - factor)
		rates[x] = int(rates[x] * random_factor)
	rates["Rhodium"] = (rates["Rhodium"] + rates["Aurum"] * 2.0) / 2.0

func get_market_prices():
	# TODO: Replace with API data
	return {
		"Aluminium": 0.0026,
		"Cuprum": 0.0103,
		"Argentum": 1.0071,
		"Aurum": 76.3931
	}

func exchange_rates(item_1, item_2):
	var rate_1 = rates[item_1]
	var rate_2 = rates[item_2]
	var lower_rate = min(rate_1, rate_2)
	var higher_rate = max(rate_1, rate_2)
	var lower_item = item_1 if rate_1 == lower_rate else item_2
	var higher_item = item_1 if rate_1 == higher_rate else item_2

	var amount = higher_rate / float(lower_rate)
	var lower_amount = G.smart_snap(amount * 0.98)
	var higher_amount = G.smart_snap(amount * 1.02)

	var one_way_exchange = (lower_item in metals and higher_item not in metals) or (lower_item in gems and higher_item in fictional) or (lower_item == "Veritasium" and higher_item == "Eternium")
	var one_way = ["-1", "+"+str(lower_amount), "0", "0"] if rate_1 > rate_2 else ["0", "0", "+"+str(lower_amount), "-1"]
	var two_way = ["-1", "+"+str(lower_amount), "+1", "-"+str(higher_amount)] if rate_1 > rate_2 else ["-"+str(higher_amount), "+1", "+"+str(lower_amount), "-1"]
	return one_way if one_way_exchange else two_way
