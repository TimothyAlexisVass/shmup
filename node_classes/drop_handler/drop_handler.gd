class_name DropHandler extends Node2D

@export var tier = 1
@export var rolls = 1
@export var drop_radius = 20
@export var drop_chance = 1.0
@export var multi_drop_factor = 0.5
@export_enum("asset", "cannon", "device", "chest", "special") var type: String

var rewards = []

const DROP_ITEM_SCENE = preload("res://node_classes/drop_item/drop_item.tscn")

func _enter_tree():
	if owner:
		if owner.has_meta("instances_owned"):
			owner.set_meta("instances_owned", owner.get_meta("instances_owned") + [self])
		else:
			owner.set_meta("instances_owned", [self])
		if "tier" in owner and owner.tier is int:
			tier = owner.tier
		if not has_reparented():
			_connect_signals()

func _ready():
	if not has_reparented():
		call_deferred("reparent", G.top_layer)
	prepare_rewards()

func prepare_rewards():
	rewards = G.database(type).get_rewards(tier, rolls, multi_drop_factor)

func drop_rewards(recipient, at_global_position):
	for reward in rewards:
		if G.DEBUG:
			print("drop ", reward.name, " for: ", recipient.name, " at: ", at_global_position)
		var reward_instance = DROP_ITEM_SCENE.instantiate()
		reward_instance.get_node("Sprite").texture = reward.texture
		reward_instance.category_name = type
		reward_instance.item_name = reward.name
		reward_instance.tier = reward.tier
		reward_instance.recipient = recipient
		reward_instance.global_position = at_global_position + Vector2(randf_range(-drop_radius, drop_radius), randf_range(-drop_radius, drop_radius))
		G.top_layer.call_deferred("add_child", reward_instance)
	call_deferred("queue_free")

func has_reparented() -> bool:
	return get_parent() in G.view_layers.get_children()

func _connect_signals():
	if owner.has_signal("drop_rewards"):
		if not owner.is_connected("drop_rewards",drop_rewards):
			owner.connect("drop_rewards", drop_rewards)
	else:
		if not owner.is_connected("tree_exiting", drop_rewards):
			owner.connect("tree_exiting", Callable(self, "drop_rewards").bind(null, G.center))
