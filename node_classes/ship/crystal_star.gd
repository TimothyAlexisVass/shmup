extends Sprite2D

var hue = 0.0
var parent
var ship_sprite

func _enter_tree():
	parent = get_parent()

func _ready():
	ship_sprite = parent.get_node("ShipBody/Sprite")

func _physics_process(delta):
	rotation -= delta * 2
	hue += delta * 0.5 # Adjust increment value for speed
	hue = fmod(hue, 1.0)  # Wrap hue around 0.0 to 1.0
	var color_from_hsv = Color.from_hsv(hue, 1.0, 2.0)
	self.self_modulate = color_from_hsv
	ship_sprite.material.set_shader_parameter("line_color", color_from_hsv)
