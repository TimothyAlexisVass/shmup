extends ColorRect

var available_cannon_mounts = []

@onready var ship_texture = $MarginContainer/VBoxContainer/Control/ShipTexture
@onready var cannon_positions = $MarginContainer/VBoxContainer/Control/CannonPositions

const CANNON_MOUNT_POSITION_SCENE = preload("res://scenes/modals/cannon_mount_position.tscn")

func initialize(player_ship_name):
	available_cannon_mounts = []
	var player_ship_data = PlayerShip.data[player_ship_name]
	var player_ship_instance = player_ship_data.scene.instantiate()
	for cannon_mount in player_ship_instance.get_node("CannonMounts").get_children():
		available_cannon_mounts.append(cannon_mount.name)
	for cannon_position in cannon_positions.get_children():
		var visibility = true if cannon_position.name in available_cannon_mounts else false
		cannon_position.set_visible(visibility)
	ship_texture.texture = player_ship_data.texture
	set_visible(true)

func _on_close_button_pressed():
	set_visible(false)
