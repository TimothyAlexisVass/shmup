class_name Player extends Area2D

# Basic properties
@export var explosion = preload("res://scenes/explosions/fire_explosion.tscn")

# Calculated properties
var explosion_scale

var is_playing = true
var just_spawned = 10
var spawn_position = Vector2(540, 1540)
var grazing_with = 0
var graze_power = 0.0

@export var movement_speed_base = 1
var movement_speed = G.linear_increase(movement_speed_base, 15, G.selected_pilot_data.maneuver_level, 20)

@export var graze_area_radius_base = 1

func _enter_tree():
	global_position = spawn_position
	rotation = PI # 180°

	var image_size = Vector2($Sprite.texture.diffuse_texture.get_image().get_size()) * scale
	explosion_scale = max(image_size.x, image_size.y) / 300.0

func _ready():
	$GrazeArea.scale *= graze_area_radius_base * (1 + 1.02 * G.selected_pilot_data.graze_area_radius_multiplier)
	$CannonConfiguration/Main.shot_speed = G.diminishing_increase($CannonConfiguration/Main.shot_speed, G.selected_player_ship_data.main_shot_speed_level)
	$CannonConfiguration/Main.fire_rate = G.diminishing_increase($CannonConfiguration/Main.fire_rate, G.selected_player_ship_data.main_fire_rate_level)
	$CannonConfiguration/Main.fire_power =  G.diminishing_increase($CannonConfiguration/Main.fire_power, G.selected_player_ship_data.main_fire_power_level)
	get_viewport().warp_mouse(spawn_position)
	play()

func _physics_process(delta):
	if just_spawned > 0:
		global_position = spawn_position
		just_spawned -= 1
	elif is_playing and G.touching:
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
