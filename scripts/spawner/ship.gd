class_name Ship extends Node2D

const PADDING = 10

# Basic properties
var speed
var total_hit_points
var points
var texture
var collision_shape

# Calculated properties
var width
var height
var image
var explosion_scale_x
var explosion_scale_y

var explosion_scene = preload("res://scenes/fire_explosion.tscn")

@onready var game = get_node("/root/Game")
@onready var stuff = game.get_node("Stuff")
@onready var player = game.player
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
	$HitPoints.position.x = -width/2 + PADDING
	$HitPoints.position.y = -(height/2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING*2

func _physics_process(delta):
	global_position.y += speed * delta
	if is_instance_valid(player):
		$ShipBody.rotation = Game.ANGLE_UP + self.global_position.angle_to_point(player.global_position)

func _on_collision(object):
	if object is Player:
		object.die()
		die()
	if object is PlayerShot:
		take_damage(object.damage)
		object.hit(self.global_position)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage(amount):
	current_health -= amount
	if $HitPoints.value <= 0:
		die()
	else:
		var ratio = $HitPoints.value / $HitPoints.max_value
		var red_component = min(1, 2 * (1 - ratio))
		var green_component = min(1, 2 * ratio)
		$HitPoints.get_theme_stylebox("fill").bg_color = Color(red_component, green_component, 0)
		$HitPoints.modulate = Color(max(1.7, 1.7 + 1 - green_component), 1.7, 1, 1)

		if not $HitPoints.visible:
			$HitPoints.visible = true

		var tween = get_tree().create_tween()
		tween.tween_property($HitPoints, "value", current_health, 0.2)

func die():
	game.score += points
	var explosion = explosion_scene.instantiate()
	explosion.global_position = self.global_position - stuff.global_position
	for particle in explosion.get_children():
		particle.scale.x = width / 111.1
		particle.scale.y = height / 111.1
		particle.emitting = true
	stuff.add_child(explosion)
	queue_free()
