extends Node

const SERVER_URL = "http://127.0.0.1:5000/"

var http_request = HTTPRequest.new()

func _enter_tree():
	http_request.timeout = 30  # Set timeout as needed
	get_tree().root.add_child.call_deferred(http_request)
	http_request.request_completed.connect(self._http_request_completed)

func load_data(user_id: String):
	var url = SERVER_URL + "player_data"

	# Prepare the request body
	var request_body = {"user_id": user_id}
	var json_request_body = JSON.stringify(request_body)
	var headers = ["Content-Type: application/json"]
	# Make the HTTP request
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, json_request_body)

	if err != OK:
		print("An error occurred in the HTTP request: %s" % err)

# Callback function for request completion
func _http_request_completed(result: int, response_code: int, _headers: Array, body: PackedByteArray):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_ascii())
		var response = json.get_data()

		print(response)
	else:
		print("HTTP request failed with response code: %d" % response_code)
