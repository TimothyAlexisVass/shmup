class_name PlayerShot extends Area2D

var speed
var damage
var acceleration = 0

@onready var direction = Vector2.UP.rotated(rotation)

func _physics_process(delta):
	translate(direction * speed * delta)
	speed += speed * acceleration * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
