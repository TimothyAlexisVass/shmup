extends ColorRect

var available_cannon_mounts = []

@onready var ship_texture = $MarginContainer/VBoxContainer/Control/ShipTexture
@onready var cannon_mount_positions = $MarginContainer/VBoxContainer/Control/CannonPositions
@onready var selected_ship_data = DataManager.player_data.player_ship[DataManager.player_data.selected_player_ship]

const CANNON_MOUNT_POSITION_SCENE = preload("res://scenes/modals/cannon_mount_position.tscn")

func initialize(player_ship_name):
	available_cannon_mounts = []
	var player_ship_data = PlayerShip.data[player_ship_name]
	var player_ship_instance = player_ship_data.scene.instantiate()
	for cannon_mount in player_ship_instance.get_node("CannonMounts").get_children():
		available_cannon_mounts.append(cannon_mount.name)
	for cannon_position in cannon_mount_positions.get_children():
		var visibility = true if cannon_position.name in available_cannon_mounts else false
		cannon_position.set_visible(visibility)
	ship_texture.texture = player_ship_data.texture
	update_cannon_mount_positions()
	set_visible(true)

func update_cannon_mount_positions():
	for cannon_mount_position in cannon_mount_positions.get_children():
		var texture_node = cannon_mount_position.get_node("Texture")
		if cannon_mount_position.name in selected_ship_data.cannons.keys():
			var cannon_data = selected_ship_data.cannons[cannon_mount_position.name]
			texture_node.texture = load("res://media/sprites/cannons/" + cannon_data.shot_type + ".png")
		else:
			texture_node.texture = null

func _on_close_button_pressed():
	set_visible(false)
