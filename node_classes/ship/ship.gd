class_name Ship extends Node2D

const PADDING = 10

# Basic properties
@export var speed: float
@export var total_hit_points: float
@export var points: float
@export var explosion: PackedScene
@export var rotation_speed: float = 0.01
@export var acceleration: float = 0.001

enum DESTINATION {RANDOM, FIXED, FACING_DIRECTION}
@export var destination: DESTINATION

@export var fixed_relative_position: Vector2i

enum FACE_TOWARDS {PLAYER, DESTINATION}
@export var face_towards: FACE_TOWARDS

enum MOVE {TO_DESTINATION, AHEAD, STATIONARY}
@export var move: MOVE

# Calculated properties
var width
var height
var direction
var explosion_scale
var target
var velocity = Vector2(0, 0)

@onready var current_health = total_hit_points

func _enter_tree():
	var image_size = Vector2($ShipBody/Sprite.texture.diffuse_texture.get_image().get_size()) * $ShipBody/Sprite.scale
	width = image_size.x
	height = image_size.y
	explosion_scale = (width * scale.x if width > height else height * scale.y) / 300.0
	global_position = Vector2(randi_range(50, G.play_area.max.x), G.play_area.min.y - height)

func _ready():
	$HitPoints.value = current_health
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width / 2 + PADDING
	$HitPoints.position.y = -(height / 2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING * 2
	if destination == DESTINATION.RANDOM:
		target = G.random_position_in_camera_view()
	elif destination == DESTINATION.FIXED:
		target = global_position + Vector2(fixed_relative_position)
	elif destination == DESTINATION.FACING_DIRECTION:
		target = (Vector2.DOWN * 9999).rotated($ShipBody.rotation)

func _process(delta):
	if $HitPoints.value <= 0:
		clear()
	if destination == DESTINATION.RANDOM && ($ShipBody.global_position - target).length() < 100:
		target = G.random_position_in_camera_view()
	if get_node_or_null("ShipBody"):
		if current_health > 0:
			if face_towards == FACE_TOWARDS.DESTINATION:
				G.rotate_towards_target($ShipBody, target, rotation_speed)
			elif face_towards == FACE_TOWARDS.PLAYER && is_instance_valid(G.player) && G.player.is_playing:
				G.rotate_towards_target($ShipBody, G.player.global_position, rotation_speed)

			if move == MOVE.TO_DESTINATION:
				var desired_velocity = (target - global_position).normalized()
				velocity = lerp(velocity, desired_velocity, acceleration)
			elif move == MOVE.AHEAD:
				velocity = Vector2.DOWN.rotated($ShipBody.rotation)
		else:
			velocity *= 0.99
		if velocity != Vector2(0, 0):
			translate(velocity * speed * delta)

func _on_collision(object):
	if object is Player and G.player.is_playing and current_health > 0:
		object.clear()
		take_damage(current_health)

func handle_hit(shot):
	take_damage(shot.source.fire_power)
	if $HitPoints.value > 0:
		shot.hit(self)

func take_damage(amount):
	current_health -= amount
	if not $HitPoints.visible:
		$HitPoints.visible = true

	var tween = create_tween()
	tween.set_parallel()
	if current_health <= 0:
		$ShipBody/Area2D.set_deferred("monitoring", false)
		$ShipBody/Area2D.set_deferred("monitorable", false)
		for jet in $ShipBody/Jets.get_children():
			jet.lifetime = 0.2
			jet.emitting = false
		var muzzles = $ShipBody.get_node_or_null("Muzzles")
		if muzzles:
			muzzles.queue_free()
		tween.tween_property($ShipBody, "modulate", Color(4, 2, 1), 0.4) # shine
	if $HitPoints.value > 0:
		var ratio = $HitPoints.value / $HitPoints.max_value
		var red_component = min(1, 2 * (1 - ratio))
		var green_component = min(1, 2 * ratio)
		$HitPoints.get_theme_stylebox("fill").bg_color = Color(red_component, green_component, 0)
		$HitPoints.modulate = Color(max(1.7, 1.7 + 1 - green_component), 1.7, 1, 1)
		tween.tween_property($HitPoints, "value", current_health, 0.4)

func clear():
	G.explode(self)
	queue_free()
