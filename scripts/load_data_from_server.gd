class_name LoadDataFromServer extends TextureRect

func _ready():
	_load_data()

func _on_api_load_data_completed(data, error_code = null):
	if error_code == null:
		DataManager.handle_loaded_data(data)
		Switch.to_level_selection()
		queue_free()
	else:
		$Panel/Label.text = "Request failed, response code: " + str(error_code) + "\n\n"
		$Panel/Retry.set_visible(true)

func _load_data():
	$Panel/Retry.set_visible(false)
	$Panel/Label.text = "Loading data from server\n...\n"
	Api.load_data(self)
