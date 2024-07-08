class_name LoadingHTTPRequest extends HTTPRequest

const LOADING_ANIMATION_SCENE = preload("res://node_classes/loading_http_request/loading_animation.tscn")

var loading_animation

var time = 0
var load_square = 0
var opacity = 0
var reveal = false

var up = true

func _ready():
	loading_animation = LOADING_ANIMATION_SCENE.instantiate()
	loading_animation.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	loading_animation.set_z_index(4096)
	add_child(loading_animation)

func _process(delta):
	time += delta
	if time > 0.777:
		if reveal:
			load_square = load_square + 1 if up else load_square - 1
			if load_square >= 4:
				up = false
			if load_square <= 0:
				up = true
			var tween = create_tween()
			tween.set_parallel()
			for i in range(5):
				if i != fmod(load_square - 1 if up else load_square + 1, 5):
					tween.tween_property(loading_animation.get_node("_" + str(i)), "modulate", Color(1, 1, 1.2, 1), 0.777)
			tween.tween_property(loading_animation.get_node("_" + str(load_square)), "modulate", Color(1.5, 1.5, 1.5, 0.2), 0.777)
			time = 0
		else:
			reveal = true

	if reveal and opacity < 1:
		opacity = min(opacity + delta, 1)
		loading_animation.modulate = Color(1, 1, 1, opacity)

func clear():
	if opacity > 0:
		var tween = create_tween()
		tween.tween_property(loading_animation, "modulate", Color(1, 1, 1, 0), opacity * 0.5)
		await tween.finished
		queue_free()
	else:
		queue_free()
