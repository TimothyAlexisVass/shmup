extends Control

func _ready():
	hide_screens()
	for control in $ControlsBottom.get_children():
		if control is Button:
			control.connect("pressed", Callable(self, "select_screen").bind(control.name))
	for upgrade_button in $Screens/Commander/MarginContainer/VBoxContainer/Upgrades/Buttons.get_children():
		upgrade_button.connect("pressed", Callable(self, "level_up").bind(upgrade_button))
		set_upgrade_label(upgrade_button)

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

func set_upgrade_label(button):
	button.get_node("Label").set_text(str(DataManager.player_data.commander[String(button.name)]))
