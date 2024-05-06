extends Node2D

var level_scene = preload("res://scenes/level.tscn")
var previous_x_position = 200
var line
var rng = RandomNumberGenerator.new()

var level_buttons = []

const LINE_OFFSET = Vector2(100, 85)

func _ready():
	rng.seed = 1
	$Lines/Line2D.points.set(0, Vector2(0, 0))
	var button = $Levels/LevelButton
	var click_mask = BitMap.new()
	click_mask.create_from_image_alpha(button.texture_normal.diffuse_texture.get_image())
	button.texture_click_mask = click_mask
	level_buttons.append(button)

	for i in range(2, Spawn.WAVE_TIER.size()+1):
		line = $Lines/Line2D.duplicate()
		line.set_visible(true)
		$Lines.add_child(line)
		button = $Levels/LevelButton.duplicate()
		$Levels.add_child(button)
		button.level = i
		
		line.points[0] = Vector2(previous_x_position, 85 + (i - 2) * 200) + LINE_OFFSET
		button.position.x = rng.randi_range(200, 360) if previous_x_position > 400 else rng.randi_range(440, 600)
		previous_x_position = button.position.x
		button.position.y = 85 + (i-1) * 200
		line.points[1] = button.position + LINE_OFFSET
		button.disabled = true
		button.get_node("Label").set_text(str(i))
		button.get_node("Label").modulate = Color(0.2, 0.2, 0.2)
		button.get_node("BackGlow").modulate = Color(0.2, 0.2, 0.2)
		level_buttons.append(button)

	for level_button in level_buttons:
		level_button.connect("pressed", Callable(self, "play_level").bind(button))

func play_level(button):
	print("hello")
	var level_instance = level_scene.instantiate()
	level_instance.set("number", button.level)
	get_parent().add_child(level_instance)
	get_parent().remove_child(self)


