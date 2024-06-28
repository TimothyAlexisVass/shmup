extends Control

func _enter_tree():
	G.modals = self

func _ready():
	hide_screens()
	ready_controls_bottom()

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

func ready_controls_bottom():
	for control in $ControlsBottom.get_children():
		if control is Button:
			control.connect("pressed", Callable(self, "select_screen").bind(control.name))
