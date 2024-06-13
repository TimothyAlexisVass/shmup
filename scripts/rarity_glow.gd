extends Sprite2D

# Parameters
const BASE_SCALE = 1.06
const SCALE_RANGE = 0.05
const OSCILLATION_SPEED = 0.3  # Speed of the oscillation

# Time accumulator
var time = 0.0

var rarity = 0

func _ready():
	self_modulate = G.RARITY_COLOR[rarity]
	modulate = G.RARITY_COLOR[rarity] * 1.3

func _physics_process(delta):
	time += delta * OSCILLATION_SPEED * TAU
	var new_scale = BASE_SCALE + SCALE_RANGE * sin(time)
	scale = Vector2(new_scale, new_scale)
