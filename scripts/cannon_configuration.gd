class_name CannonConfiguration extends Node2D

@onready var parent = get_parent()
@onready var image = parent.image
@onready var width = image.get_size().x
@onready var height = image.get_size().y
@onready var center_line = width / 2

func _ready():
	if parent.cannon_level & 1: # odd number
		add_muzzle(0, get_top_pixel(center_line))
	for offset in range(1, ceil((parent.cannon_level + 0.1) / 2)):
		var x = offset * 5
		var y = get_top_pixel(offset * 5 + center_line)
		add_muzzle(x, y)
		add_muzzle(-x, y)

func add_muzzle(x, y):
	var muzzle = Marker2D.new()
	muzzle.position = Vector2(x, y)
	muzzle.rotation = x / 321.0
	add_child(muzzle)

func get_top_pixel(x):
	for y in range(height):
		if image.get_pixel(x,y)[3] > 0:
			return y
