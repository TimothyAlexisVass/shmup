extends ParallaxBackground

@onready var space_background = get_node("-999/SpaceBackground")
@onready var scroll_offset_y = 0.0

func _ready():
	space_background.flip_h = G.random_boolean()
	space_background.flip_v = G.random_boolean()
	get_node("-999").motion_offset.y = randi() % int(space_background.texture.get_size().y)

func _process(delta):
	scroll_offset_y += 22 * delta
	scroll_offset.y = scroll_offset_y
	
	if is_instance_valid(G.player):
		scroll_offset.x = -(G.player.global_position.x)/22
