extends ColorRect

var available_cannon_mounts = []

@onready var ship_texture = $MarginContainer/VBoxContainer/Control/ShipTexture
@onready var cannon_mount_positions = $MarginContainer/VBoxContainer/Control/CannonPositions
@onready var selected_ship_data = DataManager.player_data.player_ship[DataManager.player_data.selected_player_ship]

const CANNON_MOUNT_POSITION_SCENE = preload("res://scenes/modals/cannon_mount_position.tscn")

var available_cannon_mount_positions = []

func initialize(player_ship_name):
	available_cannon_mounts = []
	var player_ship_data = PlayerShip.data[player_ship_name]
	var player_ship_instance = player_ship_data.scene.instantiate()
	for cannon_mount in player_ship_instance.get_node("CannonMounts").get_children():
		available_cannon_mounts.append(cannon_mount.name)
	for cannon_mount_position in cannon_mount_positions.get_children():
		var visibility = false
		if cannon_mount_position.name in available_cannon_mounts:
			visibility = true
			available_cannon_mount_positions.append(cannon_mount_position)
		var process_mode_setting = ProcessMode.PROCESS_MODE_INHERIT if visibility else ProcessMode.PROCESS_MODE_DISABLED
		cannon_mount_position.set_visible(visibility)
		cannon_mount_position.set_process_mode(process_mode_setting)
	ship_texture.texture = player_ship_data.texture
	update_cannon_mount_positions()
	set_visible(true)

func update_cannon_mount_positions():
	for cannon_mount_position in available_cannon_mount_positions:
		var texture_button = cannon_mount_position.get_node("TextureButton")
		if cannon_mount_position.name in selected_ship_data.cannons.keys():
			var cannon_data = selected_ship_data.cannons[cannon_mount_position.name]
			texture_button.texture_normal = load("res://media/sprites/cannons/" + cannon_data.shot_type + ".png")
		else:
			texture_button.texture_normal = null
		texture_button.connect("pressed", Callable(self, "_on_cannon_mount_position_button_pressed").bind(cannon_mount_position.name))

func _on_cannon_mount_position_button_pressed(cannon_mount_position_name):
	print(cannon_mount_position_name)

func _on_close_button_pressed():
	set_visible(false)
