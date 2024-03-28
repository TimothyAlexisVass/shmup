class_name Ship extends Node2D

const PADDING = 10

# Basic properties
@export var speed: float
@export var total_hit_points: float
@export var points: float
@export var explosion: PackedScene
@export var aim_at_player: bool
@export var move_where_heading: bool

# Calculated properties
var image
var width
var height
var explosion_scale

@onready var current_health = total_hit_points

func _enter_tree():
	image = $ShipBody/Sprite.texture.get_image()
	width = image.get_size().x
	height = image.get_size().y
	explosion_scale = max(width, height) / 200.0
	global_position = Vector2(randf_range(50, Globals.play_area.max.x), Globals.play_area.min.y - height)

func _ready():
	$HitPoints.value = current_health
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width / 2 + PADDING
	$HitPoints.position.y = -(height / 2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING * 2

func _process(_delta):
	if $HitPoints.value <= 0:
		clear()

func _physics_process(delta):
	if move_where_heading:
		var velocity = Vector2.DOWN.rotated($ShipBody.rotation) * speed * delta
		translate(velocity)
	else:
		global_position.y += speed * delta
	if aim_at_player && is_instance_valid(Globals.player) && Globals.player.is_playing:
		$ShipBody.rotation = Globals.ANGLE_UP + self.global_position.angle_to_point(Globals.player.global_position)

func _on_collision(object):
	if object is Player:
		object.clear()
		take_damage(current_health)
	if object is Shot and object.source is Player:
		take_damage(object.source.fire_power)
		if $HitPoints.value > 0:
			object.hit(self)

func take_damage(amount):
	current_health -= amount
	if not $HitPoints.visible:
		$HitPoints.visible = true

	var tween = create_tween()
	tween.set_parallel()
	if current_health <= 0:
		tween.tween_property($ShipBody, "modulate", Color(4, 2, 1), 0.2) # shine
	if $HitPoints.value > 0:
		var ratio = $HitPoints.value / $HitPoints.max_value
		var red_component = min(1, 2 * (1 - ratio))
		var green_component = min(1, 2 * ratio)
		$HitPoints.get_theme_stylebox("fill").bg_color = Color(red_component, green_component, 0)
		$HitPoints.modulate = Color(max(1.7, 1.7 + 1 - green_component), 1.7, 1, 1)
		tween.tween_property($HitPoints, "value", current_health, 0.2)

func clear():
	Globals.explode(self)
	queue_free()
