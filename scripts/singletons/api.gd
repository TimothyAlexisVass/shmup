extends Node

const SERVER_URL = "https://your.server/api/"

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	http_request.timeout = 30  # Set timeout as needed

func load_data(user_id: int) -> Dictionary:
	var url = SERVER_URL + "load_data/" + str(user_id)
	http_request.url = url
	http_request.method = HTTPClient.METHOD_GET
	
	http_request.request_headers["Content-Type"] = "application/json"
	
	http_request.wait_for_response()
	
	if http_request.get_response_code() == HTTPClient.RESPONSE_OK:
		var response = http_request.get_response_body_as_text()
		return JSON.parse_string(response)
	else:
		printerr("HTTP request failed: " + str(http_request.get_response_code()))
		return {}
