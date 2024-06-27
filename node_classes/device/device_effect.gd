class_name DeviceEffect extends Resource
enum TARGET {SELF, RANDOM_OTHER, SHOT_TARGET}
enum EFFECT {BOOST}
@export var area_of_effect: int = 0
@export var duration: float = 0.0
@export var cooldown: float = 0.0
@export var autocast: bool = true
@export var cast_rate: PackedFloat32Array = [0.1]
@export var target: TARGET = TARGET.SELF
@export var graze_power_required: int = 0
@export var base_value: float = 0.05
@export var effect: EFFECT = EFFECT.BOOST
@export_enum("shot_rate", "shot_power", "perfect_multiplier") var stat = "shot_rate"
