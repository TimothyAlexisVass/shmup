class_name Ship extends PathFollow2D

const PADDING = 10

# Basic properties
@export var sprites: Array[CompressedTexture2D] = []
@export var crystal: CompressedTexture2D
@export var speed: float
@export var total_hit_points: float
@export var points: float
@export var explosion: PackedScene
@export var rotation_speed: float = 0.01
@export var acceleration: float = 0.001
@export var spawn_wait_time: float = 1.0

enum FACE {PLAYER, DESTINATION}
@export var face: FACE

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
@onready var cannon_mounts = $ShipBody.get_node_or_null("CannonMounts")
@onready var jets = $ShipBody.get_node_or_null("Jets")

@onready var shooting = false

var shipbody_texture = null
var cleared = false
var rarity = 0
var tier = 1

var power_per_second = 0

signal drop_rewards(recipient, at_global_position)

func _enter_tree():
	var ship_value = randi_range(0, 10000)
	if crystal == null:
		ship_value += 1
	
	if ship_value == 0:
		rarity = 9
	else:
		if ship_value <= 2 && len(sprites) == 5:
			shipbody_texture = sprites[4]
			rarity = 5
		elif ship_value <= 5 && len(sprites) >= 4:
			shipbody_texture = sprites[3]
			rarity = 4
		elif ship_value <= 10 && len(sprites) >= 3:
			shipbody_texture = sprites[2]
			rarity = 3
		elif ship_value <= 100 && len(sprites) >= 2:
			shipbody_texture = sprites[1]
			rarity = 2
		elif ship_value <= 1000 && len(sprites) >= 1:
			shipbody_texture = sprites[0]
			rarity = 1

	if rarity == 9:
		shipbody_texture = crystal

	scale *= 1 + 0.1 * rarity
	total_hit_points *= 1 + rarity

	var image_size = Vector2($ShipBody/Sprite.texture.diffuse_texture.get_image().get_size()) * $ShipBody/Sprite.scale
	width = image_size.x
	height = image_size.y
	explosion_scale = (scale.x * width if width > height else scale.y * height) / 300.0

	if rarity < 9:
		$CrystalStar.queue_free()
	if rarity == 0:
		$ShipBody/RarityGlow.queue_free()
	else:
		$ShipBody/RarityGlow.rarity = rarity

func _ready():
	if cannon_mounts:
		for cannon_mount in cannon_mounts.get_children():
			power_per_second += cannon_mount.cannon.shot_power / G.average(cannon_mount.cannon.shot_rate)
	$HitPoints.value = current_health
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width / 2 + PADDING
	$HitPoints.position.y = -(height / 2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING * 2

	if shipbody_texture != null:
		$ShipBody/Sprite.texture.diffuse_texture = shipbody_texture
		if jets:
			for jet in jets.get_children():
				jet.modulate = G.RARITY_COLOR[rarity] * 2
		$OffScreenIndicator.self_modulate = G.RARITY_COLOR[rarity] * 2

	if move == MOVE.RANDOM_DESTINATION:
		target = G.random_position_in_camera_view()
	elif move == MOVE.AHEAD:
		target = (Vector2.DOWN * 9999).rotated($ShipBody.rotation)

func _physics_process(delta):
	if move == MOVE.RANDOM_DESTINATION && ($ShipBody.global_position - target).length() < 200:
		target = G.random_position_in_camera_view()
	if get_node_or_null("ShipBody"):
		if current_health > 0:
			if face == FACE.DESTINATION && move != MOVE.ALONG_PATH:
				G.rotate_towards_target($ShipBody, target, rotation_speed)
			elif face == FACE.PLAYER && is_instance_valid(G.player) && G.player.is_playing:
				G.rotate_towards_target($ShipBody, G.player.global_position, rotation_speed)

			if move == MOVE.AHEAD:
				velocity = Vector2.DOWN.rotated($ShipBody.rotation)
			elif move != MOVE.ALONG_PATH:
				var desired_velocity = (target - global_position).normalized()
				velocity = lerp(velocity, desired_velocity, acceleration)
		else:
			speed *= 0.99

		if move == MOVE.ALONG_PATH:
			progress += speed * delta
			$ShipBody.rotation = rotation - PI/2
			rotation = 0

		if velocity != Vector2(0, 0):
			translate(velocity * speed * delta)

func _on_collision(object):
	if object is Player and G.player.is_playing and current_health > 0:
		object.clear(self)
		take_damage(self)

func handle_hit(shot):
	take_damage(shot)
	if $HitPoints.value > 0:
		shot.hit(self)

func take_damage(cause):
	var amount = self.current_health if cause == self else cause.power
	current_health -= amount
	if not $HitPoints.visible:
		$HitPoints.visible = true

	var tween = create_tween()
	tween.set_parallel()
	if current_health <= 0:
		$ShipBody/Area2D.set_deferred("monitoring", false)
		$ShipBody/Area2D.set_deferred("monitorable", false)
		stop_jets()
		cannon_mounts_status(false)
		tween.tween_property($ShipBody, "modulate", Color(4, 2, 1), G.HEALTH_TWEEN_TIME) # shine
		if not cleared:
			clear(cause)
	if $HitPoints.value > 0:
		var ratio = current_health / $HitPoints.max_value
		var red_component = min(1, 2 * (1 - ratio))
		var green_component = min(1, 2 * ratio)
		$HitPoints.get_theme_stylebox("fill").bg_color = Color(red_component, green_component, 0)
		tween.tween_property($HitPoints, "modulate", Color(max(1.2, 1.2 + 1 - green_component), 1.2, 1, 1), G.HEALTH_TWEEN_TIME)
		tween.tween_property($HitPoints, "value", current_health, G.HEALTH_TWEEN_TIME)

func clear(cleared_by):
	cleared = true
	if "source" in cleared_by:
		drop_rewards.emit(cleared_by.source, global_position)
	G.explode(self)
	queue_free()

func stop_jets():
	if jets:
		for jet in jets.get_children():
			jet.lifetime = 0.2
			jet.emitting = false

func _on_visible_on_screen_notifier_2d_screen_entered():
	if not shooting:
		cannon_mounts_status(true)

func cannon_mounts_status(status):
	if cannon_mounts:
		if status:
			for cannon_mount in cannon_mounts.get_children():
				if status:
					cannon_mount.set_physics_process(true)
		else:
			cannon_mounts.queue_free()
			cannon_mounts = null
