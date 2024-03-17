class_name Ship extends Node2D

const PADDING = 10

# Basic properties
var speed
var total_hit_points
var points
var texture
var collision_shape

# Calculated properties
var width
var height
var image

var hit_points_bar_fill_stylebox = preload("res://styles/hit_points_bar_fill.tres")
var hit_points_bar_background_stylebox = preload("res://styles/hit_points_bar_background.tres")

@onready var game = get_node('/root/Game')
@onready var player = game.player
@onready var hit_points_bar_fill = hit_points_bar_fill_stylebox.duplicate()
@onready var hit_points_bar_background = hit_points_bar_background_stylebox.duplicate()

func initialize(data):
	for property in data.keys():
		set(property, data[property])

	image = texture.get_image()
	$ShipBody/Sprite.texture = ImageTexture.create_from_image(image)
	width = image.get_size().x
	height = image.get_size().y
	$ShipBody.add_child(collision_shape.duplicate())

func _ready():
	$HitPoints.add_theme_stylebox_override("fill", hit_points_bar_fill)
	$HitPoints.add_theme_stylebox_override("background", hit_points_bar_background)
	$HitPoints.value = total_hit_points
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width/2 + PADDING
	$HitPoints.position.y = -(height/2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING*2

func _physics_process(delta):
	global_position.y += speed * delta
	if is_instance_valid(player):
		$ShipBody.rotation = Game.ANGLE_UP + self.global_position.angle_to_point(player.global_position)

func _on_collision(object):
	if object is Player:
		object.die()
		die()
	if object is PlayerShot:
		take_damage(object.damage)
		object.hit(self.global_position)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage(amount):
	$HitPoints.value -= amount
	var ratio = $HitPoints.value / $HitPoints.max_value
	var red_component = min(1, 2 * (1 - ratio))
	var green_component = min(1, 2 * ratio)
	hit_points_bar_fill.bg_color = Color(red_component, green_component, 0)

	if not $HitPoints.visible:
		$HitPoints.visible = true
	if $HitPoints.value <= 0:
		die()

func die():
	game.score += points
	queue_free()
