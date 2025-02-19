extends Node

var instance_to_spawn = null
var amount = null
var scene = null
var tier_to_spawn = null

func spawn(scene_to_spawn, amount_to_spawn):
	G.spawn_manager.waiting_for.append(self)
	amount = amount_to_spawn
	scene = scene_to_spawn
	instance_to_spawn = scene_to_spawn.instantiate()
	$SpawnTimer.start(instance_to_spawn.spawn_wait_time)

func _on_spawn_timer_timeout():
	if amount > 0:
		if instance_to_spawn == null:
			instance_to_spawn = scene.instantiate()
		instance_to_spawn.global_position = self.global_position
		instance_to_spawn.tier = self.tier_to_spawn
		var instance_parent = get_parent()
		if instance_to_spawn.move == instance_to_spawn.MOVE.ALONG_PATH:
			var available_paths = get_parent().get_node_or_null("Paths")
			if available_paths:
				instance_parent = available_paths.get_children().pick_random()
			else:
				instance_to_spawn.move = instance_to_spawn.MOVE.RANDOM_DESTINATION
		
		instance_parent.add_child(instance_to_spawn)
		instance_to_spawn = null
		amount -= 1
	else:
		G.spawn_manager.waiting_for.erase(self)
		queue_free()
