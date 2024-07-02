extends Node

# const SERVER_URL = "https://earthling.se/shmup/"
const SERVER_URL = "http://localhost:3000/shmup/"
const HEADERS = ["Content-Type: application/json"]

func _make_request(requesting_object, endpoint, request_body, callback_method):
	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	requesting_object.add_child(http_request)
	http_request.request_completed.connect(Callable(requesting_object, callback_method).bind(http_request))

	var url = SERVER_URL + endpoint
	var json_request_body = JSON.stringify(request_body)

	# Make the HTTP request
	var response = http_request.request(url, HEADERS, HTTPClient.METHOD_POST, json_request_body)

	if response != OK:
		printerr("An error occurred in the HTTP request:\n%s" % response)

func _queue_free_wrapper(http_request):
	http_request.queue_free()

func load_data(requesting_object):
	var request_body = {"user_handle": DataManager.user_handle}
	_make_request(requesting_object, "player_data", request_body, "_on_api_load_data_completed")

func perform_exchange(requesting_object, asset_from, asset_to, amount_from):
	var request_body = {
		"user_handle": DataManager.user_handle,
		"asset_from": asset_from,
		"asset_to": asset_to,
		"amount_from": amount_from
	}
	_make_request(requesting_object, "exchange", request_body, "_on_api_perform_exchange_completed")
