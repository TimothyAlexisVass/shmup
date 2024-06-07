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

func exchange(from, to, units):
    if from == to:
        return "Can only exchange " + from + " for other types"
    if from in metals and to not in metals:
        return "Can only exchange metals for other metals"
    if from in gems and to in fictional:
        return "Can only exchange gems for metals and other gems"
    if from == "Veritasium" and to == "Eternium":
        return "Can only exchange Veritasium for metals and gems"
    return units * (rates[from] / rates[to]) * 0.995
