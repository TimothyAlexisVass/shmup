class_name LoadingHTTPRequest extends HTTPRequest

const LOADING_ANIMATION_SCENE = preload("res://node_classes/loading_http_request/loading_animation.tscn")

var loading_animation

var time = 0
var load_square = 0
var opacity = 0

func _enter_tree():
	loading_animation = LOADING_ANIMATION_SCENE.instantiate()
	loading_animation.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	loading_animation.set_z_index(4096)
	add_child(loading_animation)

func _process(delta):
	time += delta
	if time > 0.777 && opacity < 1:
		opacity = min(opacity + delta, 1)
		loading_animation.modulate = Color(1, 1, 1, opacity)

	if time >= 0.5 && opacity == 1:
		load_square = fmod(load_square + 1, 5)
		for i in range(5):
			loading_animation.get_node("_" + str(i)).modulate = Color(1, 1, 1, 0.4)
		loading_animation.get_node("_" + str(load_square)).modulate = Color(1, 1, 1, 0.8)
		time = 0
	
