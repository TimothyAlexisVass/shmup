class_name CannonConfiguration extends Node2D

@onready var parent = get_parent()
@onready var image = parent.get_node("Sprite").texture.get_image()
@onready var width = image.get_size().x
@onready var height = image.get_size().y
@onready var center_line = width / 2

func _ready():
	if parent.cannon_level & 1:
		add_muzzle(0)
	for offset in range(1, ceil((parent.cannon_level + 0.1) / 2)):
		add_muzzle(-offset * 5)
		add_muzzle(offset * 5)

func add_muzzle(x):
	var muzzle = Marker2D.new()
	muzzle.position.x = x
	muzzle.position.y = get_top_pixel(x + center_line)
	muzzle.rotation = x / 321.0
	add_child(muzzle)

func get_top_pixel(x):
	for y in range(height):
		if image.get_pixel(x,y)[3] > 0:
			return y
