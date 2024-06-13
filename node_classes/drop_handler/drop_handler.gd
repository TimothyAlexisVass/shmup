class_name DropHandler extends Node2D

enum CATEGORY { GENERAL, RESOURCE, ITEM, CHEST, SPECIAL }

@export var tier = 1
@export var category: CATEGORY = CATEGORY.GENERAL
@export var rolls = 1
@export var drop_radius = 20
@export var drop_chance = 1.0
@export var multi_drop_factor = 0.5

var rewards_to_drop = []
var drop_table = DropManager.drop_table[category]

var drop_item_scene = preload("res://node_classes/drop_item/drop_item.tscn")

func _enter_tree():
	if owner:
		if owner.has_meta("instances_owned"):
			owner.set_meta("instances_owned", owner.get_meta("instances_owned") + [self])
		else:
			owner.set_meta("instances_owned", [self])
		if "tier" in owner and owner.tier is int:
			tier = owner.tier
		if not is_reparented():
			_connect_signals()
			if category == CATEGORY.SPECIAL:
				drop_table = DropManager.drop_table[owner.name]

func _ready():
	if not is_reparented():
		call_deferred("reparent", G.top_layer)
	prepare_rewards()

func prepare_rewards():
	var roll_value = randf()
	for drop in drop_table:
		if rolls == 0:
			return
		if roll_value <= drop.probability * self.tier / float(drop.tier):
			var drop_try = randf()
			if drop_try < drop_chance:
				rewards_to_drop.append(drop)
				if rolls > 1:
					drop_chance *= multi_drop_factor
			rolls -= 1

func drop_rewards(recipient, at_global_position):
	for reward in rewards_to_drop:
		print("drop ", reward.name, " for: ", recipient.name, " at: ", at_global_position)
		var reward_instance = drop_item_scene.instantiate()
		reward_instance.get_node("Sprite").texture = reward.texture
		reward_instance.category = reward.category
		reward_instance.item_name = reward.name
		reward_instance.tier = reward.tier
		reward_instance.global_position = at_global_position + Vector2(randf_range(-drop_radius, drop_radius), randf_range(-drop_radius, drop_radius))
		G.top_layer.call_deferred("add_child", reward_instance)
	call_deferred("queue_free")

func is_reparented() -> bool:
	return get_parent() in G.view_layers.get_children()

func _connect_signals():
	if owner.has_signal("drop_rewards"):
		if not owner.is_connected("drop_rewards",drop_rewards):
			owner.connect("drop_rewards", drop_rewards)
	else:
		if not owner.is_connected("tree_exiting", drop_rewards):
			owner.connect("tree_exiting", Callable(self, "drop_rewards").bind(null, G.center))
