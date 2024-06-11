extends Node

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

func _enter_tree():
	G.drop_manager = self
