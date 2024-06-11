extends Node

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

var resources = []
var items = []
var chests = []

func _enter_tree():
	set_resource_probabilities()
	set_item_probabilities()
	set_chest_probabilities()

var drop_table = {
	CATEGORY.GENERAL: resources + items + chests,
	CATEGORY.RESOURCE: resources,
	CATEGORY.ITEM: items,
	CATEGORY.CHEST: chests
}

func set_resource_probabilities():
	for resource in Exchange.rates.keys():
		resources.append(
			{
				"reward": resource,
				"probability": Exchange.rates["Aluminium"] / Exchange.rates[resource]
			}
		)

func set_item_probabilities():
	pass

func set_chest_probabilities():
	pass
