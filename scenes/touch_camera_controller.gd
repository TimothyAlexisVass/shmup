extends Camera2D

const PAN_SPEED = 2

@onready var max_position_y = Spawn.WAVE_TIER.size() * 200 - 777
@onready var initial_position = position

func _input(event):
	if event is InputEventScreenDrag:
		var distance = event.relative.y * PAN_SPEED
		position.y -= distance
		position.y = clamp(position.y, initial_position.y, max_position_y)
