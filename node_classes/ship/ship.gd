class_name Ship extends Node2D

const PADDING = 10

# Basic properties
@export var sprites : Array[CompressedTexture2D] = []
@export var crystal : CompressedTexture2D
@export var speed: float
@export var total_hit_points: float
@export var points: float
@export var explosion: PackedScene
@export var rotation_speed: float = 0.01
@export var acceleration: float = 0.001
@export var spawn_wait_time: float = 1.0

enum FACE_TOWARDS {PLAYER, DESTINATION}
@export var face_towards: FACE_TOWARDS

enum MOVE {RANDOM_DESTINATION, ALONG_PATH, AHEAD, STATIONARY}
@export var move: MOVE

# Calculated properties
var width
var height
var direction
var explosion_scale
var target
var velocity = Vector2(0, 0)

@onready var current_health = total_hit_points
@onready var muzzles = $ShipBody.get_node_or_null("Muzzles")
@onready var shooting = false

var shipbody_texture = null
var ship_tier = 0

func _enter_tree():
	var ship_value = randi_range(0, 10000)
	if crystal == null:
		ship_value += 1
	
	if ship_value == 0:
		ship_tier = 9
	else:
		if ship_value <= 2 && len(sprites) == 5:
			shipbody_texture = sprites[4]
			ship_tier = 5
		elif ship_value <= 5 && len(sprites) >= 4:
			shipbody_texture = sprites[3]
			ship_tier = 4
		elif ship_value <= 10 && len(sprites) >= 3:
			shipbody_texture = sprites[2]
			ship_tier = 3
		elif ship_value <= 100 && len(sprites) >= 2:
			shipbody_texture = sprites[1]
			ship_tier = 2
		elif ship_value <= 1000 && len(sprites) >= 1:
			shipbody_texture = sprites[0]
			ship_tier = 1

	if ship_tier == 9:
		shipbody_texture = crystal

	scale *= 1 + 0.1 * ship_tier
	total_hit_points *= 1 + ship_tier

	if shipbody_texture != null:
		$ShipBody/Sprite.texture.diffuse_texture = shipbody_texture
		$ShipBody/TierGlow.self_modulate = G.TIER_COLOR[ship_tier]
		$ShipBody/TierGlow.modulate = G.TIER_COLOR[ship_tier] * 1.3
		$OffScreenIndicator.self_modulate = G.TIER_COLOR[ship_tier] * 2
	else:
		$ShipBody/TierGlow.queue_free()
	
	var image_size = Vector2($ShipBody/Sprite.texture.diffuse_texture.get_image().get_size()) * $ShipBody/Sprite.scale
	width = image_size.x
	height = image_size.y
	explosion_scale = (scale.x * width if width > height else scale.y * height) / 300.0

	if ship_tier < 9:
		$CrystalStar.queue_free()

func _ready():
	$HitPoints.value = current_health
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width / 2 + PADDING
	$HitPoints.position.y = -(height / 2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING * 2
	if move == MOVE.RANDOM_DESTINATION:
		target = G.random_position_in_camera_view()
	elif move == MOVE.AHEAD:
		target = (Vector2.DOWN * 9999).rotated($ShipBody.rotation)

func _physics_process(delta):
	if $HitPoints.value <= 0:
		clear()
	if move == MOVE.RANDOM_DESTINATION && ($ShipBody.global_position - target).length() < 200:
		target = G.random_position_in_camera_view()
	if get_node_or_null("ShipBody"):
		if current_health > 0:
			if face_towards == FACE_TOWARDS.DESTINATION:
				G.rotate_towards_target($ShipBody, target, rotation_speed)
			elif face_towards == FACE_TOWARDS.PLAYER && is_instance_valid(G.player) && G.player.is_playing:
				G.rotate_towards_target($ShipBody, G.player.global_position, rotation_speed)

			if move == MOVE.AHEAD:
				velocity = Vector2.DOWN.rotated($ShipBody.rotation)
			else:
				var desired_velocity = (target - global_position).normalized()
				velocity = lerp(velocity, desired_velocity, acceleration)
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
		stop_jets()
		muzzles_status(false)
		tween.tween_property($ShipBody, "modulate", Color(4, 2, 1), G.HEALTH_TWEEN_TIME) # shine
	if $HitPoints.value > 0:
		var ratio = current_health / $HitPoints.max_value
		var red_component = min(1, 2 * (1 - ratio))
		var green_component = min(1, 2 * ratio)
		$HitPoints.get_theme_stylebox("fill").bg_color = Color(red_component, green_component, 0)
		tween.tween_property($HitPoints, "modulate", Color(max(1.7, 1.7 + 1 - green_component), 1.7, 1, 1), G.HEALTH_TWEEN_TIME)
		tween.tween_property($HitPoints, "value", current_health, G.HEALTH_TWEEN_TIME)

func clear():
	G.explode(self)
	queue_free()

func stop_jets():
	var jets = $ShipBody.get_node_or_null("Jets")
	if jets:
		for jet in jets.get_children():
			jet.lifetime = 0.2
			jet.emitting = false

func _on_visible_on_screen_enabler_2d_screen_entered():
	if not shooting:
		muzzles_status(true)

func muzzles_status(status):
	if muzzles:
		if status:
			for muzzle in muzzles.get_children():
				if status:
					muzzle.timer.start()
		else:
			muzzles.queue_free()
			muzzles = null
