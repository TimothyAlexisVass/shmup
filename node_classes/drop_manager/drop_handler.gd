class_name DropHandler extends Node2D

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

@export var tier = 1
@export var category: CATEGORY = CATEGORY.GENERAL
@export var rolls_left = 1
@export var drop_radius = 20
@export var drop_chance = 1
@export var multi_drop_factor = 0.5

var rewards_to_drop = []

var drop_table = []

func _enter_tree():
	if owner:
		if get_parent() not in G.view_layers:
			owner.connect("drop_reward" if owner.has_signal("drop_reward") else "tree_exiting", drop)
			if category == CATEGORY.SPECIAL:
				drop_table = G.drop_manager.drop_table[owner.name] + drop_table
	drop_table = G.drop_manager.drop_table[category] + drop_table

func _ready():
	roll()

func roll():
	var main_roll = randf()
	var drop_table = G.drop_manager.drop_table[owner.name]
	for drop in drop_table:
		if rolls_left == 0:
			return
		var current_roll = main_roll * (self.tier / drop.tier)
		if drop.probability > current_roll:
			if rolls_left > 1:
				if randf() < drop_chance:
					rewards_to_drop.append(drop.reward)
					drop_chance *= multi_drop_factor
			else:
				rewards_to_drop.append(drop.reward)
			rolls_left -= 1

func drop(recipient, at_global_position):
	print("drop for: ", recipient, " on layer ", get_parent().name, " at ", at_global_position)
	for reward in rewards_to_drop:
		reward.instantiate()
		reward.recipient = recipient
		reward.global_position = at_global_position + Vector2(randf_range(-drop_radius, drop_radius), randf_range(-drop_radius, drop_radius))
		get_parent().add_child(reward)
	queue_free()
