class_name CannonConfiguration extends Node2D

@onready var parent = get_parent()
@onready var image = parent.image
@onready var width = image.get_size().x
@onready var height = image.get_size().y
@onready var center_line = width / 2

func _ready():
	if parent.cannon_level & 1: # odd number
		add_muzzle(0, get_top_pixel(center_line), 0)
	var x_offset = 5 / parent.scale.x
	var y_offset = 5 / parent.scale.y
	var x
	var y
	for cannon_number in range(1, ceil((parent.cannon_level + 0.1) / 2)):
		if x_offset <= width / 2:
			x = x_offset / parent.scale.x
			y = get_top_pixel(x_offset + center_line)
			x_offset += 5 / parent.scale.x
		else:
			x = get_left_pixel(y_offset)
			y = y_offset
			y_offset += 5 / parent.scale.y
			cannon_number += 100
			cannon_number *= 2

		add_muzzle(x, y, cannon_number)
		add_muzzle(-x, y, -cannon_number)

func add_muzzle(x, y, cannon_number):
	var muzzle = Marker2D.new()
	muzzle.position = Vector2(x, y)
	muzzle.rotation = cannon_number / 21.0
	add_child(muzzle)

func get_top_pixel(x):
	for y in range(height):
		if image.get_pixel(x, y)[3] > 0:
			return y

func get_left_pixel(y):
	for x in range(width):
		if image.get_pixel(x, y)[3] > 0:
			return x
