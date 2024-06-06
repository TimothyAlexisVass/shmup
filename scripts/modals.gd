extends Control

func _ready():
	hide_screens()
	for control in $ControlsBottom.get_children():
		if control is Button:
			control.connect("pressed", Callable(self, "show_screen").bind(control.name))

func show_screen(screen_name):
	screen_name = String(screen_name).replace("Button", "")
	var screen = $Screens.get_node(screen_name)
	var show_screen = screen.visible == false
	hide_screens()
	if show_screen:
		screen.set_visible(true)
		$Screens.set_visible(true)
		$Screens/CloseButton.set_visible(true)

func hide_screens():
	$Screens.set_visible(false)
	for screen in $Screens.get_children():
		screen.set_visible(false)
