extends Sprite2D

var hue = 0.0
@onready var parent = get_parent()
@onready var rarity_glow = parent.get_node("ShipBody/RarityGlow")
@onready var off_screen_indicator = parent.get_node("OffScreenIndicator")

func _physics_process(delta):
	rotation -= delta * 2
	hue += delta * 0.5 # Adjust increment value for speed
	hue = fmod(hue, 1.0)  # Wrap hue around 0.0 to 1.0
	var color_from_hsv = Color.from_hsv(hue, 1.0, 3.0)
	self_modulate = color_from_hsv
	self_modulate.a = 0.1
	rarity_glow.modulate = color_from_hsv
	off_screen_indicator.modulate = color_from_hsv
