class_name OffScreenIndicator extends Sprite2D

@onready var parent = get_parent()

func _ready():
	parent.get_node("VisibleOnScreenEnabler2D").connect("screen_entered", _on_parent_entered_screen)
	parent.get_node("VisibleOnScreenEnabler2D").connect("screen_exited", _on_parent_exited_screen)

func _process(_delta):
	var camera_min = G.camera.get_min()
	var camera_max = G.camera.get_max()
	global_position.x = clamp(parent.global_position.x, camera_min.x, camera_max.x)
	global_position.y = clamp(parent.global_position.y, camera_min.y, camera_max.y)

	if G.camera.get_rect().has_point(parent.global_position):
		hide()

func _on_parent_entered_screen():
	hide()

func _on_parent_exited_screen():
	show()
