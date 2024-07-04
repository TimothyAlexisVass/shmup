extends ColorRect

var available_cannon_mounts = []
var player_ship_details

@onready var ship_texture = $MarginContainer/VBoxContainer/Control/ShipTexture
@onready var cannon_mount_positions = $MarginContainer/VBoxContainer/Control/CannonPositions
@onready var mounted_cannon_details_grid = $MarginContainer/VBoxContainer/MountedCannonDetails/VBoxContainer/GridContainer
@onready var mounted_cannon_name = $MarginContainer/VBoxContainer/MountedCannonDetails/VBoxContainer/CannonName
@onready var inventory_cannon_details_grid = $MarginContainer/VBoxContainer/InventoryCannonDetails/VBoxContainer/GridContainer
@onready var inventory_cannon_name = $MarginContainer/VBoxContainer/InventoryCannonDetails/VBoxContainer/CannonName
@onready var inventory_grid = $MarginContainer/VBoxContainer/Inventory

const CANNON_MOUNT_POSITION_SCENE = preload("res://scenes/modals/cannon_mount_position.tscn")
const INVENTORY_ITEM_SCENE = preload("res://scenes/modals/inventory_slot.tscn")

var available_cannon_mount_positions = []
var json = JSON.new()

func _ready():
	initialize_inventory()

func initialize(player_ship_name):
	player_ship_details = DataManager.player_data.player_ship[player_ship_name]
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
		var cannon_details = null
		if cannon_mount_position.name in player_ship_details.cannons.keys():
			cannon_details = player_ship_details.cannons[cannon_mount_position.name]
			texture_button.texture_normal = load("res://media/sprites/cannons/" + cannon_details.shot_type + ".png")
		else:
			texture_button.texture_normal = null
		if texture_button.pressed.is_connected(_on_cannon_mount_position_button_pressed):
			texture_button.pressed.disconnect(_on_cannon_mount_position_button_pressed)
		texture_button.pressed.connect(_on_cannon_mount_position_button_pressed.bind(cannon_mount_position.name, cannon_details))
		if cannon_mount_position.name == "Main":
			texture_button.pressed.emit()
	available_cannon_mount_positions = []

func _on_cannon_mount_position_button_pressed(cannon_mount_position_name, cannon_details):
	mounted_cannon_name.text = cannon_mount_position_name + (": " + cannon_details.name + " (" + cannon_details.shot_type + ")" if cannon_details else ": Empty mount")
	update_cannon_details(mounted_cannon_details_grid, cannon_details)
	update_cannon_comparison()

func _on_inventory_cannon_pressed(cannon_details):
	inventory_cannon_name.text = cannon_details.name + " (" + cannon_details.shot_type + ")"
	update_cannon_details(inventory_cannon_details_grid, cannon_details)
	update_cannon_comparison()

func update_cannon_details(grid, cannon_details):
	for cannon_property in grid.get_children():
		cannon_property.get_node("label").text = ""
		cannon_property.get_node("value").text = ""
		if cannon_details:
			var value = cannon_details.get(cannon_property.name)
			if value is Array or (value and value > 0):
				cannon_property.get_node("label").text = cannon_property.name.replace("_", " ").capitalize()
				cannon_property.get_node("value").text = str(value)

func update_cannon_comparison():
	for cannon_property in inventory_cannon_details_grid.get_children():
		var inventory_value = cannon_property.get_node("value").text
		if inventory_value != "":
			var mounted_value_node = mounted_cannon_details_grid.get_node(cannon_property.name + "/value")
			var mounted_value = mounted_value_node.text
			var font_color = [Color.GREEN, Color.RED]
			if mounted_value != "":
				json.parse(mounted_value)
				mounted_value = json.get_data()
				json.parse(inventory_value)
				inventory_value = json.get_data()
				if mounted_value is Array:
					inventory_value = inventory_value.size() / G.sum(inventory_value)
					mounted_value = mounted_value.size() / G.sum(mounted_value)
				if inventory_value < mounted_value:
					font_color = [Color.RED, Color.GREEN]
				elif inventory_value == mounted_value:
					font_color = [Color.WHITE, Color.WHITE]
			cannon_property.get_node("value").set("theme_override_colors/font_color", font_color[0])
			mounted_value_node.set("theme_override_colors/font_color", font_color[1])

func _on_close_button_pressed():
	set_visible(false)

func initialize_inventory():
	var cannons = DataManager.player_data.get("cannon")
	for cannon in cannons:
		add_inventory_cannon(cannons[cannon])

func add_inventory_cannon(cannon_details):
	var inventory_cannon = INVENTORY_ITEM_SCENE.instantiate()
	var texture_button = inventory_cannon.get_node("TextureButton")
	texture_button.texture_normal = load("res://media/sprites/cannons/" + cannon_details.shot_type + ".png")

	if texture_button.pressed.is_connected(_on_inventory_cannon_pressed):
		texture_button.pressed.disconnect(_on_inventory_cannon_pressed)
	texture_button.pressed.connect(_on_inventory_cannon_pressed.bind(cannon_details))
	inventory_grid.add_child(inventory_cannon)
