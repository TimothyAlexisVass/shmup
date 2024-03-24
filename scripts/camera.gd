extends Camera2D

@onready var game = get_node("/root/Game")

@onready var camera_position_factor = Vector2(Globals.GAME_AREA_OFFSET.x / (Globals.GAME_AREA_OFFSET.x + Globals.center.x), Globals.GAME_AREA_OFFSET.y / (Globals.GAME_AREA_OFFSET.y + Globals.center.y))

func _process(_delta):
	if is_instance_valid(game.player):
		global_position = Globals.center - camera_position_factor * (Globals.center - game.player.global_position)
