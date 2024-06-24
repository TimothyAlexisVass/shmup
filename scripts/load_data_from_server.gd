extends TextureRect

var time = 0
var load_square = 0

signal data_loading_completed

func _ready():
	Api.load_data("test", self)

func _process(delta):
	time += delta
	if time >= 0.5:
		load_square = fmod(load_square + 1, 3)
		for i in range(3):
			get_node("Panel/_" + str(i)).modulate = Color(1, 1, 1, 0.4)
		get_node("Panel/_" + str(load_square)).modulate = Color(1, 1, 1, 0.8)
		time = 0

func _on_api_load_data_completed(_result: int, response_code: int, _headers: Array, body: PackedByteArray):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_ascii())
		DataManager.handle_loaded_data(json.get_data())
	else:
		printerr("HTTP request failed with response code: " + str(response_code))

	data_loading_completed.emit()
	queue_free()
