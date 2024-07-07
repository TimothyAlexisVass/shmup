extends Node2D

func _enter_tree():
	G.shmup = self

func show_level_selection():
	add_child(Switch.level_selection)
