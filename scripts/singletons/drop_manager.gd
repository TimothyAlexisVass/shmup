extends Node

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

var resources = []
var items = []
var chests = []

@onready var drop_table = {
	CATEGORY.GENERAL: resources + items + chests,
	CATEGORY.RESOURCE: resources,
	CATEGORY.ITEM: items,
	CATEGORY.CHEST: chests
}

func _enter_tree():
	set_resource_probabilities()
	set_item_probabilities()
	set_chest_probabilities()

func set_resource_probabilities():
	var resource_tiers = [1, 2, 4, 7, 10, 12, 14, 16, 18, 20]
	for resource in Exchange.resources:
		resources.append(
			{
				"tier": resource_tiers[Exchange.resources.find(resource)],
				"reward": resource,
				"probability": Exchange.rates["Aluminium"] / Exchange.rates[resource]
			}
		)

func set_item_probabilities():
	pass

func set_chest_probabilities():
	pass
