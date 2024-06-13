class_name DropItem extends Node2D

var auto_pickup = false

var category: Stuff.CATEGORY = Stuff.CATEGORY.resources
var item_name: String
var tier: int = 1
var amount: float = 1.0

@onready var category_name = Stuff.CATEGORY.keys()[category]

func _ready():
	$Sprite/RarityGlow.rarity = int(tier/3.5) if tier < 20 else 9
	$Sprite/RarityGlow.texture = $Sprite.texture

func _on_area_entered(area):
	if area is Player:
		pick_up()

func pick_up():
	DataManager.player_data[category_name][item_name] += amount
	amount = 0
	clear()

func clear():
	queue_free()
