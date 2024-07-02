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
	var amount_from = 1
	var amount_to = 1

	if rate_from > rate_to:
		amount_to = rate_from / float(rate_to)
	else:
		amount_from = rate_to / float(rate_from)
	
	return {"from": G.display_weight(-amount_from), "to": G.display_weight(amount_to), "disable": amount_from > DataManager.player_data.asset[from]}
