class_name Rewards extends Node

static func valor(level):
	return level * (2 + 0.2 * level) # 2x + 0.2x²
