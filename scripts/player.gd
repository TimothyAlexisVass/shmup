class_name Player extends CharacterBody2D

var projectile_speed
var projectile_speed_base
var projectile_speed_level = 0:
	set(value):
		projectile_speed_level = value
		projectile_speed = Game.diminishing(projectile_speed_base, projectile_speed_level)

var shots_per_second
var fire_rate_base
var fire_rate_level = 0:
	set(value):
		fire_rate_level = value
		shots_per_second = 1 / Game.diminishing(fire_rate_base, fire_rate_level)
		$ShootTimer.wait_time = shots_per_second

var fire_power
var fire_power_base
var fire_power_level = 0:
	set(value):
		fire_power_level = value
		fire_power = Game.diminishing(fire_power_base, fire_power_level)

var movement_speed
var movement_speed_base
var movement_speed_increase
var movement_speed_level = 0:
	set(value):
		movement_speed_level = value
		movement_speed = Game.linear(movement_speed_base, movement_speed_level, (5000 - movement_speed_base) / 1000.0)

# Basic properties
var cannon_level
var texture
var graze_area

# Calculated properties
var image
var width
var height

var player_shot = preload("res://scenes/player_shot.tscn")

@onready var game = get_node("/root/Game")
@onready var player_stuff = game.get_node("Stuff/PlayerStuff")
@onready var sprite = $Sprite

func initialize(data, levels):
	for property in data.keys():
		set(property, data[property])
	for property in levels.keys():
		set(property, int(levels[property]))

	image = texture.get_image()
	$Sprite.texture = ImageTexture.create_from_image(image)
	width = image.get_size().x
	height = image.get_size().y
	add_child(graze_area.duplicate())

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta):
	var direction = get_global_mouse_position() - self.global_position
	velocity = direction * delta * movement_speed / 10
	velocity.x = clamp(velocity.x, -movement_speed, movement_speed)
	velocity.y = clamp(velocity.y, -movement_speed, movement_speed)
	self.global_position.x = clamp(self.global_position.x, game.area.min.x, game.area.max.x)
	self.global_position.y = clamp(self.global_position.y, game.area.min.y, game.area.max.y)
	move_and_slide()

func clear():
	queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_shoot_timer_timeout():
	for muzzle in $CannonConfiguration.get_children():
		var shot = player_shot.instantiate()
		shot.speed = projectile_speed
		shot.damage = fire_power
		shot.rotation = muzzle.rotation
		shot.global_position = muzzle.global_position
		player_stuff.add_child(shot)
