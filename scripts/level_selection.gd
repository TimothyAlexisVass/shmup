extends Node2D

var level_scene = preload("res://scenes/level.tscn")
var previous_x_position = 50

func _ready():
	var button = $Levels/LevelButton
	var click_mask = BitMap.new()
	click_mask.create_from_image_alpha(button.texture_normal.get_image())
	button.texture_click_mask = click_mask

	for i in range(1, Spawn.WAVE_TIER.size()+1):
		if i > 1:
			button = $Levels/LevelButton.duplicate()
			$Levels.add_child(button)
		button.level = i
		button.position.x = randi_range(200, 360) if previous_x_position > 400 else randi_range(440, 600)
		previous_x_position = button.position.x
		button.position.y = 85 + (i-1) * 200
		button.get_node("Label").set_text(str(i))
		button.connect("pressed", Callable(self, "play_level").bind(button))

func play_level(button):
	var level_instance = level_scene.instantiate()
	level_instance.set("number", button.level)
	get_parent().add_child(level_instance)
	get_parent().remove_child(self)


