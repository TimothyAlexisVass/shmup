# node_classes/loading_http_request/loading_http_request.gd
class_name LoadingHTTPRequest extends HTTPRequest

const LOADING_INTERFACE_SCENE = preload("res://node_classes/loading_http_request/loading_interface.tscn")
const REQUEST_HEADERS = ["Content-Type: application/json"]
const MAXIMUM_RETRIES = 3

var request_backoff_time = 2

var retries_left = MAXIMUM_RETRIES
var time = 0
var load_square = 0
var opacity = 0
var reveal = false

var up = true

# Variables to store request parameters for retries
var request_url
var request_method = HTTPClient.METHOD_POST
var request_body
var callback_function

@onready var loading_interface = LOADING_INTERFACE_SCENE.instantiate()
@onready var loading_indicators = loading_interface.get_node("LoadingIndicators")
@onready var message = loading_interface.get_node("MessagePanel/LoadingMessage")
@onready var retry_button = loading_interface.get_node("MessagePanel/RetryButton")

func _ready():
	loading_interface.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	loading_interface.set_z_index(4096)
	add_child(loading_interface)
	request_completed.connect(_on_request_completed)
	retry_button.pressed.connect(_on_retry_button_pressed)
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
					tween.tween_property(loading_indicators.get_node("_" + str(i)), "modulate", Color(1, 1, 1.2, 1), 0.777)
			tween.tween_property(loading_indicators.get_node("_" + str(load_square)), "modulate", Color(1.5, 1.5, 1.5, 0.2), 0.777)
			time = 0
		else:
			reveal = true

	if reveal and opacity < 1:
		opacity = min(opacity + delta, 1)
		loading_interface.modulate = Color(1, 1, 1, opacity)

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
			message.text = "Loading data from server\nRetrying... Attempt: " + str(MAXIMUM_RETRIES - retries_left)
			await get_tree().create_timer(request_backoff_time).timeout
			perform_request()
			request_backoff_time *= 2
		else:
			message.text = "HTTP request failed after " + str(MAXIMUM_RETRIES) + " retries with response code: " + str(response_code)
			retries_left = 3
			retry_button.set_visible(true)
			loading_indicators.set_visible(false)

func _on_retry_button_pressed():
	perform_request()
	loading_indicators.set_visible(true)
	retry_button.set_visible(false)
	message.text = "Loading data from server"

func perform_request():
	request(request_url, REQUEST_HEADERS, request_method, request_body)

func clear():
	if opacity > 0:
		var tween = create_tween()
		tween.tween_property(loading_interface, "modulate", Color(1, 1, 1, 0), opacity * 0.5)
		await tween.finished
		queue_free()
	else:
		queue_free()
