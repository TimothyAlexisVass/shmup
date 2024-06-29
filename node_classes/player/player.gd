class_name Player extends Area2D

# Calculated properties
var explosion_scale

var is_playing = true
var just_spawned: int = 10
var spawn_position = Vector2(540, 1540)
var grazing_with: int = 0
var graze_power: float = 0

@export var tier: int = 0
@export var movement_speed_base: float = 1
@export var graze_area_radius_base: float = 1
@export var explosion: PackedScene = preload("res://scenes/explosions/fire_explosion.tscn")

var ship_data = DataManager.player_data.player_ship[DataManager.player_data.selected_player_ship]
var pilot_data = DataManager.player_data.pilot[DataManager.player_data.selected_pilot]
var commander_data = DataManager.player_data.commander

@onready var movement_speed = G.linear_increase(movement_speed_base, 15, pilot_data.maneuver_level, 20)
@onready var graze_power_factor = G.diminishing_increase(pilot_data.graze_power_base, pilot_data.graze_power_level) * commander_data.graze_power_multiplier

func _enter_tree():
	for cannon_mount in ["FrontLeft", "FrontRight", "Rear"]:
		ship_data.cannons[cannon_mount] = Cannon.generate(0)
	global_position = spawn_position

	var image_size = Vector2($Sprite.texture.diffuse_texture.get_image().get_size()) * scale
	explosion_scale = max(image_size.x, image_size.y) / 300.0
	
	if pilot_data.max_cannon_count > 1:
		mount_cannons()

func _ready():
	$GrazeArea.scale *= graze_area_radius_base * pilot_data.graze_area_radius_multiplier
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
	graze_power = snapped(graze_power + graze_power_factor * grazing_with * delta, 0.001)

func mount_cannons():
	var active_cannons = 1
	for cannon in ship_data.cannons:
		$CannonMounts.get_node(cannon).cannon = ship_data.cannons[cannon]
		active_cannons +=1
		if active_cannons > pilot_data.max_cannon_count:
			break
	for cannon_mount in $CannonMounts.get_children():
		if cannon_mount.cannon == null:
			cannon_mount.queue_free()

func play():
	set_visible(true)
	is_playing = true
	$GrazeArea.set_deferred("disabled", false)
	$HitArea/CollisionShape2D.set_deferred("disabled", false)
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func handle_hit(shot):
	clear(shot)

func clear(_cause):
	for cannon_mount in $CannonMounts.get_children():
		cannon_mount.set_physics_process(false)
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
