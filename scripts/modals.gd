extends Control

const ASSET_BUTTON_SCENE = preload("res://node_classes/button/asset_button.tscn")
const UPGRADE_BUTTON_SCENE = preload("res://node_classes/button/upgrade_button.tscn")

@onready var asset_list = $Screens/Market/MarginContainer/VBoxContainer/Assets/List

var asset_values = {}

func _enter_tree():
	G.modals = self

func _ready():
	hide_screens()
	ready_commander_details()
	ready_commander_upgrade_buttons()
	ready_controls_bottom()
	add_asset_buttons()

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
	DataManager.level_up("commander", upgrade_button.name)
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

		var upgrade_button_instance = UPGRADE_BUTTON_SCENE.instantiate()
		upgrade_button_instance.name = upgrade
		upgrade_button_instance.get_node("TextureButton/Label").text = "\n".join(upgrade.replace("_multiplier", "").split("_")).to_upper()
		set_upgrade_value(upgrade_button_instance)
		upgrade_button_instance.get_node("TextureButton").connect("pressed", Callable(self, "level_up").bind(upgrade_button_instance))
		$Screens/Commander/MarginContainer/VBoxContainer/Upgrades/Buttons.add_child(upgrade_button_instance)

func add_asset_buttons():
	for asset_data in Asset.all:
		var asset_button_instance = ASSET_BUTTON_SCENE.instantiate()
		var texture_button = asset_button_instance.get_node("TextureButton")
		texture_button.texture_normal = asset_data.texture
		texture_button.get_node("Label").text = asset_data.name
		asset_values[asset_data.name] = texture_button.get_node("Value")
		texture_button.name = asset_data.name
		asset_list.add_child(asset_button_instance)
		asset_list.move_child(asset_button_instance, 0)
	update_asset_values()

func update_asset_values():
	for asset_name in DataManager.player_data.asset:
		asset_values[asset_name].text = G.display_weight(DataManager.player_data.asset[asset_name])
