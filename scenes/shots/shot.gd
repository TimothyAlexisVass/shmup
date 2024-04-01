extends Area2D

var direction
var speed

func _ready():
	direction = Vector2.UP.rotated(rotation).normalized()

func _physics_process(delta):
	translate(direction * speed * delta)
