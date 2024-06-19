class_name Cannon extends Resource
@export var shot_scene: PackedScene = preload("res://scenes/shots/plasma.tscn")
@export var shot_rate: PackedFloat32Array = [1.0]
@export var shot_speed: float = 500.0
@export var shot_power: float = 1.0
@export var shot_color: Color = Color(1, 1, 1, 1)
