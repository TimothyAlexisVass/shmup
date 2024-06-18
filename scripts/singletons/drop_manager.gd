extends Node

enum TYPE { GENERAL, RESOURCE, CANNON, DEVICE, CHEST, SPECIAL }

@onready var drop_table = {
	TYPE.GENERAL: Stuff.resources + Stuff.cannons + Stuff.devices + Stuff.chests,
	TYPE.RESOURCE: Stuff.resources,
	TYPE.CANNON: Stuff.cannons,
	TYPE.DEVICE: Stuff.devices,
	TYPE.CHEST: Stuff.chests
}
