extends Area2D

var direction
var speed
var t = 0.0

func _ready():
	direction = Vector2.UP.rotated(rotation).normalized()

func _physics_process(delta):
	translate(direction * speed * delta)
