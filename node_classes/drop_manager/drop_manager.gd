class_name DropManager extends Node

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

const DROP_TABLE = {
	CATEGORY.GENERAL: [
		
	],
	CATEGORY.RESOURCE: [
		
	],
	CATEGORY.ITEM: [
		
	],
	CATEGORY.CHEST: [
		
	]
}

func _enter_tree():
	G.drop_manager = self
