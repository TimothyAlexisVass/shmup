extends Node

# const SERVER_URL = "https://earthling.se/shmup/"
const SERVER_URL = "http://localhost:3000/shmup/"

var time = 0
func _physics_process(delta):
	time += delta
	if time >= 5 and asset_change.size() > 0:
		time = 0
		change_assets()

func _make_request(endpoint, request_body, callback_function):
	request_body["user_handle"] = DataManager.user_handle

	var http_request = LoadingHTTPRequest.new()
	http_request.timeout = 30
	http_request.request_url = SERVER_URL + endpoint
	http_request.request_body = JSON.stringify(request_body)
	http_request.callback_function = callback_function
	G.popup_overlay.add_child(http_request)

func load_data(requesting_object):
	var endpoint = "player_data"
	var request_body = {}
	var callback_function = Callable(requesting_object, "_on_api_load_data_completed")
	_make_request(endpoint, request_body, callback_function)

func select(requesting_object, selection_type, selection_name):
	var endpoint = "select"
	var request_body = {
		"selection_type": selection_type,
		"selection_name": selection_name
	}
	var callback_function = Callable(requesting_object, "_on_api_select_completed")
	_make_request(endpoint, request_body, callback_function)

func mount_cannon(requesting_object, player_ship_name, cannon_mount_name, inventory_cannon_id):
	var endpoint = "mount_cannon"
	var request_body = {
		"player_ship_name": player_ship_name,
		"cannon_mount_name": cannon_mount_name,
		"inventory_cannon_id": inventory_cannon_id
	}
	var callback_function = Callable(requesting_object, "_on_api_mount_cannon_completed")
	_make_request(endpoint, request_body, callback_function)

var asset_change = {}

func change_asset(asset_name, amount):
	asset_change[asset_name] = asset_change.get(asset_name, 0) + amount

func change_assets():
	var endpoint = "change_assets"
	var request_body = {"changes": asset_change}
	var callback_function = Callable(self, "_on_api_change_assets_completed")
	_make_request(endpoint, request_body, callback_function)
	asset_change = {}

func perform_exchange(asset_from, asset_to, amount_from):
	var endpoint = "exchange"
	var request_body = {
		"asset_from": asset_from,
		"asset_to": asset_to,
		"amount_from": amount_from
	}
	var callback_function = Callable(self, "_on_api_perform_exchange_completed")
	_make_request(endpoint, request_body, callback_function)

func _on_api_change_assets_completed(_result: int, response_code: int, _headers: Array, body: PackedByteArray, http_request_object: LoadingHTTPRequest):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_ascii())
		DataManager.set_assets(json.get_data())
	else:
		printerr("HTTP request failed with response code: " + str(response_code))
	http_request_object.clear()

func _on_api_perform_exchange_completed(_result: int, response_code: int, _headers: Array, body: PackedByteArray, http_request_object: LoadingHTTPRequest):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_ascii())
		DataManager.set_assets(json.get_data())
		G.market.update_asset_values()
	else:
		printerr("HTTP request failed with response code: " + str(response_code))
	http_request_object.clear()
