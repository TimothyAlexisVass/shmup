extends Node

var current_scene = null

var level_selection_scene = preload("res://scenes/level_selection.tscn")
var level_scene = preload("res://scenes/level.tscn")

@onready var level_selection = level_selection_scene.instantiate()

@onready var root = get_tree().root
@onready var shmup = root.get_node("Shmup")

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		Switch.to_level_selection()

func to_level_selection():
	if not shmup.get_node_or_null("LevelSelection"):
		call_deferred("_deferred_to_level_selection")

func to_level(level_number):
	if not shmup.get_node_or_null("Level"):
		call_deferred("_deferred_to_level", level_number)

func clear_shmup():
	for node in shmup.get_children():
		if node is Level:
			node.free()
		elif not node is WorldEnvironment:
			shmup.remove_child(node)

func _deferred_to_level_selection():
	clear_shmup()
	shmup.add_child(level_selection)

func _deferred_to_level(level_number):
	clear_shmup()
	var level = level_scene.instantiate()
	level.number = level_number
	shmup.add_child(level)
