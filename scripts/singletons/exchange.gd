extends Node

const metal = ["Aluminium", "Cuprum", "Argentum", "Aurum", "Rhodium"]
const gem = ["Sapphirus", "Rubinus", "Smaragdus"]
const fictional = ["Veritasium", "Eternium"]

var all = metal + gem + fictional

var rates = {}

func exchange_rates(from, to):
	if (from in metal and to not in metal) or (from in gem and to in fictional) or (from == "Veritasium" and to == "Eternium"):
		return null

	var rate_from = rates[from] * DataManager.player_data.commander.exchange_multiplier
	var rate_to = rates[to]

	if rate_from > rate_to:
		return {"from": "-1 g", "to": G.display_weight(rate_from / float(rate_to))}
	else:
		return {"from": G.display_weight(-rate_to / float(rate_from)), "to": "+1 g"}
