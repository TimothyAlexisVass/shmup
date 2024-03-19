extends Camera2D

@onready var game = get_node("/root/Game")

@onready var center = get_viewport().size / 2.0
@onready var camera_boundaries = {
	"x": { "min": center.x - Game.GAME_AREA_OFFSET_X, "max": center.x + Game.GAME_AREA_OFFSET_X},
	"y": { "min": center.y - Game.GAME_AREA_OFFSET_Y, "max": center.y + Game.GAME_AREA_OFFSET_Y}
}

func _process(_delta):
	if is_instance_valid(game.player):
		global_position = center - (center - game.player.global_position) * Vector2(0.28, 0.25)
		# global_position.x = clamp(global_position.x, camera_boundaries.x.min, camera_boundaries.x.max)
		# global_position.y = clamp(global_position.y, camera_boundaries.y.min, camera_boundaries.y.max)
