extends ColorRect

const ASSET_BUTTON_SCENE = preload("res://node_classes/button/asset_button.tscn")

@onready var asset_list = $MarginContainer/VBoxContainer/Assets/List

var asset_values = {}

func _ready():
	add_asset_buttons()

func add_asset_buttons():
	for asset_data in Asset.all:
		var asset_button_instance = ASSET_BUTTON_SCENE.instantiate()
		var texture_button = asset_button_instance.get_node("TextureButton")
		texture_button.texture_normal = asset_data.texture
		texture_button.get_node("Label").text = asset_data.name
		asset_values[asset_data.name] = texture_button.get_node("Value")
		texture_button.name = asset_data.name
		asset_list.add_child(asset_button_instance)
		asset_list.move_child(asset_button_instance, 0)
	update_asset_values()

func update_asset_values():
	for asset_name in DataManager.player_data.asset:
		asset_values[asset_name].text = G.display_weight(DataManager.player_data.asset[asset_name])
