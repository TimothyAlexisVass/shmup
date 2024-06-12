extends Node

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

@onready var drop_table = {
	CATEGORY.GENERAL: Stuff.resources + Stuff.items + Stuff.chests,
	CATEGORY.RESOURCE: Stuff.resources,
	CATEGORY.ITEM: Stuff.items,
	CATEGORY.CHEST: Stuff.chests
}
