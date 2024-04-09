extends Node

var queue = []

func spawn(spawn_scene, amount):
	prints(self.name, "adding", spawn_scene, "amount", amount, "to queue")
	queue.append({"spawn_scene": spawn_scene, "amount": amount})
	$SpawnTimer.start()

func _on_spawn_timer_timeout():
	if queue.size() > 0:
		if queue[0].amount > 0:
			var instance_to_spawn = queue[0].spawn_scene.instantiate()
			instance_to_spawn.global_position = self.global_position
			G.ships_layer.add_child(instance_to_spawn)
			queue[0].amount -= 1
		else:
			queue.pop_front()
	else:
		$SpawnTimer.stop()
