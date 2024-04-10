extends Control

var level_scene = preload("res://scenes/level.tscn")

func _ready():
	for i in range(1, 556):
		var button
		if i > 1:
			button = $ScrollContainer/VBoxContainer/LevelButton.duplicate()
			button.set_disabled(true)
			$ScrollContainer/VBoxContainer.add_child(button)
		else:
			button = $ScrollContainer/VBoxContainer/LevelButton
		button.level = i
		button.set_text("Level "+str(i))
		button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))

func _on_button_pressed(button):
	var level_instance = level_scene.instantiate()
	level_instance.set("number", button.level)
	get_tree().get_root().add_child(level_instance)
	get_tree().current_scene = level_instance
	get_tree().get_root().remove_child(self.owner)
