extends Node

# const SERVER_URL = "https://earthling.se/shmup/"
const SERVER_URL = "http://localhost:3000/shmup/"

const HEADERS = ["Content-Type: application/json"]

func load_data(requesting_object):
	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	requesting_object.add_child(http_request)
	http_request.request_completed.connect(requesting_object._on_api_load_data_completed)

	var url = SERVER_URL + "player_data"

	# Prepare the request body
	var request_body = {"user_handle": DataManager.user_handle}
	var json_request_body = JSON.stringify(request_body)
	# Make the HTTP request
	var response = http_request.request(url, HEADERS, HTTPClient.METHOD_POST, json_request_body)

	if response != OK:
		printerr("An error occurred in the HTTP request:\n%s" % response)

func perform_exchange(requesting_object, asset_from, asset_to, amount_from):
	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	requesting_object.add_child(http_request)
	http_request.request_completed.connect(requesting_object._on_api_perform_exchange_completed)

	var url = SERVER_URL + "exchange"

	var request_body = {
		"user_handle": DataManager.user_handle,
		"asset_from": asset_from,
		"asset_to": asset_to,
		"amount_from": amount_from
	}

	var json_request_body = JSON.stringify(request_body)

	# Make the HTTP request
	var response = http_request.request(url, HEADERS, HTTPClient.METHOD_POST, json_request_body)

	if response != OK:
		printerr("An error occurred in the HTTP request:\n%s" % response)
