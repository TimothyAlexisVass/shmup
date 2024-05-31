extends TextureButton

enum COMPLETION {NONE, BRONZE_1, BRONZE_2, BRONZE_3, SILVER_1, SILVER_2, SILVER_3, GOLD_1, GOLD_2, GOLD_3, PINNACLE}

const badge = {
	COMPLETION.NONE: preload("res://assets/sprites/level_badges/level.png"),
	COMPLETION.BRONZE_1: preload("res://assets/sprites/level_badges/bronze_1.png"),
	COMPLETION.BRONZE_2: preload("res://assets/sprites/level_badges/bronze_2.png"),
	COMPLETION.BRONZE_3: preload("res://assets/sprites/level_badges/bronze_3.png"),
	COMPLETION.SILVER_1: preload("res://assets/sprites/level_badges/silver_1.png"),
	COMPLETION.SILVER_2: preload("res://assets/sprites/level_badges/silver_2.png"),
	COMPLETION.SILVER_3: preload("res://assets/sprites/level_badges/silver_3.png"),
	COMPLETION.GOLD_1: preload("res://assets/sprites/level_badges/gold_1.png"),
	COMPLETION.GOLD_2: preload("res://assets/sprites/level_badges/gold_2.png"),
	COMPLETION.GOLD_3: preload("res://assets/sprites/level_badges/gold_3.png"),
	COMPLETION.PINNACLE: preload("res://assets/sprites/level_badges/pinnacle.png"),
}

@export var level: int = 1
@export var completion: COMPLETION = COMPLETION.NONE

var challenge

func _ready():
	initialize()

func initialize():
	challenge = int((completion+3)/3.0)-1
	texture_normal.diffuse_texture = badge[completion]
