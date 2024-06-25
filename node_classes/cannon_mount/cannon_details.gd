class_name CannonDetails extends Resource
@export var rarity: G.RARITY
@export var shot_scene: PackedScene = preload("res://scenes/shots/plasma.tscn")
@export var shot_rate: PackedFloat32Array = [1.0]
@export var shot_speed: float = 500.0
@export var shot_power: float = 1.0
@export var shot_color: Color = Color(1, 1, 1, 1)
@export var shot_duration: float = 0.0
@export var shot_spread: float = 0.0
@export var homing_amount: float = 0.0
@export_enum("None", "Closest", "Least_HP", "Most_HP", "Choice") var homing_priority: String = "None"
@export var penetration_chance: float = 0.0
var penetration_count = 1 if penetration_chance > 0 else 0
@export var ricochet_count: int = 0
@export var falloff_rate: float = 0.5
@export var area_of_impact: float = 0.0
@export var perfect_chance: float = 0.0
@export var perfect_multiplier: float = 1.0
@export_enum("None", "Radiation", "Burn") var dot_effect: String = "None"
@export var dot_duration: float = 0
