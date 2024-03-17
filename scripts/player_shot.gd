class_name PlayerShot extends Area2D

var speed
var damage
var acceleration = 0

var hit_effect_scene = preload("res://scenes/laser_explosion.tscn")

@onready var direction = Vector2.UP.rotated(rotation)
@onready var game = get_node('/root/Game')

func _physics_process(delta):
	translate(direction * speed * delta)
	speed += speed * acceleration * delta

func hit(angle):
	var hit_effect = hit_effect_scene.instantiate()
	hit_effect.global_position = self.global_position
	hit_effect.rotation = -angle
	hit_effect.emitting = true
	game.add_child(hit_effect)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
