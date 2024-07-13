extends Node2D

const PAN_SPEED = 2

@onready var min_position_y = -Spawn.WAVE_TIER.size() * 196 - 777
@onready var initial_position = position

func _unhandled_input(event):
	if event is InputEventScreenDrag:
		var distance = event.relative.y * PAN_SPEED
		position.y += distance
		position.y = clamp(position.y, min_position_y, initial_position.y)
