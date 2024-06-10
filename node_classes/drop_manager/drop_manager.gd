class_name DropManager extends Node2D

var tier = 1

func _enter_tree():
	if owner and owner.name != "TopLayer":
		owner.connect("drop_reward" if owner.has_signal("drop_reward") else "tree_exiting", drop)

func drop(recipient, at_global_position):
	print("drop for: ", recipient, " on layer ", get_parent().name, " at ", at_global_position)
	queue_free()
