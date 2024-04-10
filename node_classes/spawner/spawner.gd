extends Node

var spawn_queue = []

func enqueue_spawn(scene_to_spawn, amount):
	spawn_queue.append({"scene_to_spawn": scene_to_spawn, "amount": amount})
	G.spawn_manager.waiting_for.append(self)

func _on_spawn_timer_timeout():
	if spawn_queue.size() > 0:
		if spawn_queue[0].amount > 0:
			var instance_to_spawn = spawn_queue[0].scene_to_spawn.instantiate()
			instance_to_spawn.global_position = self.global_position
			G.ships_layer.add_child(instance_to_spawn)
			spawn_queue[0].amount -= 1
		else:
			spawn_queue.pop_front()
	else:
		G.spawn_manager.waiting_for.erase(self)
