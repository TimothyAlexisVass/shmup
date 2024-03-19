extends ParallaxBackground

@onready var game = get_node('/root/Game')
@onready var space_background = get_node("-999/SpaceBackground")
@onready var scroll_offset_y = 0.0

func _ready():
	space_background.flip_h = Game.random_boolean()
	space_background.flip_v = Game.random_boolean()
	get_node("-999").motion_offset.y = randi() % int(space_background.texture.get_size().y)

func _process(delta):
	scroll_offset_y += 22 * delta
	scroll_offset.y = scroll_offset_y
	
	if is_instance_valid(game.player):
		scroll_offset.x = -(game.player.global_position.x - 555)/22
