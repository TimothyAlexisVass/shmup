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
    if rate_1 > rate_2:
        var amount = rate_1 / float(rate_2)
        return [1, int(amount * 0.995), 1, int(amount * 1.005)]
    else:
        var amount = rate_2 / float(rate_1)
        return [int(amount * 1.005), 1, int(amount * 0.995), 1]
