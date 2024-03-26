extends Area2D

func _ready():
	$CollisionShape2D.shape.size = Vector2(Globals.play_area.max.x + 400, Globals.play_area.max.y + 200)
	global_position = Vector2(Globals.center.x, Globals.center.y + 200)

func _on_exited(object):
	if object.get_parent() is Ship:
		object = object.get_parent()
	object.queue_free()
