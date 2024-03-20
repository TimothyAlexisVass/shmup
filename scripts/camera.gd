extends Camera2D

@onready var game = get_node("/root/Game")

@onready var center = get_viewport().size / 2.0
@onready var camera_position_factor = Vector2(Game.GAME_AREA_OFFSET.x / (Game.GAME_AREA_OFFSET.x + center.x), Game.GAME_AREA_OFFSET.y / (Game.GAME_AREA_OFFSET.y + center.y))

func _ready():
	global_position = Vector2(540, 1140)

func _process(_delta):
	if is_instance_valid(game.player):
		global_position = center - camera_position_factor * (center - game.player.global_position)
