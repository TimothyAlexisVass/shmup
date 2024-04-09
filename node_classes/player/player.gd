class_name Player extends Area2D

var shot_speed
var shot_speed_base
var shot_speed_level = 0:
	set(value):
		shot_speed_level = value
		shot_speed = G.diminishing_increase(shot_speed_base, shot_speed_level)

var shots_per_second
var fire_rate_base
var fire_rate_level = 0:
	set(value):
		fire_rate_level = value
		shots_per_second = G.diminishing_increase(fire_rate_base, fire_rate_level)

var fire_power
var fire_power_base
var fire_power_level = 0:
	set(value):
		fire_power_level = value
		fire_power = G.diminishing_increase(fire_power_base, fire_power_level)

var movement_speed
@export var movement_speed_base = 10
var movement_speed_increase
var movement_speed_level = 0:
	set(value):
		movement_speed_level = value
		movement_speed = G.linear_increase(movement_speed_base, movement_speed_level, (10 - movement_speed_base) / 1000.0)

# Basic properties
var cannon_level
var image
var texture
var normal_map
var shot_color
var shot_type
var explosion

# Calculated properties
var width
var height
var explosion_scale

var is_playing = true
var just_spawned = 20
var grazing_with = 0
var graze_power = 0.0

func initialize(data, levels):
	for property in data.keys():
		set(property, data[property])
	for property in levels.keys():
		set(property, int(levels[property]))

	rotation = PI
	image = texture.get_image()
	var image_size = Vector2(image.get_size()) * scale
	$Sprite.texture.diffuse_texture = texture
	$Sprite.texture.normal_texture = normal_map
	width = image_size.x
	height = image_size.y
	explosion_scale = max(width, height) / 300.0

func _ready():
	print(get_viewport().size)
	play()

func _physics_process(delta):
	if is_playing:
		global_position = global_position.lerp(get_global_mouse_position(), delta * movement_speed)
		global_position.x = clamp(global_position.x, G.play_area.min.x, G.play_area.max.x)
		global_position.y = clamp(global_position.y, G.play_area.min.y, G.play_area.max.y)
	if just_spawned > 0:
		global_position = Vector2(540, 1540 + G.GAME_AREA_OFFSET.y/2 + 14)
		just_spawned -= 1
	graze_power = snapped(graze_power + grazing_with * delta, 0.001)

func play():
	for muzzle in $CannonConfiguration.get_children():
		muzzle.get_node("Timer").start()
	visible = true
	is_playing = true
	$GrazeArea.set_deferred("disabled", false)
	$HitArea/CollisionShape2D.set_deferred("disabled", false)
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func handle_hit(_shot):
	clear()

func clear():
	for muzzle in $CannonConfiguration.get_children():
		muzzle.get_node("Timer").stop()
	visible = false
	is_playing = false
	G.explode(self)
	$GrazeArea.set_deferred("disabled", true)
	$HitArea/CollisionShape2D.set_deferred("disabled", true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_area_entered(area):
	if area is Shot:
		grazing_with += 1

func _on_area_exited(area):
	if area is Shot:
		grazing_with -= 1
