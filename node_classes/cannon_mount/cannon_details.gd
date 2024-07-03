class_name CannonDetails extends Resource
var level: int = 0
@export var name: String = "Cannon"
@export var rarity: G.RARITY = G.RARITY.COMMON
@export var shot_type: String = "Plasma"
@export var shot_scene: PackedScene = preload("res://scenes/shots/Plasma.tscn")
@export var shot_rate: PackedFloat32Array = [1.0]
@export var shot_speed: float = 500.0
@export var shot_power: float = 1.0
@export var shot_color: Color = Color(1, 1, 1, 1)
@export var shot_duration: float = 0.0
@export var shot_spread: float = 0.0
@export var homing_amount: float = 0.0
@export var homing_priority: Cannon.HOMING_PRIORITY = Cannon.HOMING_PRIORITY.RANDOM
@export var penetration_chance: float = 0.0
var penetration_count = 1 if penetration_chance > 0 else 0
@export var ricochet_count: int = 0
@export var falloff_rate: float = 0.5
@export var area_of_impact: float = 0.0
@export var perfect_chance: float = 0.0
@export var perfect_multiplier: float = 1.0
@export var dot_effect: Cannon.DOT_EFFECT = Cannon.DOT_EFFECT.NONE
@export var dot_duration: float = 0

func data():
	return {
		"level": level,
		"rarity": rarity,
		"shot_type": shot_type,
		"shot_rate": shot_rate,
		"shot_speed": shot_speed,
		"shot_power": shot_power,
		"shot_color": shot_color.to_html(true),
		"shot_duration": shot_duration,
		"shot_spread": shot_spread,
		"homing_amount": homing_amount,
		"homing_priority": homing_priority,
		"penetration_chance": penetration_chance,
		"penetration_count": penetration_count,
		"ricochet_count": ricochet_count,
		"falloff_rate": falloff_rate,
		"area_of_impact": area_of_impact,
		"perfect_chance": perfect_chance,
		"perfect_multiplier": perfect_multiplier,
		"dot_effect": dot_effect,
		"dot_duration": dot_duration
	}
