class_name Player extends CharacterBody2D

var shot_speed
var shot_speed_base
var shot_speed_level = 0:
	set(value):
		shot_speed_level = value
		shot_speed = Globals.diminishing(shot_speed_base, shot_speed_level)

var shots_per_second
var fire_rate_base
var fire_rate_level = 0:
	set(value):
		fire_rate_level = value
		shots_per_second = 1 / Globals.diminishing(fire_rate_base, fire_rate_level)
		$ShootTimer.wait_time = shots_per_second

var fire_power
var fire_power_base
var fire_power_level = 0:
	set(value):
		fire_power_level = value
		fire_power = Globals.diminishing(fire_power_base, fire_power_level)

var movement_speed
var movement_speed_base
var movement_speed_increase
var movement_speed_level = 0:
	set(value):
		movement_speed_level = value
		movement_speed = Globals.linear(movement_speed_base, movement_speed_level, (5000 - movement_speed_base) / 1000.0)

# Basic properties
var ship_name
var cannon_level
var texture
var graze_area
var shot_color
var shot_type
var explosion

# Calculated properties
var image
var width
var height
var explosion_scale

var shot_scene = preload("res://node_classes/shot/shot.tscn")
var shot_instance
var shot_offset

@onready var is_playing = true

func initialize(data, levels):
	for property in data.keys():
		set(property, data[property])
	for property in levels.keys():
		set(property, int(levels[property]))

	image = texture.get_image()
	$Sprite.texture = ImageTexture.create_from_image(image)
	width = image.get_size().x
	height = image.get_size().y
	explosion_scale = max(width, height) / 200.0
	graze_area.set_name(ship_name + "GrazeArea")
	add_child(graze_area)

func _ready():
	shot_instance = shot_scene.instantiate()
	shot_offset = shot_instance.shot_types[shot_type].offset
	play()

func _physics_process(delta):
	if is_playing:
		var direction = get_global_mouse_position() - global_position
		velocity = direction * delta * movement_speed / 10
		velocity.x = clamp(velocity.x, -movement_speed, movement_speed)
		velocity.y = clamp(velocity.y, -movement_speed, movement_speed)
		move_and_slide()
		global_position.x = clamp(global_position.x, Globals.play_area.min.x, Globals.play_area.max.x)
		global_position.y = clamp(global_position.y, Globals.play_area.min.y, Globals.play_area.max.y)

func play():
	$ShootTimer.start()
	visible = true
	is_playing = true
	get_node(ship_name + "GrazeArea").call_deferred("set_disabled", false)
	$HitArea.call_deferred("set_disabled", false)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func clear():
	$ShootTimer.stop()
	visible = false
	is_playing = false
	Globals.explode(self)
	get_node(ship_name + "GrazeArea").call_deferred("set_disabled", true)
	$HitArea.call_deferred("set_disabled", true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_shoot_timer_timeout():
	for muzzle in $CannonConfiguration.get_children():
		var shot = shot_instance.duplicate()
		shot.initialize(self)
		shot.rotation = muzzle.rotation
		shot.global_position = muzzle.global_position - shot_offset
		Globals.player_stuff.add_child(shot)