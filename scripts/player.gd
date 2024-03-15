class_name Player extends CharacterBody2D

var shot_speed
var shot_speed_base = 200
var shot_speed_level = 0:
	set(value):
		shot_speed_level = value
		shot_speed = Game.diminishing(shot_speed_base, shot_speed_level)

var movement_speed_level = 50
var fire_power_level = 1
var cannon_level = 4

var shots_per_second
var fire_rate_base = 0.5
var fire_rate_level = 0:
	set(value):
		fire_rate_level = value
		shots_per_second = 1 / Game.diminishing(fire_rate_base, fire_rate_level)
		$ShootTimer.wait_time = shots_per_second

var score := 0:
	set(value):
		score = value
		$UI/HUD.score = score

@onready var game = get_node('/root/Game')
@onready var max_x = get_viewport().size.x
@onready var max_y = get_viewport().size.y
@onready var cannon_configuration = get_node("CannonConfiguration" + str(cannon_level))

var player_shot = preload("res://scenes/player_shot.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_viewport().warp_mouse(self.position)

func _physics_process(delta):
	var direction = handle_position() - self.position
	velocity = direction * delta * movement_speed_level
	move_and_slide()

func handle_position():
	var mouse_position = get_viewport().get_mouse_position()
	if mouse_position.x < 0:
		mouse_position.x = 0
	if mouse_position.y < 0:
		mouse_position.y = 0
	if mouse_position.x > max_x:
		mouse_position.x = max_x
	if mouse_position.y > max_y:
		mouse_position.y = max_y
	get_viewport().warp_mouse(mouse_position)
	return mouse_position

func die():
	queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_shoot_timer_timeout():
	for muzzle in cannon_configuration.get_children():
		var shot = player_shot.instantiate()
		var muzzle_rotation = muzzle.rotation
		shot.speed = shot_speed
		shot.damage = fire_power_level
		shot.rotation = muzzle_rotation
		shot.global_position = muzzle.global_position
		game.add_child(shot)
