extends Camera2D

@onready var camera_position_factor = Vector2(G.GAME_AREA_OFFSET.x / (G.GAME_AREA_OFFSET.x + G.center.x), G.GAME_AREA_OFFSET.y / (G.GAME_AREA_OFFSET.y + G.center.y))

func _enter_tree():
	G.camera = self
	global_position = G.center

func _physics_process(_delta):
	if is_instance_valid(G.player) && G.player.is_playing:
		global_position = G.center - camera_position_factor * (G.center - G.player.global_position)
	else:
		global_position = G.center

func get_rect() -> Rect2:
	return Rect2(get_min(), get_max())

func get_min():
	return global_position - G.center
	
func get_max():
	return global_position + G.center
