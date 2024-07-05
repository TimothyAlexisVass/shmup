class_name ItemsGrid extends GridContainer

@export_enum("pilot", "player_ship") var item_type: String

@onready var database = G.database(item_type)

const GRID_ITEM_SCENE = preload("res://node_classes/items_grid/grid_item.tscn")

const SCREEN_NAME = {
	"pilot": "PilotDetails",
	"player_ship": "ShipDetails"
}

@onready var details_screen = G.modals.get_node("Screens/" + SCREEN_NAME[item_type])

func _ready():
	for int_tier in range(21):
		for item_name in database.tier(int_tier):
			var item = database.data[item_name]
			var item_button = GRID_ITEM_SCENE.instantiate()
			var texture_button = item_button.get_node("PanelContainer/TextureButton")
			var name_label = texture_button.get_node("Name")
			var rarity_label = texture_button.get_node("Rarity")
			var details_button = texture_button.get_node("DetailsButton")
			name_label.get_theme_stylebox("normal").bg_color = G.RARITY_BACKGROUND_COLOR[item.rarity]
			name_label.get_theme_stylebox("normal").bg_color.a = 0.3
			rarity_label.get_theme_stylebox("normal").bg_color = G.RARITY_BACKGROUND_COLOR[item.rarity]
			rarity_label.get_theme_stylebox("normal").bg_color.a = 0.3
			item_button.get_theme_stylebox("panel").border_color = G.RARITY_BACKGROUND_COLOR[item.rarity] + Color(0.6, 0.6, 0.6)
			texture_button.texture_normal = item.texture
			texture_button.get_node("Name").text = item.name
			texture_button.get_node("Rarity").text = G.RARITY_STARS[item.rarity]
			item_button.name = item.name
			add_child(item_button)
			if item.name in DataManager.player_data[item_type].keys():
				texture_button.connect("pressed", Callable(self, "_on_item_button_pressed").bind(item_button))
				texture_button.modulate.a = 0.8
				details_button.connect("pressed", Callable(self, "_on_details_button_pressed").bind(item_name))
				item_button.get_theme_stylebox("panel").border_color.a = 0.8
				move_child(item_button, 0)
			else:
				texture_button.modulate.a = 0.2
				details_button.queue_free()
				item_button.get_theme_stylebox("panel").border_color.a = 0.3
			if item.name == DataManager.player_data["selected_" + item_type]:
				texture_button.modulate.a = 1
				item_button.get_theme_stylebox("panel").border_color.a = 1

func _on_item_button_pressed(selected_button):
	if selected_button.name == DataManager.player_data.selected_player_ship:
		return
	for item_button in get_children():
		var texture_button = item_button.get_node("PanelContainer/TextureButton")
		if item_button.name in DataManager.player_data[item_type].keys():
			texture_button.modulate.a = 0.8
			item_button.get_theme_stylebox("panel").border_color.a = 0.8
		else:
			texture_button.modulate.a = 0.2
			item_button.get_theme_stylebox("panel").border_color.a = 0.3
	selected_button.get_node("PanelContainer/TextureButton").modulate.a = 1
	selected_button.get_theme_stylebox("panel").border_color.a = 1
	Api.select(self, item_type, selected_button.name)
	DataManager.player_data.set("selected_" + item_type, selected_button.name)

func _on_details_button_pressed(item_name):
	details_screen.initialize(item_name)

func _on_api_select_completed(_result: int, _response_code: int, _headers: Array, _body: PackedByteArray, http_request_object: LoadingHTTPRequest):
	http_request_object.clear()
