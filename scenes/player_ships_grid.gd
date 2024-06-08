extends GridContainer

func _ready():
	print(G.player_ship_sprites)
	for ship_name in G.player_ship_sprites.keys():
		var player_ship_button = TextureButton.new()
		player_ship_button.texture_normal = load(G.player_ship_sprites[ship_name].full_path)
		print(player_ship_button)
		self.add_child(player_ship_button)
