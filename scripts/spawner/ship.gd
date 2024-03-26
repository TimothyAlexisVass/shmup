class_name Ship extends Node2D

const PADDING = 10

# Basic properties
var speed
var total_hit_points
var points
var texture
var collision_shape
var explosion_type

# Calculated properties
var width
var height
var image
var explosion_scale

@onready var current_health = total_hit_points

func initialize(data):
	for property in data.keys():
		set(property, data[property])

	image = texture.get_image()
	$ShipBody/Sprite.texture = ImageTexture.create_from_image(image)
	width = image.get_size().x
	height = image.get_size().y
	$ShipBody.add_child(collision_shape.duplicate())

func _ready():
	$HitPoints.value = current_health
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width / 2 + PADDING
	$HitPoints.position.y = -(height / 2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING * 2

func _process(_delta):
	if $HitPoints.value <= 0:
		clear()

func _physics_process(delta):
	global_position.y += speed * delta
	if is_instance_valid(Globals.player) && Globals.player.is_playing:
		$ShipBody.rotation = Globals.ANGLE_UP + self.global_position.angle_to_point(Globals.player.global_position)

func _on_collision(object):
	if object is Player:
		object.clear()
		take_damage(current_health)
	if object is Shot and object.source is Player:
		take_damage(object.source.fire_power)
		if $HitPoints.value > 0:
			object.hit(self)

func take_damage(amount):
	current_health -= amount
	if not $HitPoints.visible:
		$HitPoints.visible = true

	var tween = create_tween()
	tween.set_parallel()
	if current_health <= 0:
		# shine
		tween.tween_property($ShipBody, "modulate", Color(4, 2, 1), 0.2)
	if $HitPoints.value > 0:
		var ratio = $HitPoints.value / $HitPoints.max_value
		var red_component = min(1, 2 * (1 - ratio))
		var green_component = min(1, 2 * ratio)
		$HitPoints.get_theme_stylebox("fill").bg_color = Color(red_component, green_component, 0)
		$HitPoints.modulate = Color(max(1.7, 1.7 + 1 - green_component), 1.7, 1, 1)
		tween.tween_property($HitPoints, "value", current_health, 0.2)

func clear():
	Globals.explode(self)
	queue_free()
