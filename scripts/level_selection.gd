extends Node2D

const LEVEL_BUTTON_SCENE = preload("res://scenes/level_button.tscn")
const LEVEL_SCENE = preload("res://scenes/level.tscn")
const LINE_OFFSET = Vector2(100, 85)

var previous_x_position = 200
var line
var rng = RandomNumberGenerator.new()

func _enter_tree():
	G.level_selection = self

func _ready():
	var levels_data = DataManager.player_data.levels

	rng.seed = 1
	$Lines/Line2D.points.set(0, Vector2(0, 0))
	var button = $Levels/LevelButton
	var click_mask = BitMap.new()
	button.completion = levels_data["1"]
	button.initialize()
	click_mask.create_from_image_alpha(button.texture_normal.diffuse_texture.get_image())
	button.texture_click_mask = click_mask

	for i in range(2, Spawn.WAVE_TIER.size()+1):
		line = $Lines/Line2D.duplicate()
		line.set_visible(true)
		$Lines.add_child(line)
		button = LEVEL_BUTTON_SCENE.instantiate()
		button.level = i
		if levels_data.has(str(i)):
			button.completion = levels_data[str(i)]
		else:
			button.disabled = true
			button.get_node("Label").modulate = Color(0.2, 0.2, 0.2)
		$Levels.add_child(button)
		
		line.points[0] = Vector2(previous_x_position, 85 + (i - 2) * 200) + LINE_OFFSET
		button.position.x = rng.randi_range(200, 400) if previous_x_position > 440 else rng.randi_range(480, 680)
		previous_x_position = button.position.x
		button.position.y = 85 + (i-1) * 200
		line.points[1] = button.position + LINE_OFFSET
		button.texture_click_mask = click_mask
		
		button.get_node("Label").set_text(str(i))
		button.get_node("BackGlow").modulate = Color(0.2, 0.2, 0.2)
