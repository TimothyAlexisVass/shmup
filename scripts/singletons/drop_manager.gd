extends Node

enum TYPE { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

@onready var drop_table = {
	TYPE.GENERAL: Stuff.resources + Stuff.items + Stuff.chests,
	TYPE.RESOURCE: Stuff.resources,
	TYPE.ITEM: Stuff.items,
	TYPE.CHEST: Stuff.chests
}
