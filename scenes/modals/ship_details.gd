extends ColorRect

@onready var ship_texture = $MarginContainer/VBoxContainer/Container/ShipTexture
@onready var width = ship_texture.size.x
@onready var height = ship_texture.size.y
@onready var mid = Vector2(width/2, height/2)

const CANNON_MOUNT_POSITION_SCENE = preload("res://scenes/modals/cannon_mount_position.tscn")

func initialize(player_ship_name):
	ship_texture.texture = load("res://resources/textures/" + player_ship_name + ".tres")
	set_visible(true)

func _on_close_button_pressed():
	set_visible(false)
