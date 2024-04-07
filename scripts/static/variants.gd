class_name Variants extends Node

static func generate(input_array: Array, combination_size: int) -> Array:
	var variants = []
	combinations([], 0, combination_size, input_array, variants)
	return variants

# Function to generate combinations recursively
static func combinations(current_combination: Array, start_index: int, size_left: int, input_array: Array, variants: Array):
	if size_left == 0:
		# Sort the combination
		current_combination.sort()
		# Check if the combination is unique
		if not variants.has(current_combination):
			# Add the combination to the list if it's unique
			variants.append(current_combination)
		return

	# Recursively generate combinations
	for i in range(start_index, input_array.size()):
		var new_combination = current_combination + [input_array[i]]
		combinations(new_combination, i + 1, size_left - 1, input_array, variants)

"""
Formation:
mirror (spawn both sides at the same time)
mirror_alternate (spawn one side, then the other)
with_mid (spawn symmetrically with the 0-point)
back_forth (flow back and forth between the spawn points)
zig_zag (change sign of every other element)

1:[
	[0],
	[1],
	[2],
	[3],
	[4],
	[5]
],
2:[
	[1, 2],
	[1, 3],
	[1, 4],
	[1, 5],
	[2, 3],
	[2, 4],
	[2, 5],
	[3, 4],
	[3, 5],
	[4, 5]
],
3:[
	[1, 2, 3],
	[1, 2, 4],
	[1, 2, 5],
	[1, 3, 4],
	[1, 3, 5],
	[1, 4, 5],
	[2, 3, 4],
	[2, 3, 5],
	[2, 4, 5],
	[3, 4, 5]
],
4:[
	[1, 2, 3, 4],
	[1, 2, 3, 5],
	[1, 2, 4, 5],
	[1, 3, 4, 5],
	[2, 3, 4, 5]
],
5:[
	[1, 2, 3, 4, 5]
]

Spawn points: -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5
"""
