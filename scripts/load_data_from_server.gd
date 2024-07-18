class_name LoadDataFromServer extends TextureRect

func _ready():
	_load_data()

func _on_api_load_data_completed(data, error_code = null):
	if error_code == null:
		DataManager.handle_loaded_data(data)
		Switch.to_level_selection()
		queue_free()

func _load_data():
	Api.load_data(self)
