extends Sprite2D

var hue = 0.0
@onready var parent = get_parent()
@onready var tier_glow = parent.get_node("ShipBody/TierGlow")

func _physics_process(delta):
	rotation -= delta * 2
	hue += delta * 0.5 # Adjust increment value for speed
	hue = fmod(hue, 1.0)  # Wrap hue around 0.0 to 1.0
	var color_from_hsv = Color.from_hsv(hue, 1.0, 3.0)
	self_modulate = color_from_hsv
	self_modulate.a = 0.1
	tier_glow.modulate = color_from_hsv
