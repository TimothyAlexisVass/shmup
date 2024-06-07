extends Control

func _ready():
	hide_screens()
	ready_commander_details()
	ready_controls_bottom()
	ready_upgrade_buttons()

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
	DataManager.level_up(String(upgrade_button.name))
	set_upgrade_label(upgrade_button)

func _on_name_changed(new_name):
	var name_line_edit = $Screens/Commander/MarginContainer/VBoxContainer/Details/Name/LineEdit
	var filtered_name = DataManager.player_data.filter_invalid_characters(new_name)
	if name_line_edit.text == filtered_name:
		DataManager.player_data.set_commander_name(filtered_name)
	else:
		name_line_edit.text = filtered_name
		name_line_edit.caret_column = filtered_name.length()

func set_upgrade_label(button):
	button.get_node("Label").set_text(str(DataManager.player_data.commander[String(button.name)]))

# Initialization methods to set values from player data
func ready_commander_details():
	$Screens/Commander/MarginContainer/VBoxContainer/Details/Name/LineEdit.text = DataManager.player_data.commander["name"]
	$Screens/Commander/MarginContainer/VBoxContainer/Details/Rank/Value.text = str(DataManager.player_data.commander["rank"])

func ready_controls_bottom():
	for control in $ControlsBottom.get_children():
		if control is Button:
			control.connect("pressed", Callable(self, "select_screen").bind(control.name))

func ready_upgrade_buttons():
	for upgrade_button in $Screens/Commander/MarginContainer/VBoxContainer/Upgrades/Buttons.get_children():
		upgrade_button.connect("pressed", Callable(self, "level_up").bind(upgrade_button))
		set_upgrade_label(upgrade_button)
