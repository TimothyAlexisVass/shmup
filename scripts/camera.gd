extends Camera2D

@onready var camera_position_factor = Vector2(G.GAME_AREA_OFFSET.x / (G.GAME_AREA_OFFSET.x + G.center.x), G.GAME_AREA_OFFSET.y / (G.GAME_AREA_OFFSET.y + G.center.y))

func _process(_delta):
	if is_instance_valid(G.player):
		global_position = G.center - camera_position_factor * (G.center - G.player.global_position)
