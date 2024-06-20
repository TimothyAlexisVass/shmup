extends TextureButton

enum COMPLETION {NONE, CUPRUM_1, CUPRUM_2, CUPRUM_3, ARGENTUM_1, ARGENTUM_2, ARGENTUM_3, AURUM_1, AURUM_2, AURUM_3, PINNACLE}

const badge = {
	COMPLETION.NONE: preload("res://media/sprites/level_badges/level.png"),
	COMPLETION.CUPRUM_1: preload("res://media/sprites/level_badges/cuprum_1.png"),
	COMPLETION.CUPRUM_2: preload("res://media/sprites/level_badges/cuprum_2.png"),
	COMPLETION.CUPRUM_3: preload("res://media/sprites/level_badges/cuprum_3.png"),
	COMPLETION.ARGENTUM_1: preload("res://media/sprites/level_badges/argentum_1.png"),
	COMPLETION.ARGENTUM_2: preload("res://media/sprites/level_badges/argentum_2.png"),
	COMPLETION.ARGENTUM_3: preload("res://media/sprites/level_badges/argentum_3.png"),
	COMPLETION.AURUM_1: preload("res://media/sprites/level_badges/aurum_1.png"),
	COMPLETION.AURUM_2: preload("res://media/sprites/level_badges/aurum_2.png"),
	COMPLETION.AURUM_3: preload("res://media/sprites/level_badges/aurum_3.png"),
	COMPLETION.PINNACLE: preload("res://media/sprites/level_badges/pinnacle.png"),
}

var label_circles = {
	"CUPRUM": preload("res://media/sprites/level_badges/cuprum_circle.png"),
	"ARGENTUM": preload("res://media/sprites/level_badges/argentum_circle.png"),
	"AURUM": preload("res://media/sprites/level_badges/aurum_circle.png"),
	"PINNACLE": preload("res://media/sprites/level_badges/pinnacle_circle.png"),
}

@export var level: int = 1
@export var completion: COMPLETION = COMPLETION.NONE

var challenge

func _ready():
	initialize()

func initialize():
	challenge = int((completion+3)/3.0)-1
	texture_normal.diffuse_texture = badge[completion]
	if completion > 0:
		$Label.position.y += 855 if completion > 6 else 677
		$Label/Circle.set_visible(true)
		$Label/Circle.set_texture(label_circles[COMPLETION.keys()[completion].split("_")[0]])

func _on_pressed():
	Switch.to_level(level, challenge)
