extends Area2D

func _ready():
	$CollisionShape2D.shape.size = Vector2(G.play_area.max.x + 200, G.play_area.max.y + 200)
	global_position = Vector2(G.center.x, G.center.y + 100)

func _on_exited(object):
	if object.owner:
		object = object.owner
	if object.has_meta("instances_owned"):
		for owned_instance in object.get_meta("instances_owned"):
			owned_instance.queue_free()
	object.queue_free()
