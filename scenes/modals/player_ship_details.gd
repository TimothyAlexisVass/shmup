extends ColorRect

# TODO: Fix cannon details for certain stats

var available_cannon_mounts = []
var player_ship_details

@onready var cannon_mount_positions = $MarginContainer/VBoxContainer/Control/CannonPositions
@onready var mounted_cannon_details_grid = $MarginContainer/VBoxContainer/MountedCannonDetails/VBoxContainer/GridContainer
@onready var mounted_cannon_name = $MarginContainer/VBoxContainer/MountedCannonDetails/VBoxContainer/CannonName
@onready var inventory_cannon_details_grid = $MarginContainer/VBoxContainer/InventoryCannonDetails/VBoxContainer/GridContainer
@onready var inventory_cannon_name = $MarginContainer/VBoxContainer/InventoryCannonDetails/VBoxContainer/CannonName
@onready var inventory_grid = $MarginContainer/VBoxContainer/Inventory

const PERCENT_STAT = ["penetration_chance", "falloff_rate", "perfect_chance", "perfect_multiplier"]

const CANNON_MOUNT_POSITION_SCENE = preload("res://scenes/modals/cannon_mount_position.tscn")
const INVENTORY_ITEM_SCENE = preload("res://scenes/modals/inventory_slot.tscn")

var selected_cannon_mount_position = null
var selected_inventory_cannon_id = null
var player_ship_name

var available_cannon_mount_positions = []
var json = JSON.new()

func initialize(item_name):
	player_ship_name = item_name
	$MarginContainer/VBoxContainer/ArrowShoosh.set_visible(false)
	player_ship_details = DataManager.player_data.player_ship[player_ship_name]
	available_cannon_mounts = []
	var player_ship_data = PlayerShip.data[player_ship_name]
	var player_ship_instance = player_ship_data.scene.instantiate()
	for cannon_mount in player_ship_instance.get_node("CannonMounts").get_children():
		available_cannon_mounts.append(cannon_mount.name)
	player_ship_instance.queue_free()
	%ShipTexture.texture = player_ship_data.texture

	for cannon_mount_position in cannon_mount_positions.get_children():
		var visibility = cannon_mount_position.name in available_cannon_mounts
		if visibility:
			available_cannon_mount_positions.append(cannon_mount_position)

		cannon_mount_position.set_visible(visibility)
		cannon_mount_position.set_process_mode(ProcessMode.PROCESS_MODE_INHERIT if visibility else ProcessMode.PROCESS_MODE_DISABLED)

	update_cannon_mount_positions()
	update_inventory()
	set_visible(true)

func update_cannon_mount_positions():
	for cannon_mount_position in available_cannon_mount_positions:
		var texture_button = cannon_mount_position.get_node("TextureButton")
		var cannon_details = null
		if cannon_mount_position.name in player_ship_details.cannons.keys():
			cannon_details = player_ship_details.cannons[cannon_mount_position.name]
			texture_button.texture_normal = cannon_details.texture
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
	selected_cannon_mount_position = cannon_mount_position_name
	if selected_cannon_mount_position == "Main":
		$MarginContainer/VBoxContainer/ArrowShoosh.set_visible(false)
	elif selected_inventory_cannon_id:
		$MarginContainer/VBoxContainer/ArrowShoosh.set_visible(true)
	update_cannon_details(mounted_cannon_details_grid, cannon_details)
	update_cannon_comparison()

func _on_inventory_cannon_pressed(cannon_id, cannon_details):
	inventory_cannon_name.text = cannon_details.name + " (" + cannon_details.shot_type + ")"
	selected_inventory_cannon_id = cannon_id
	update_cannon_details(inventory_cannon_details_grid, cannon_details)
	update_cannon_comparison()
	if not selected_cannon_mount_position == "Main":
		$MarginContainer/VBoxContainer/ArrowShoosh.set_visible(true)

func update_cannon_details(grid, cannon_details = null):
	for cannon_property in grid.get_children():
		cannon_property.get_node("label").text = ""
		cannon_property.get_node("value").text = ""
		if cannon_details:
			var value = cannon_details.get(cannon_property.name)
			if value is Array or (value and value > 0):
				cannon_property.get_node("label").text = cannon_property.name.replace("_", " ").capitalize()
				if cannon_property.name == "shot_duration" and value == 99:
					value = "persisting"
				cannon_property.get_node("value").text = str(snapped(value * 100, 0.1))+"%" if cannon_property.name in PERCENT_STAT else str(value)

func update_cannon_comparison():
	for cannon_property in inventory_cannon_details_grid.get_children():
		var inventory_value = cannon_property.get_node("value").text
		var font_color = [Color.GREEN, Color.RED]
		var mounted_value_node = mounted_cannon_details_grid.get_node(cannon_property.name + "/value")

		if inventory_value != "":
			var mounted_value = mounted_value_node.text
			if mounted_value != "":
				json.parse(mounted_value.replace("%", "").replace("persisting", "99"))
				mounted_value = json.get_data()
				json.parse(inventory_value.replace("%", "").replace("persisting", "99"))
				inventory_value = json.get_data()
				if mounted_value is Array:
					inventory_value = 1 / G.average(inventory_value)
					mounted_value = 1 / G.average(mounted_value)
				if inventory_value < mounted_value:
					font_color = [Color.RED, Color.GREEN]
				elif inventory_value == mounted_value:
					font_color = [Color.WHITE, Color.WHITE]
		else:
			font_color = [Color.WHITE, Color.WHITE]

		cannon_property.get_node("value").set("theme_override_colors/font_color", font_color[0])
		mounted_value_node.set("theme_override_colors/font_color", font_color[1])

func _on_close_button_pressed():
	set_visible(false)

func update_inventory():
	selected_inventory_cannon_id = null
	update_cannon_details(inventory_cannon_details_grid)
	G.clear_nodes_from(inventory_grid)
	var cannon_inventory = DataManager.player_data.cannon
	for cannon_id in cannon_inventory:
		add_inventory_cannon(cannon_id, cannon_inventory[cannon_id])

func add_inventory_cannon(cannon_id, cannon_details):
	var inventory_cannon = INVENTORY_ITEM_SCENE.instantiate()
	var texture_button = inventory_cannon.get_node("TextureButton")
	texture_button.texture_normal =cannon_details.texture

	if texture_button.pressed.is_connected(_on_inventory_cannon_pressed):
		texture_button.pressed.disconnect(_on_inventory_cannon_pressed)
	texture_button.pressed.connect(_on_inventory_cannon_pressed.bind(cannon_id, cannon_details))
	inventory_grid.add_child(inventory_cannon)

func _on_mount_button_pressed():
	Api.mount_cannon(self, player_ship_name, selected_cannon_mount_position, selected_inventory_cannon_id)

func _on_api_mount_cannon_completed(_result: int, response_code: int, _headers: Array, body: PackedByteArray, http_request_object: LoadingHTTPRequest):
	if response_code == 200:
		json.parse(body.get_string_from_ascii())
		var data = json.get_data()
		player_ship_details.cannons[selected_cannon_mount_position] = Cannon.from_data(data.new_mounted_cannon_details)
		DataManager.player_data.cannon.erase(data.old_inventory_cannon_id)
		if data.has("new_inventory_cannon_id"):
			DataManager.player_data.cannon[data.new_inventory_cannon_id] = Cannon.from_data(data.new_inventory_cannon_details)
		initialize(player_ship_name)
	else:
		printerr("HTTP request failed with response code: " + str(response_code))
	http_request_object.clear()
