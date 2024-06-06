class_name CannonConfiguration extends Node2D

@onready var parent = get_parent()
@onready var image = parent.image
@onready var width = image.get_size().x
@onready var height = image.get_size().y
@onready var center_line = width / 2

var muzzle_scene = preload("res://node_classes/muzzle/muzzle.tscn")

func _ready():
	if parent.cannon_level & 1: # odd number
		add_muzzle(0, get_top_pixel(center_line), 0)
	var x_offset = round(5.0 / parent.scale.x)
	var x
	var y
	for cannon_number in range(1, ceil((parent.cannon_level + 0.1) / 2)):
		if x_offset <= width / 2:
			x = round(x_offset * parent.scale.x)
			y = round(get_top_pixel(x_offset + center_line) * parent.scale.x)
			x_offset = round(x_offset + 5 / parent.scale.x)
		add_muzzle(x, y, cannon_number)
		add_muzzle(-x, y, -cannon_number)

func add_muzzle(x, y, cannon_number):
	var muzzle = muzzle_scene.instantiate()
	muzzle.shot_scene = parent.shot_scene
	muzzle.position = Vector2(x, y)
	muzzle.rotation = cannon_number / 21.0
	muzzle.rate_of_fire = parent.shots_per_second
	muzzle.shot_speed = parent.shot_speed
	muzzle.default_color = parent.shot_color
	add_child(muzzle)
	muzzle.timer.start()

func get_top_pixel(x):
	for y in range(height):
		if image.get_pixel(x, y)[3] > 0:
			return y
