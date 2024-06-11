class_name Player extends Area2D

var cannon_level

var shot_speed
@export var shot_speed_base = 900
var shot_speed_level = 0:
	set(value):
		shot_speed_level = value
		shot_speed = G.diminishing_increase(shot_speed_base, shot_speed_level)

var shots_per_second
@export var fire_rate_base = 1
var fire_rate_level = 0:
	set(value):
		fire_rate_level = value
		shots_per_second = G.diminishing_increase(fire_rate_base, fire_rate_level)

var fire_power
@export var fire_power_base = 1
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
@export var shot_scene = preload("res://scenes/shots/plasma.tscn")
@export var shot_color = Color(0, 0.2, 1)
@export var explosion = preload("res://scenes/explosions/fire_explosion.tscn")

# Calculated properties
var image
var width
var height
var explosion_scale

var is_playing = true
var move_player = false
var just_spawned = 10
var grazing_with = 0
var graze_power = 0.0

func _enter_tree():
	# Upgrades affecting all ships
	var commander_upgrades = DataManager.player_data.commander

	for property in commander_upgrades.keys():
		set(property, int(commander_upgrades[property]))
	
	rotation = PI # 180°

	image = $Sprite.texture.diffuse_texture.get_image()
	var image_size = Vector2(image.get_size()) * scale
	width = image_size.x
	height = image_size.y
	explosion_scale = max(width, height) / 300.0

func _ready():
	get_viewport().warp_mouse(Vector2(540, 1540))
	play()

func _physics_process(delta):
	if is_playing and G.touching:
		global_position = global_position.lerp(get_global_mouse_position(), delta * movement_speed)
		global_position.x = clamp(global_position.x, G.camera.get_min().x, G.camera.get_max().x)
		global_position.y = clamp(global_position.y, G.camera.get_min().y, G.camera.get_max().y)
	graze_power = snapped(graze_power + grazing_with * delta, 0.001)

func play():
	for muzzle in $CannonConfiguration.get_children():
		muzzle.get_node("Timer").start()
	set_visible(true)
	is_playing = true
	$GrazeArea.set_deferred("disabled", false)
	$HitArea/CollisionShape2D.set_deferred("disabled", false)
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func handle_hit(shot):
	clear(shot)

func clear(_cause):
	for muzzle in $CannonConfiguration.get_children():
		muzzle.get_node("Timer").stop()
	set_visible(false)
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

func click(at_position):
	var press = InputEventScreenTouch.new()
	press.set_position(at_position)
	press.set_pressed(true)
	Input.parse_input_event(press)
	await get_tree().process_frame
	var release = InputEventScreenTouch.new()
	release.set_pressed(false)
	Input.parse_input_event(release)
