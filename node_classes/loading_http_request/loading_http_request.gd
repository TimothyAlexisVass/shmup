# node_classes/loading_http_request/loading_http_request.gd
class_name LoadingHTTPRequest extends HTTPRequest

const LOADING_ANIMATION_SCENE = preload("res://node_classes/loading_http_request/loading_animation.tscn")
const REQUEST_HEADERS = ["Content-Type: application/json"]
const MAXIMUM_RETRIES = 3

var loading_animation

var request_backoff_time = 2

var retries_left = MAXIMUM_RETRIES
var time = 0
var load_square = 0
var opacity = 0
var reveal = false

var up = true

# Variables to store request parameters for retry
var request_url
var request_method = HTTPClient.METHOD_POST
var request_body
var callback_function

func _ready():
	loading_animation = LOADING_ANIMATION_SCENE.instantiate()
	loading_animation.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	loading_animation.set_z_index(4096)
	add_child(loading_animation)
	request_completed.connect(_on_request_completed)
	perform_request()

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

func _on_request_completed(_result: int, response_code: int, _headers: Array, body: PackedByteArray):
	if str(response_code).begins_with("2"):
		if callback_function:
			var json = JSON.new()
			json.parse(body.get_string_from_ascii())
			callback_function.call(json.get_data())
			clear()
	else:
		if retries_left > 0:
			retries_left -= 1
			await get_tree().create_timer(request_backoff_time).timeout
			perform_request()
			request_backoff_time *= 2
		else:
			printerr("HTTP request failed after ", MAXIMUM_RETRIES, " retries with response code: ", response_code)
			callback_function.call(null, response_code)
			clear()

func perform_request():
	print("Retrying... Attempts left: ", retries_left)
	request(request_url, REQUEST_HEADERS, request_method, request_body)

func clear():
	if opacity > 0:
		var tween = create_tween()
		tween.tween_property(loading_animation, "modulate", Color(1, 1, 1, 0), opacity * 0.5)
		await tween.finished
		queue_free()
	else:
		queue_free()
