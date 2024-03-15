class_name Ship extends Area2D

var speed
var total_hit_points
var points
var texture

const PADDING = 10

var hit_points_bar_fill_stylebox = preload("res://styles/hit_points_bar_fill.tres")
var hit_points_bar_background_stylebox = preload("res://styles/hit_points_bar_background.tres")

@onready var game = get_node('/root/Game')
@onready var hit_points_bar_fill = hit_points_bar_fill_stylebox.duplicate()
@onready var hit_points_bar_background = hit_points_bar_background_stylebox.duplicate()

func initialize(enemy_data):
	for property in enemy_data.keys():
		set(property, enemy_data[property])

func _ready():
	$HitPoints.add_theme_stylebox_override("fill", hit_points_bar_fill)
	$HitPoints.add_theme_stylebox_override("background", hit_points_bar_background)
	var image = texture.get_image()
	var width = image.get_size().x
	var height = image.get_size().y
	# TODO: Move this to the Spawner
	CollisionShapeGenerator.generate(self, image)
	$HitPoints.value = total_hit_points
	$HitPoints.max_value = total_hit_points
	$HitPoints.position.x = -width/2 + PADDING
	$HitPoints.position.y = -(height/2 + $HitPoints.size.y + PADDING)
	$HitPoints.size.x = width - PADDING*2

func _physics_process(delta):
	global_position.y += speed * delta

func _on_collision(object):
	if object is Player:
		object.die()
		die()
	if object is PlayerShot:
		take_damage(object.damage)
		object.queue_free()

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
