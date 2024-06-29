extends ColorRect

var available_cannon_mounts = []

@onready var pilot_texture = $MarginContainer/VBoxContainer/Control/PilotTexture

func initialize(pilot_name):
	var pilot_data = Pilot.data[pilot_name]
	pilot_texture.texture = pilot_data.texture
	set_visible(true)

func _on_close_button_pressed():
	set_visible(false)
