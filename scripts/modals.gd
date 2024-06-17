extends Control

var resource_button_scene = preload("res://node_classes/button/resource_button.tscn")
var upgrade_button_scene = preload("res://node_classes/button/upgrade_button.tscn")

@onready var resource_list = $Screens/Market/MarginContainer/VBoxContainer/Resources/List

var resource_values = {}

func _enter_tree():
	G.modals = self

func _ready():
	hide_screens()
	ready_commander_details()
	ready_commander_upgrade_buttons()
	ready_controls_bottom()
	add_resource_buttons()

func select_screen(screen_name):
	var screen = $Screens.get_node(String(screen_name))
	var show_screen = (screen.visible == false)
	hide_screens()
	if show_screen:
		screen.set_visible(true)
		$Screens.set_visible(true)
		$Screens/CloseButton.set_visible(true)

func hide_screens():
	$Screens.set_visible(false)
	for screen in $Screens.get_children():
		screen.set_visible(false)

func level_up(upgrade_button):
	DataManager.level_up(upgrade_button.name)
	set_upgrade_value(upgrade_button)

func set_upgrade_value(upgrade_button):
	upgrade_button.get_node("TextureButton/Value").set_text(str(DataManager.player_data.commander[upgrade_button.name]))

func _on_name_changed(new_name):
	var name_line_edit = $Screens/Commander/MarginContainer/VBoxContainer/Details/Name/LineEdit
	var filtered_name = DataManager.player_data.filter_invalid_characters(new_name)
	if name_line_edit.text == filtered_name:
		DataManager.player_data.set_commander_name(filtered_name)
	else:
		name_line_edit.text = filtered_name
		name_line_edit.caret_column = filtered_name.length()

# Initialization methods to set values from player data
func ready_commander_details():
	$Screens/Commander/MarginContainer/VBoxContainer/Details/Name/LineEdit.text = DataManager.player_data.commander["name"]
	$Screens/Commander/MarginContainer/VBoxContainer/Details/Rank/Value.text = str(DataManager.player_data.commander["rank"])

func ready_controls_bottom():
	for control in $ControlsBottom.get_children():
		if control is Button:
			control.connect("pressed", Callable(self, "select_screen").bind(control.name))

func ready_commander_upgrade_buttons():
	for upgrade in DataManager.player_data.commander.keys():
		if not upgrade.ends_with("_multiplier"): continue

		var upgrade_button_instance = upgrade_button_scene.instantiate()
		upgrade_button_instance.name = upgrade
		upgrade_button_instance.get_node("TextureButton/Label").text = "\n".join(upgrade.replace("_multiplier", "").split("_")).to_upper()
		set_upgrade_value(upgrade_button_instance)
		upgrade_button_instance.get_node("TextureButton").connect("pressed", Callable(self, "level_up").bind(upgrade_button_instance))
		$Screens/Commander/MarginContainer/VBoxContainer/Upgrades/Buttons.add_child(upgrade_button_instance)

func add_resource_buttons():
	for resource in Stuff.RESOURCE:
		var resource_data = Stuff.resources[Stuff.RESOURCE[resource]]
		var resource_button_instance = resource_button_scene.instantiate()
		var texture_button = resource_button_instance.get_node("TextureButton")
		texture_button.texture_normal = resource_data.texture
		texture_button.get_node("Label").text = resource
		resource_values[resource] = texture_button.get_node("Value")
		texture_button.name = resource
		resource_list.add_child(resource_button_instance)
		resource_list.move_child(resource_button_instance, 0)
	update_resource_values()

func update_resource_values():
	for resource in DataManager.player_data.resources:
		resource_values[resource].text = G.display_weight(DataManager.player_data.resources[resource])
