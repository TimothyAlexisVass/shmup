extends Node

const SERVER_URL = "http://127.0.0.1:5000/"

func load_data(user_id: String, load_data_from_server_object):
	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	load_data_from_server_object.add_child(http_request)
	http_request.request_completed.connect(load_data_from_server_object._on_api_load_data_completed)

	var url = SERVER_URL + "player_data"

	# Prepare the request body
	var request_body = {"user_id": user_id}
	var json_request_body = JSON.stringify(request_body)
	var headers = ["Content-Type: application/json"]
	# Make the HTTP request
	var response = http_request.request(url, headers, HTTPClient.METHOD_POST, json_request_body)

	if response != OK:
		printerr("An error occurred in the HTTP request:\n%s" % response)
