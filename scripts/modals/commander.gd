extends ColorRect

const UPGRADE_BUTTON_SCENE = preload("res://node_classes/button/upgrade_button.tscn")

@onready var name_line_edit = $MarginContainer/VBoxContainer/Details/Name/LineEdit

func _ready():
	ready_commander_details()
	ready_commander_upgrade_buttons()

func level_up(upgrade_button):
	DataManager.level_up("commander", upgrade_button.name)
	set_upgrade_value(upgrade_button)

func set_upgrade_value(upgrade_button):
	upgrade_button.get_node("TextureButton/Value").set_text(str(DataManager.player_data.commander[upgrade_button.name]))

func _on_name_changed(new_name):
	var filtered_name = DataManager.player_data.filter_invalid_characters(new_name)
	if name_line_edit.text == filtered_name:
		DataManager.player_data.set_commander_name(filtered_name)
	else:
		name_line_edit.text = filtered_name
		name_line_edit.caret_column = filtered_name.length()

# Initialization methods to set values from player data
func ready_commander_details():
	$MarginContainer/VBoxContainer/Details/Name/LineEdit.text = DataManager.player_data.commander["name"]
	$MarginContainer/VBoxContainer/Details/Rank/Value.text = str(DataManager.player_data.commander["rank"])

func ready_commander_upgrade_buttons():
	for upgrade in DataManager.player_data.commander.keys():
		if not upgrade.ends_with("_multiplier"): continue

		var upgrade_button_instance = UPGRADE_BUTTON_SCENE.instantiate()
		upgrade_button_instance.name = upgrade
		upgrade_button_instance.get_node("TextureButton/Label").text = "\n".join(upgrade.replace("_multiplier", "").split("_")).to_upper()
		set_upgrade_value(upgrade_button_instance)
		upgrade_button_instance.get_node("TextureButton").connect("pressed", Callable(self, "level_up").bind(upgrade_button_instance))
		$MarginContainer/VBoxContainer/Upgrades/Buttons.add_child(upgrade_button_instance)
