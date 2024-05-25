extends Sprite2D

# Parameters
const BASE_SCALE = 1.05
const SCALE_RANGE = 0.05
const OSCILLATION_SPEED = 0.3  # Speed of the oscillation

# Time accumulator
var time = 0.0

func _physics_process(delta):
	time += delta * OSCILLATION_SPEED * TAU
	var new_scale = BASE_SCALE + SCALE_RANGE * sin(time)
	scale = Vector2(new_scale, new_scale)
