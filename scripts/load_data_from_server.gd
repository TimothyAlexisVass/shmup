class_name LoadDataFromServer extends TextureRect

func _ready():
	_load_data()

func _on_api_load_data_completed(_result: int, response_code: int, _headers: Array, body: PackedByteArray, http_request_object: LoadingHTTPRequest):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_ascii())
		DataManager.handle_loaded_data(json.get_data())
		Switch.to_level_selection()
		queue_free()
	else:
		$Panel/Label.text = "Request failed response code: " + str(response_code) + "\n\n"
		$Panel/Retry.set_visible(true)
	http_request_object.clear()

func _load_data():
	$Panel/Retry.set_visible(false)
	$Panel/Label.text = "Loading data from server\n...\n"
	Api.load_data(self)
